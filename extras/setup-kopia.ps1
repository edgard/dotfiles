# -----------------------------------------------------------------------------
# Kopia Setup Script for Windows
#
# INSTALLATION INSTRUCTIONS:
#
# Install KopiaUI:
#   winget install Kopia.KopiaUI
#
# The first time you run this script, it will prompt you for the repository
# password. It will be securely encrypted (DPAPI) and stored in the Registry.
# -----------------------------------------------------------------------------

$ErrorActionPreference = "Stop"

# Locate Kopia CLI
if (Get-Command kopia -ErrorAction SilentlyContinue) {
    $KOPIA_CMD = "kopia"
} else {
    $localPath = "$env:LOCALAPPDATA\Programs\KopiaUI\resources\server\kopia.exe"
    $progPath = "$env:ProgramFiles\KopiaUI\resources\server\kopia.exe"

    if (Test-Path $localPath) {
        $KOPIA_CMD = $localPath
    } elseif (Test-Path $progPath) {
        $KOPIA_CMD = $progPath
    } else {
        Write-Error "Kopia CLI not found in PATH and KopiaUI not found in standard locations."
        Write-Error "Please install KopiaUI: winget install Kopia.KopiaUI"
        exit 1
    }
}

$KOPIA_SERVER = "https://kopia.edgard.org:51515"

# Retrieve Password (Registry + DPAPI)
Add-Type -AssemblyName System.Security
$RegPath = "HKCU:\Software\KopiaSetup"
$RegKey  = "RepoPassword"

if (Test-Path $RegPath) {
    try {
        $encryptedBytes = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction Stop | Select-Object -ExpandProperty $RegKey
        $decryptedBytes = [System.Security.Cryptography.ProtectedData]::Unprotect(
            $encryptedBytes, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser
        )
        $env:KOPIA_PASSWORD = [System.Text.Encoding]::UTF8.GetString($decryptedBytes)
    } catch {
        # Ignore errors, will prompt below
    }
}

if (-not $env:KOPIA_PASSWORD) {
    $pass = Read-Host "Enter Kopia Server Password (for user 'admin')" -AsSecureString
    $plainPass = [System.Net.NetworkCredential]::new("", $pass).Password

    if (-not $plainPass) { Write-Error "Password required."; exit 1 }

    $bytes = [System.Text.Encoding]::UTF8.GetBytes($plainPass)
    $encryptedBytes = [System.Security.Cryptography.ProtectedData]::Protect(
        $bytes, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser
    )
    if (-not (Test-Path $RegPath)) { New-Item -Path $RegPath -Force | Out-Null }
    Set-ItemProperty -Path $RegPath -Name $RegKey -Value $encryptedBytes
    Write-Host "Password securely saved to Registry." -ForegroundColor Gray

    $env:KOPIA_PASSWORD = $plainPass
}

$KOPIA_HOSTNAME = $env:COMPUTERNAME.ToLower()

$BACKUP_PATHS = @(
    "$env:USERPROFILE\Documents"
)

Write-Host "==> Connecting to Kopia server..." -ForegroundColor Green
& $KOPIA_CMD repository connect server `
    --url="$KOPIA_SERVER" `
    --password="$KOPIA_PASSWORD" `
    --override-hostname="$KOPIA_HOSTNAME" `
    --override-username="admin"

Write-Host "==> Configuring snapshot policies..." -ForegroundColor Green
foreach ($path in $BACKUP_PATHS) {
    if (Test-Path $path) {
        Write-Host "Configuring policy for $path"
        & $KOPIA_CMD policy set "$path" `
            --snapshot-time=03:00 `
            --run-missed=true `
            --add-ignore=`$RECYCLE.BIN `
            --add-ignore='System Volume Information' `
            --add-ignore='**/.venv' `
            --add-ignore='**/node_modules'
    }
}

Write-Host "==> Creating initial snapshots..." -ForegroundColor Green
foreach ($path in $BACKUP_PATHS) {
    if (Test-Path $path) {
        $snapshots = & $KOPIA_CMD snapshot list "$path" 2>&1
        if ($snapshots) {
            Write-Host "Snapshots already exist for $path, skipping initial creation."
        } else {
            Write-Host "Creating initial snapshot of $path"
            & $KOPIA_CMD snapshot create "$path"
            if ($LASTEXITCODE -ne 0) {
                Write-Warning "Failed to create snapshot of $path, continuing..."
            }
        }
    }
}

Write-Host ""
Write-Host "==> Setup complete!" -ForegroundColor Green
