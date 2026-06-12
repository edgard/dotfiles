#!/bin/bash
# shellcheck disable=SC2016
set -euo pipefail

SCRIPT="extras/setup-restic.ps1"

assert_contains() {
    local needle="$1"

    if ! grep -Fq "$needle" "$SCRIPT"; then
        echo "Expected $SCRIPT to contain: $needle" >&2
        exit 1
    fi
}

assert_not_contains() {
    local needle="$1"

    if grep -Fq "$needle" "$SCRIPT"; then
        echo "Expected $SCRIPT not to contain: $needle" >&2
        exit 1
    fi
}

# The needles below intentionally include PowerShell syntax that should be
# matched literally in the installer source.
assert_contains '$CONFIG_DIR = Join-Path $env:ProgramData "restic-backup"'
assert_contains '$CACHE_DIR = Join-Path $CONFIG_DIR "cache"'
assert_contains '$LOG_FILE = Join-Path $CONFIG_DIR "restic-backup.log"'
assert_contains 'function Set-ResticRuntimeAcl'
assert_contains '$env:USERPROFILE = "$env:SystemRoot\System32\Config\SystemProfile"'
assert_contains '$env:RESTIC_CACHE_DIR = $CACHE_DIR'
assert_contains '$env:RESTIC_PASSWORD_FILE = $PASSWORD_FILE'
assert_contains '$env:RESTIC_REST_USERNAME = "restic"'
assert_contains '$env:RESTIC_REST_PASSWORD = (Get-Content -Path $PASSWORD_FILE -Raw).Trim()'
assert_contains '$env:RESTIC_REPOSITORY = "rest:http://restic.edgard.org:8000/"'
assert_contains 'Set-ResticRuntimeAcl -Path $CONFIG_DIR -IsDirectory'
assert_contains 'Set-ResticRuntimeAcl -Path $BACKUP_SCRIPT'

assert_not_contains '$CONFIG_DIR = "$TARGET_HOME\AppData\Local\restic"'
assert_not_contains '$env:RESTIC_PASSWORD ='
assert_not_contains 'rest:http://restic:$($env:RESTIC_PASSWORD)@restic.edgard.org:8000/'
assert_not_contains 'Grant SYSTEM read access to config directory'
