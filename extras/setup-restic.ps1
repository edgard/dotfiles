<#
.SYNOPSIS
    Backrest Setup Script for Windows

.DESCRIPTION
    Installs and configures Backrest for Windows using the existing shared
    restic repository password file and a SYSTEM startup task.

.PARAMETER Action
    install or uninstall

.EXAMPLE
    .\setup-restic.ps1 install

.EXAMPLE
    .\setup-restic.ps1 uninstall
#>

#Requires -RunAsAdministrator

param(
    [Parameter(Position = 0)]
    [ValidateSet("install", "uninstall")]
    [string]$Action
)

$ErrorActionPreference = "Stop"

$BACKREST_VERSION = "1.13.0"
$BACKREST_TAG = "v$BACKREST_VERSION"
$RESTIC_HOSTNAME = $env:COMPUTERNAME.ToLower()
$TARGET_HOME = [Environment]::GetFolderPath('UserProfile')

$CONFIG_DIR = Join-Path $env:ProgramData "restic-backup"
$PASSWORD_FILE = Join-Path $CONFIG_DIR "password"
$EXCLUDE_FILE = Join-Path $CONFIG_DIR "excludes.txt"
$BACKREST_DIR = Join-Path $CONFIG_DIR "backrest"
$BACKREST_DATA = Join-Path $BACKREST_DIR "data"
$BACKREST_CONFIG_DIR = Join-Path $BACKREST_DIR "config"
$BACKREST_CONFIG = Join-Path $BACKREST_CONFIG_DIR "config.json"
$BACKREST_CACHE = Join-Path $BACKREST_DIR "cache"
$BACKREST_TMP = Join-Path $BACKREST_DIR "tmp"
$BACKREST_BIN = Join-Path $BACKREST_DIR "backrest.exe"
$BACKREST_SCRIPT = Join-Path $BACKREST_DIR "run-backrest.ps1"
$LOG_FILE = Join-Path $CONFIG_DIR "backrest.log"
$TASK_NAME = "BackrestBackup"
$OLD_TASK_NAME = "ResticBackup"
$OLD_BACKUP_SCRIPT = Join-Path $CONFIG_DIR "restic-backup.ps1"

function Set-BackrestRuntimeAcl {
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

function Install-BackrestBinary {
    $arch = if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") { "arm64" } else { "x86_64" }
    $asset = "backrest_Windows_$arch.zip"
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString())
    New-Item -Path $tmp -ItemType Directory -Force | Out-Null

    try {
        $zipPath = Join-Path $tmp "backrest.zip"
        $checksumsPath = Join-Path $tmp "checksums.txt"
        $url = "https://github.com/garethgeorge/backrest/releases/download/$BACKREST_TAG/$asset"
        $checksumsUrl = "https://github.com/garethgeorge/backrest/releases/download/$BACKREST_TAG/backrest_$($BACKREST_VERSION)_checksums.txt"
        Write-Host "==> Installing Backrest $BACKREST_TAG..." -ForegroundColor Green
        Invoke-WebRequest -Uri $url -OutFile $zipPath
        Invoke-WebRequest -Uri $checksumsUrl -OutFile $checksumsPath
        $expected = Get-Content -Path $checksumsPath |
            Where-Object { $_ -match "\s$([regex]::Escape($asset))$" } |
            ForEach-Object { ($_ -split "\s+")[0].ToLowerInvariant() } |
            Select-Object -First 1
        $actual = (Get-FileHash -Algorithm SHA256 -Path $zipPath).Hash.ToLowerInvariant()
        if (-not $expected -or $actual -ne $expected) {
            throw "Backrest checksum verification failed for $asset"
        }
        Expand-Archive -Path $zipPath -DestinationPath $tmp -Force
        Copy-Item -Path (Join-Path $tmp "backrest.exe") -Destination $BACKREST_BIN -Force
    } finally {
        Remove-Item -Path $tmp -Recurse -Force -ErrorAction SilentlyContinue
    }
}

function Write-BackrestExcludes {
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
}

function Write-BackrestLauncher {
    Write-Host "==> Creating Backrest launcher..." -ForegroundColor Green
    $content = @"
`$ErrorActionPreference = "Stop"

`$env:USERPROFILE = "`$env:SystemRoot\System32\Config\SystemProfile"
`$env:BACKREST_CONFIG = "$BACKREST_CONFIG"
`$env:BACKREST_DATA = "$BACKREST_DATA"
`$env:BACKREST_PORT = "127.0.0.1:9898"
`$env:RESTIC_PASSWORD = (Get-Content -Path "$PASSWORD_FILE" -Raw).Trim()
`$env:RESTIC_PASSWORD_FILE = "$PASSWORD_FILE"
`$env:RESTIC_REST_USERNAME = "restic"
`$env:RESTIC_REST_PASSWORD = (Get-Content -Path "$PASSWORD_FILE" -Raw).Trim()
`$env:RESTIC_REPOSITORY = "rest:http://restic.edgard.org:8000/"
`$env:TMPDIR = "$BACKREST_TMP"
`$env:XDG_CACHE_HOME = "$BACKREST_CACHE"

& "$BACKREST_BIN" *>> "$LOG_FILE"
"@
    $content | Set-Content -Path $BACKREST_SCRIPT -Encoding UTF8
}

function Remove-OldResticScheduler {
    $existingTask = Get-ScheduledTask -TaskName $OLD_TASK_NAME -ErrorAction SilentlyContinue
    if ($existingTask) {
        Write-Host "==> Removing old restic scheduled task..." -ForegroundColor Green
        Unregister-ScheduledTask -TaskName $OLD_TASK_NAME -Confirm:$false
    }

    if (Test-Path -LiteralPath $OLD_BACKUP_SCRIPT) {
        Remove-Item -LiteralPath $OLD_BACKUP_SCRIPT -Force
    }
}

function Install-BackrestBackup {
    Write-Host "==> Creating runtime directories..." -ForegroundColor Green
    foreach ($path in @($CONFIG_DIR, $BACKREST_DIR, $BACKREST_DATA, $BACKREST_CONFIG_DIR, $BACKREST_CACHE, $BACKREST_TMP)) {
        New-Item -Path $path -ItemType Directory -Force | Out-Null
    }
    if (-not (Test-Path -LiteralPath $LOG_FILE)) {
        New-Item -Path $LOG_FILE -ItemType File -Force | Out-Null
    }

    if (Test-Path -LiteralPath $PASSWORD_FILE) {
        Write-Host "Using existing repository password file at $PASSWORD_FILE"
    } else {
        $pass = Read-Host "Enter Restic Repository Password" -AsSecureString
        $plainPass = [System.Net.NetworkCredential]::new("", $pass).Password

        if (-not $plainPass) { Write-Error "Password required."; exit 1 }

        $plainPass | Set-Content -Path $PASSWORD_FILE -NoNewline
        Write-Host "Password saved to $PASSWORD_FILE" -ForegroundColor Gray
    }

    Install-BackrestBinary
    Write-BackrestExcludes
    Write-BackrestLauncher

    foreach ($path in @($CONFIG_DIR, $BACKREST_DIR, $BACKREST_DATA, $BACKREST_CONFIG_DIR, $BACKREST_CACHE, $BACKREST_TMP)) {
        Set-BackrestRuntimeAcl -Path $path -IsDirectory
    }
    foreach ($path in @($PASSWORD_FILE, $EXCLUDE_FILE, $BACKREST_BIN, $BACKREST_SCRIPT, $LOG_FILE)) {
        Set-BackrestRuntimeAcl -Path $path
    }

    Remove-OldResticScheduler

    $existingTask = Get-ScheduledTask -TaskName $TASK_NAME -ErrorAction SilentlyContinue
    if ($existingTask) {
        Unregister-ScheduledTask -TaskName $TASK_NAME -Confirm:$false
    }

    Write-Host "==> Creating Backrest startup task..." -ForegroundColor Green
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$BACKREST_SCRIPT`""
    $trigger = New-ScheduledTaskTrigger -AtStartup
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -Priority 7
    $principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest

    Register-ScheduledTask -TaskName $TASK_NAME -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Description "Backrest backup service (runs as SYSTEM)"
    Start-ScheduledTask -TaskName $TASK_NAME

    Write-Host ""
    Write-Host "==> Setup complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Backrest is running locally at http://127.0.0.1:9898" -ForegroundColor Cyan
    Write-Host "Use instance ID: $RESTIC_HOSTNAME"
    Write-Host "Create a Documents plan after pairing with the homelab Backrest server:"
    Write-Host "  Path: $TARGET_HOME\Documents"
    Write-Host "  Exclude file: $EXCLUDE_FILE"
    Write-Host "  Schedule: 0 3 * * *"
    Write-Host "  Repository: shared repo received from homelab"
    Write-Host "Logs: Get-Content '$LOG_FILE' -Tail 50 -Wait"
}

function Uninstall-BackrestBackup {
    Write-Host "==> Uninstalling Backrest backup..." -ForegroundColor Green

    $existingTask = Get-ScheduledTask -TaskName $TASK_NAME -ErrorAction SilentlyContinue
    if ($existingTask) {
        Unregister-ScheduledTask -TaskName $TASK_NAME -Confirm:$false
    }

    Remove-OldResticScheduler

    if (Test-Path -LiteralPath $CONFIG_DIR) {
        Remove-Item -LiteralPath $CONFIG_DIR -Recurse -Force
    }

    Write-Host ""
    Write-Host "==> Uninstall complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Note: Remote backups were not deleted." -ForegroundColor Cyan
}

if (-not $Action) {
    Write-Host "Usage: .\setup-restic.ps1 [install|uninstall]"
    exit 1
}

switch ($Action) {
    "install" { Install-BackrestBackup }
    "uninstall" { Uninstall-BackrestBackup }
}
