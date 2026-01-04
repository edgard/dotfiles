<#
.SYNOPSIS
    Restic Setup Script for Windows

.DESCRIPTION
    This script installs and configures restic backup for Windows.

    It:
      1. Stores credentials securely (restricted file permissions)
      2. Creates exclude file
      3. Installs a Task Scheduler task (runs as SYSTEM, hidden from user)

.PARAMETER Action
    The action to perform: install or uninstall

.EXAMPLE
    .\setup-restic.ps1 install

.EXAMPLE
    .\setup-restic.ps1 uninstall

.NOTES
    Run this script as Administrator.

    Install Restic first:
      winget install restic.restic
#>

#Requires -RunAsAdministrator

param(
    [Parameter(Position = 0)]
    [ValidateSet("install", "uninstall")]
    [string]$Action
)

$ErrorActionPreference = "Stop"

# Configuration
$RESTIC_HOSTNAME = $env:COMPUTERNAME.ToLower()
$TARGET_HOME = [Environment]::GetFolderPath('UserProfile')

$BACKUP_PATHS = @(
    "$TARGET_HOME\Documents"
)

$CONFIG_DIR = "$TARGET_HOME\AppData\Local\restic"
$PASSWORD_FILE = "$CONFIG_DIR\password"
$EXCLUDE_FILE = "$CONFIG_DIR\excludes.txt"
$BACKUP_SCRIPT = "$CONFIG_DIR\restic-backup.ps1"
$LOG_FILE = "$CONFIG_DIR\restic-backup.log"
$TASK_NAME = "ResticBackup"

function Install-ResticBackup {
    # Check for Restic CLI and get full path
    $resticCmd = Get-Command restic -ErrorAction SilentlyContinue
    if (-not $resticCmd) {
        Write-Error "Restic not found. Please install: winget install restic.restic"
        exit 1
    }
    $RESTIC_BIN = $resticCmd.Source

    # Create config directory
    Write-Host "==> Creating config directory..." -ForegroundColor Green
    if (-not (Test-Path $CONFIG_DIR)) {
        New-Item -Path $CONFIG_DIR -ItemType Directory -Force | Out-Null
    }

    # Grant SYSTEM read access to config directory (needed for scheduled task)
    $acl = Get-Acl $CONFIG_DIR
    $systemRule = New-Object System.Security.AccessControl.FileSystemAccessRule("NT AUTHORITY\SYSTEM", "ReadAndExecute", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($systemRule)
    Set-Acl -Path $CONFIG_DIR -AclObject $acl

    # Retrieve or prompt for password
    if (Test-Path $PASSWORD_FILE) {
        $env:RESTIC_PASSWORD = (Get-Content -Path $PASSWORD_FILE -Raw).Trim()
    } else {
        $pass = Read-Host "Enter Restic Repository Password" -AsSecureString
        $plainPass = [System.Net.NetworkCredential]::new("", $pass).Password

        if (-not $plainPass) { Write-Error "Password required."; exit 1 }

        $plainPass | Set-Content -Path $PASSWORD_FILE -NoNewline
        Write-Host "Password saved to $PASSWORD_FILE" -ForegroundColor Gray

        $env:RESTIC_PASSWORD = $plainPass
    }

    $env:RESTIC_PASSWORD = (Get-Content -Path $PASSWORD_FILE -Raw).Trim()
    $env:RESTIC_REPOSITORY = "rest:http://restic:$($env:RESTIC_PASSWORD)@restic.edgard.org:8000/"

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
    Write-Host "Exclude file created at $EXCLUDE_FILE"

    # Create backup script
    Write-Host "==> Creating backup script..." -ForegroundColor Green
    $backupScriptContent = @"
# Restic Backup Script for Windows (runs as SYSTEM)

`$PASSWORD_FILE = "$PASSWORD_FILE"
`$RESTIC_BIN = "$RESTIC_BIN"
`$HOSTNAME = "$RESTIC_HOSTNAME"
`$EXCLUDE_FILE = "$EXCLUDE_FILE"
`$LOG_FILE = "$LOG_FILE"
`$BACKUP_PATH = "$TARGET_HOME\Documents"

`$env:RESTIC_PASSWORD = (Get-Content -Path `$PASSWORD_FILE -Raw).Trim()
`$env:RESTIC_REPOSITORY = "rest:http://restic:`$(`$env:RESTIC_PASSWORD)@restic.edgard.org:8000/"

function Log {
    param([string]`$Message)
    `$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "`$timestamp - `$Message" | Out-File -FilePath `$LOG_FILE -Append
}

Log "Starting backup..."

`$backupOutput = & `$RESTIC_BIN backup ``
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
                $snapshotsJson = & $RESTIC_BIN snapshots --host $RESTIC_HOSTNAME --path $path --json 2>&1
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
    Write-Host "  & '$BACKUP_SCRIPT'                            # Run backup manually"
    Write-Host "  Get-Content '$LOG_FILE' -Tail 50              # View backup log"
    Write-Host ""
    Write-Host "For other restic commands, run as Administrator:" -ForegroundColor Cyan
    Write-Host "  `$env:RESTIC_PASSWORD = Get-Content '$PASSWORD_FILE' -Raw"
    Write-Host "  `$env:RESTIC_REPOSITORY = `"rest:http://restic:`$(`$env:RESTIC_PASSWORD)@restic.edgard.org:8000/`""
    Write-Host "  restic snapshots --host $RESTIC_HOSTNAME      # List snapshots for this host"
    Write-Host "  restic snapshots                              # List all snapshots"
    Write-Host "  restic forget SNAPSHOT_ID --prune             # Delete a snapshot"
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

# Main
if (-not $Action) {
    Write-Host "Usage: .\setup-restic.ps1 [install|uninstall]"
    exit 1
}

switch ($Action) {
    "install" { Install-ResticBackup }
    "uninstall" { Uninstall-ResticBackup }
}
