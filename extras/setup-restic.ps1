<#
.SYNOPSIS
    Restic Setup Script for Windows

.DESCRIPTION
    This script installs and configures restic backup for Windows.

    It:
      1. Stores credentials securely in a SYSTEM/Administrators-only runtime directory
      2. Creates exclude file
      3. Installs a Task Scheduler task (runs as SYSTEM, hidden from user)

.PARAMETER Action
    The action to perform: install, uninstall, run, or status

.EXAMPLE
    .\setup-restic.ps1 install

.EXAMPLE
    .\setup-restic.ps1 uninstall

.EXAMPLE
    .\setup-restic.ps1 run

.EXAMPLE
    .\setup-restic.ps1 status

.NOTES
    Run this script as Administrator.

    Install Restic first:
      winget install restic.restic
#>

#Requires -RunAsAdministrator

param(
    [Parameter(Position = 0)]
    [ValidateSet("install", "uninstall", "run", "status")]
    [string]$Action
)

$ErrorActionPreference = "Stop"

# Configuration
$RESTIC_HOSTNAME = $env:COMPUTERNAME.ToLower()
$TARGET_HOME = [Environment]::GetFolderPath('UserProfile')

$BACKUP_PATHS = @(
    "$TARGET_HOME\Documents"
)

$CONFIG_DIR = Join-Path $env:ProgramData "restic-backup"
$CACHE_DIR = Join-Path $CONFIG_DIR "cache"
$PASSWORD_FILE = Join-Path $CONFIG_DIR "password"
$EXCLUDE_FILE = Join-Path $CONFIG_DIR "excludes.txt"
$BACKUP_SCRIPT = Join-Path $CONFIG_DIR "restic-backup.ps1"
$LOG_FILE = Join-Path $CONFIG_DIR "restic-backup.log"
$TASK_NAME = "ResticBackup"

function Set-ResticRuntimeAcl {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [switch]$IsDirectory
    )

    if (-not (Test-Path -LiteralPath $Path)) { return }

    $acl = Get-Acl -LiteralPath $Path
    $acl.SetAccessRuleProtection($true, $false)

    $rights = [System.Security.AccessControl.FileSystemRights]::FullControl
    $accessType = [System.Security.AccessControl.AccessControlType]::Allow

    if ($IsDirectory) {
        $inheritFlags = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit,ObjectInherit"
        $propagationFlags = [System.Security.AccessControl.PropagationFlags]::None
    } else {
        $inheritFlags = [System.Security.AccessControl.InheritanceFlags]::None
        $propagationFlags = [System.Security.AccessControl.PropagationFlags]::None
    }

    foreach ($identity in @("NT AUTHORITY\SYSTEM", "BUILTIN\Administrators")) {
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($identity, $rights, $inheritFlags, $propagationFlags, $accessType)
        $acl.SetAccessRule($rule)
    }

    Set-Acl -LiteralPath $Path -AclObject $acl
}

function Set-ResticEnvironment {
    $env:USERPROFILE = "$env:SystemRoot\System32\Config\SystemProfile"
    $env:RESTIC_CACHE_DIR = $CACHE_DIR
    $env:RESTIC_PASSWORD_FILE = $PASSWORD_FILE
    $env:RESTIC_REST_USERNAME = "restic"
    $env:RESTIC_REST_PASSWORD = (Get-Content -Path $PASSWORD_FILE -Raw).Trim()
    $env:RESTIC_REPOSITORY = "rest:http://restic.edgard.org:8000/"
}

function Install-ResticBackup {
    # Check for Restic CLI and get full path
    $resticCmd = Get-Command restic -ErrorAction SilentlyContinue
    if (-not $resticCmd) {
        Write-Error "Restic not found. Please install: winget install restic.restic"
        exit 1
    }
    $RESTIC_BIN = $resticCmd.Source

    # Create SYSTEM/Administrators-only runtime directory
    Write-Host "==> Creating runtime directory..." -ForegroundColor Green
    New-Item -Path $CONFIG_DIR -ItemType Directory -Force | Out-Null
    New-Item -Path $CACHE_DIR -ItemType Directory -Force | Out-Null
    if (-not (Test-Path -LiteralPath $LOG_FILE)) {
        New-Item -Path $LOG_FILE -ItemType File -Force | Out-Null
    }
    Set-ResticRuntimeAcl -Path $CONFIG_DIR -IsDirectory
    Set-ResticRuntimeAcl -Path $CACHE_DIR -IsDirectory
    Set-ResticRuntimeAcl -Path $LOG_FILE

    # Retrieve or prompt for password
    if (Test-Path $PASSWORD_FILE) {
        Write-Host "Using existing password file at $PASSWORD_FILE"
    } else {
        $pass = Read-Host "Enter Restic Repository Password" -AsSecureString
        $plainPass = [System.Net.NetworkCredential]::new("", $pass).Password

        if (-not $plainPass) { Write-Error "Password required."; exit 1 }

        $plainPass | Set-Content -Path $PASSWORD_FILE -NoNewline
        Set-ResticRuntimeAcl -Path $PASSWORD_FILE
        Write-Host "Password saved to $PASSWORD_FILE" -ForegroundColor Gray
    }

    Set-ResticRuntimeAcl -Path $PASSWORD_FILE
    Set-ResticEnvironment

    # Create exclude file
    Write-Host "==> Creating exclude patterns..." -ForegroundColor Green
    @"
`$RECYCLE.BIN
System Volume Information
.venv
node_modules
__pycache__
*.tmp
*.temp
Thumbs.db
desktop.ini
"@ | Set-Content -Path $EXCLUDE_FILE -Encoding UTF8
    Set-ResticRuntimeAcl -Path $EXCLUDE_FILE
    Write-Host "Exclude file created at $EXCLUDE_FILE"

    # Create backup script
    Write-Host "==> Creating backup script..." -ForegroundColor Green
    $backupScriptContent = @"
# Restic Backup Script for Windows (runs as SYSTEM)

`$PASSWORD_FILE = "$PASSWORD_FILE"
`$RESTIC_BIN = "$RESTIC_BIN"
`$HOSTNAME = "$RESTIC_HOSTNAME"
`$CACHE_DIR = "$CACHE_DIR"
`$EXCLUDE_FILE = "$EXCLUDE_FILE"
`$LOG_FILE = "$LOG_FILE"
`$BACKUP_PATH = "$TARGET_HOME\Documents"

`$env:USERPROFILE = "`$env:SystemRoot\System32\Config\SystemProfile"
`$env:RESTIC_CACHE_DIR = `$CACHE_DIR
`$env:RESTIC_PASSWORD_FILE = `$PASSWORD_FILE
`$env:RESTIC_REST_USERNAME = "restic"
`$env:RESTIC_REST_PASSWORD = (Get-Content -Path `$PASSWORD_FILE -Raw).Trim()
`$env:RESTIC_REPOSITORY = "rest:http://restic.edgard.org:8000/"

function Log {
    param([string]`$Message)
    `$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "`$timestamp - `$Message" | Out-File -FilePath `$LOG_FILE -Append
}

Log "Starting backup..."

`$backupOutput = & `$RESTIC_BIN --retry-lock 30m backup ``
    --host `$HOSTNAME ``
    --tag documents ``
    --exclude-file `$EXCLUDE_FILE ``
    --exclude-caches ``
    --verbose ``
    `$BACKUP_PATH 2>&1

`$backupOutput | Out-File -FilePath `$LOG_FILE -Append
`$exitCode = `$LASTEXITCODE

if (`$exitCode -ne 0) {
    Log "Backup failed with exit code `$exitCode"
    exit `$exitCode
}

Log "Backup complete."
"@
    $backupScriptContent | Set-Content -Path $BACKUP_SCRIPT -Encoding UTF8
    Set-ResticRuntimeAcl -Path $BACKUP_SCRIPT
    Write-Host "Backup script created at $BACKUP_SCRIPT"

    # Create scheduled task (runs as SYSTEM, hidden)
    Write-Host "==> Creating scheduled task..." -ForegroundColor Green
    $existingTask = Get-ScheduledTask -TaskName $TASK_NAME -ErrorAction SilentlyContinue
    if ($existingTask) {
        Unregister-ScheduledTask -TaskName $TASK_NAME -Confirm:$false
    }

    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$BACKUP_SCRIPT`""
    $trigger = New-ScheduledTaskTrigger -Daily -At 3:00AM
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -Priority 7
    $principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest

    Register-ScheduledTask -TaskName $TASK_NAME -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Description "Daily Restic backup at 3:00 AM (runs as SYSTEM)"
    Write-Host "Scheduled task '$TASK_NAME' created (runs daily at 3:00 AM as SYSTEM, hidden)."

    # Run initial backup via scheduled task
    Write-Host "==> Running initial backup..." -ForegroundColor Green
    $skipInitial = $false
    foreach ($path in $BACKUP_PATHS) {
        if (Test-Path $path) {
            try {
                $snapshotsJson = & $RESTIC_BIN --retry-lock 30m snapshots --host $RESTIC_HOSTNAME --path $path --json 2>&1
                $snapshots = $snapshotsJson | ConvertFrom-Json -ErrorAction SilentlyContinue
                if ($snapshots -and @($snapshots).Count -gt 0) {
                    Write-Host "Snapshots already exist for $path, skipping initial backup."
                    $skipInitial = $true
                }
            } catch {
                # No snapshots or error parsing, continue to create
            }
        }
    }

    if (-not $skipInitial) {
        Write-Host "Triggering scheduled task for initial backup..."
        Start-ScheduledTask -TaskName $TASK_NAME
        Write-Host "Initial backup started. Check log for progress: Get-Content '$LOG_FILE' -Tail 50 -Wait"
    }

    Write-Host ""
    Write-Host "==> Setup complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "The backup runs daily at 3:00 AM as SYSTEM (hidden from user)." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Useful commands:" -ForegroundColor Cyan
    Write-Host "  .\setup-restic.ps1 run                        # Run backup manually"
    Write-Host "  Get-Content '$LOG_FILE' -Tail 50              # View backup log"
    Write-Host ""
    Write-Host "For other restic commands, run as Administrator:" -ForegroundColor Cyan
    Write-Host "  `$env:USERPROFILE = `"`$env:SystemRoot\System32\Config\SystemProfile`""
    Write-Host "  `$env:RESTIC_CACHE_DIR = '$CACHE_DIR'"
    Write-Host "  `$env:RESTIC_PASSWORD_FILE = '$PASSWORD_FILE'"
    Write-Host "  `$env:RESTIC_REST_USERNAME = 'restic'"
    Write-Host "  `$env:RESTIC_REST_PASSWORD = (Get-Content '$PASSWORD_FILE' -Raw).Trim()"
    Write-Host "  `$env:RESTIC_REPOSITORY = 'rest:http://restic.edgard.org:8000/'"
    Write-Host "  restic --retry-lock 30m snapshots --host $RESTIC_HOSTNAME  # List snapshots for this host"
    Write-Host "  restic --retry-lock 30m snapshots                         # List all snapshots"
}

function Uninstall-ResticBackup {
    Write-Host "==> Uninstalling restic backup..." -ForegroundColor Green

    # Remove scheduled task
    $existingTask = Get-ScheduledTask -TaskName $TASK_NAME -ErrorAction SilentlyContinue
    if ($existingTask) {
        Write-Host "Removing scheduled task..."
        Unregister-ScheduledTask -TaskName $TASK_NAME -Confirm:$false
    }

    # Remove config directory
    if (Test-Path $CONFIG_DIR) {
        Write-Host "Removing config directory..."
        Remove-Item -Path $CONFIG_DIR -Recurse -Force
    }

    Write-Host ""
    Write-Host "==> Uninstall complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Note: Restic binary was not removed. To remove it: winget uninstall restic.restic" -ForegroundColor Cyan
    Write-Host "Note: Remote backups were not deleted." -ForegroundColor Cyan
}

function Invoke-ResticBackup {
    if (-not (Test-Path -LiteralPath $BACKUP_SCRIPT)) {
        Write-Error "Backup script not found at $BACKUP_SCRIPT. Run install first."
        exit 1
    }

    & powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File $BACKUP_SCRIPT
}

function Get-ResticBackupStatus {
    $existingTask = Get-ScheduledTask -TaskName $TASK_NAME -ErrorAction SilentlyContinue
    if ($existingTask) {
        $existingTask | Format-List TaskName, State, LastRunTime, LastTaskResult, NextRunTime
    } else {
        Write-Host "Scheduled task '$TASK_NAME' is not installed." -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "Recent logs:" -ForegroundColor Cyan
    if (Test-Path -LiteralPath $LOG_FILE) {
        Get-Content -Path $LOG_FILE -Tail 50
    } else {
        Write-Host "No log file found at $LOG_FILE"
    }
}

# Main
if (-not $Action) {
    Write-Host "Usage: .\setup-restic.ps1 [install|uninstall|run|status]"
    exit 1
}

switch ($Action) {
    "install" { Install-ResticBackup }
    "uninstall" { Uninstall-ResticBackup }
    "run" { Invoke-ResticBackup }
    "status" { Get-ResticBackupStatus }
}
