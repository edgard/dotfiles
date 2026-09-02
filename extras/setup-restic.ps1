<#
.SYNOPSIS
Installs the Windows Restic backup scheduler.

.EXAMPLE
.\setup-restic.ps1 install -Repository 'rest:https://backup.example/'
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateSet("install", "uninstall", "run", "status")]
    [string]$Action,

    [string]$Repository,

    [string]$RestUsername = "restic"
)

$ErrorActionPreference = "Stop"

function Assert-SingleLineValue {
    param([string]$Name, [string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) {
        throw "$Name must not be empty"
    }
    if ($Value.Contains("`n") -or $Value.Contains("`r")) {
        throw "$Name must be a single line"
    }
}

if ($Action -eq "install") {
    if ([string]::IsNullOrWhiteSpace($Repository)) {
        throw "install requires -Repository URL"
    }
    Assert-SingleLineValue -Name "Repository" -Value $Repository
    Assert-SingleLineValue -Name "RestUsername" -Value $RestUsername
    if ($Repository -match '^(rest:)?http://') {
        Write-Warning "Repository uses unencrypted HTTP transport."
    }
}

$ConfigDir = Join-Path $env:ProgramData "restic-backup"
$CacheDir = Join-Path $ConfigDir "cache"
$PasswordFile = Join-Path $ConfigDir "password"
$ExcludeFile = Join-Path $ConfigDir "excludes.txt"
$RepositoryConfig = Join-Path $ConfigDir "repository.ps1"
$BackupScript = Join-Path $ConfigDir "restic-backup.ps1"
$TaskXml = Join-Path $ConfigDir "scheduled-task.xml"
$LogFile = Join-Path $ConfigDir "restic-backup.log"
$TaskName = "ResticBackup"
$TemplateDir = Join-Path $PSScriptRoot "restic/windows"

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = [Security.Principal.WindowsPrincipal]::new($identity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw "$Action must run as Administrator"
}

function Set-ResticRuntimeAcl {
    param([Parameter(Mandatory = $true)][string]$Path, [switch]$IsDirectory)
    if (-not (Test-Path -LiteralPath $Path)) { return }
    $acl = Get-Acl -LiteralPath $Path
    $acl.SetAccessRuleProtection($true, $false)
    $inheritance = if ($IsDirectory) {
        [Security.AccessControl.InheritanceFlags]"ContainerInherit,ObjectInherit"
    } else {
        [Security.AccessControl.InheritanceFlags]::None
    }
    foreach ($account in @("NT AUTHORITY\SYSTEM", "BUILTIN\Administrators")) {
        $rule = [Security.AccessControl.FileSystemAccessRule]::new(
            $account,
            [Security.AccessControl.FileSystemRights]::FullControl,
            $inheritance,
            [Security.AccessControl.PropagationFlags]::None,
            [Security.AccessControl.AccessControlType]::Allow
        )
        $acl.SetAccessRule($rule)
    }
    Set-Acl -LiteralPath $Path -AclObject $acl
}

function Write-RenderedTemplate {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination,
        [Parameter(Mandatory = $true)][hashtable]$Values
    )
    $content = [IO.File]::ReadAllText($Source)
    foreach ($entry in $Values.GetEnumerator()) {
        $content = $content.Replace("{{$($entry.Key)}}", [string]$entry.Value)
    }
    $temporary = Join-Path (Split-Path $Destination) ".$([IO.Path]::GetRandomFileName())"
    try {
        [IO.File]::WriteAllText($temporary, $content, [Text.UTF8Encoding]::new($false))
        Move-Item -LiteralPath $temporary -Destination $Destination -Force
    } finally {
        Remove-Item -LiteralPath $temporary -Force -ErrorAction SilentlyContinue
    }
}

function ConvertTo-PowerShellSingleQuoted {
    param([string]$Value)
    return "'" + $Value.Replace("'", "''") + "'"
}

function Install-ResticBackup {
    $restic = Get-Command restic -ErrorAction SilentlyContinue
    if (-not $restic) { throw "Restic not found. Install restic.restic first." }

    $targetHome = [Environment]::GetFolderPath("UserProfile")
    New-Item -Path $ConfigDir -ItemType Directory -Force | Out-Null
    New-Item -Path $CacheDir -ItemType Directory -Force | Out-Null
    if (-not (Test-Path -LiteralPath $LogFile)) {
        New-Item -Path $LogFile -ItemType File | Out-Null
    }
    if (-not (Test-Path -LiteralPath $PasswordFile)) {
        $securePassword = Read-Host "Enter Restic Repository Password" -AsSecureString
        $plainPassword = [Net.NetworkCredential]::new("", $securePassword).Password
        if ([string]::IsNullOrEmpty($plainPassword)) { throw "Repository password cannot be empty" }
        [IO.File]::WriteAllText($PasswordFile, $plainPassword, [Text.UTF8Encoding]::new($false))
        $plainPassword = $null
    }

    Write-RenderedTemplate -Source (Join-Path $TemplateDir "repository.ps1.tmpl") -Destination $RepositoryConfig -Values @{
        REPOSITORY = ConvertTo-PowerShellSingleQuoted $Repository
        USERNAME = ConvertTo-PowerShellSingleQuoted $RestUsername
    }
    Copy-Item -LiteralPath (Join-Path $TemplateDir "excludes.txt.tmpl") -Destination $ExcludeFile -Force
    Write-RenderedTemplate -Source (Join-Path $TemplateDir "restic-backup.ps1.tmpl") -Destination $BackupScript -Values @{
        PASSWORD_FILE = ConvertTo-PowerShellSingleQuoted $PasswordFile
        REPOSITORY_CONFIG = ConvertTo-PowerShellSingleQuoted $RepositoryConfig
        RESTIC_BIN = ConvertTo-PowerShellSingleQuoted $restic.Source
        HOSTNAME = ConvertTo-PowerShellSingleQuoted $env:COMPUTERNAME.ToLowerInvariant()
        CACHE_DIR = ConvertTo-PowerShellSingleQuoted $CacheDir
        EXCLUDE_FILE = ConvertTo-PowerShellSingleQuoted $ExcludeFile
        LOG_FILE = ConvertTo-PowerShellSingleQuoted $LogFile
        BACKUP_PATH = ConvertTo-PowerShellSingleQuoted (Join-Path $targetHome "Documents")
    }
    Write-RenderedTemplate -Source (Join-Path $TemplateDir "scheduled-task.xml.tmpl") -Destination $TaskXml -Values @{
        BACKUP_SCRIPT = [Security.SecurityElement]::Escape($BackupScript)
    }

    foreach ($directory in @($ConfigDir, $CacheDir)) { Set-ResticRuntimeAcl -Path $directory -IsDirectory }
    foreach ($file in @($PasswordFile, $ExcludeFile, $RepositoryConfig, $BackupScript, $TaskXml, $LogFile)) {
        Set-ResticRuntimeAcl -Path $file
    }

    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
    Register-ScheduledTask -TaskName $TaskName -Xml ([IO.File]::ReadAllText($TaskXml)) | Out-Null
    . $RepositoryConfig
    $env:RESTIC_PASSWORD_FILE = $PasswordFile
    $env:RESTIC_REST_PASSWORD = [IO.File]::ReadAllText($PasswordFile).Trim()
    $snapshots = & $restic.Source --retry-lock 30m snapshots `
        --host $env:COMPUTERNAME.ToLowerInvariant() `
        --path (Join-Path $targetHome "Documents") `
        --json 2>$null
    if (-not ($snapshots | Select-String -SimpleMatch '"id"' -Quiet)) {
        Start-ScheduledTask -TaskName $TaskName
    }
    Remove-Item Env:\RESTIC_REST_PASSWORD
    Write-Host "Restic backup installed for $Repository as $RestUsername; daily at 03:00."
}

function Uninstall-ResticBackup {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
    if (Test-Path -LiteralPath $ConfigDir) {
        Remove-Item -LiteralPath $ConfigDir -Recurse -Force
    }
    Write-Host "Restic scheduler and local runtime configuration removed; remote backups were retained."
}

switch ($Action) {
    "install" { Install-ResticBackup }
    "uninstall" { Uninstall-ResticBackup }
    "run" {
        if (-not (Test-Path -LiteralPath $BackupScript)) { throw "Backup runtime is not installed" }
        & powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File $BackupScript
    }
    "status" {
        Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue | Format-List TaskName, State
        if (Test-Path -LiteralPath $LogFile) { Get-Content -LiteralPath $LogFile -Tail 50 }
    }
}
