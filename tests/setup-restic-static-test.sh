#!/bin/bash
# shellcheck disable=SC2016
set -euo pipefail

SCRIPT="extras/setup-restic.sh"

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

# The needles below intentionally include shell syntax that should be matched
# literally in the installer source.
assert_contains 'CONFIG_DIR="/Library/Application Support/restic-backup"'
assert_contains 'CACHE_DIR="$CONFIG_DIR/cache"'
assert_contains 'LOG_FILE="/Library/Logs/restic-backup.log"'
assert_contains 'export HOME="/var/root"'
assert_contains 'export RESTIC_CACHE_DIR="$CACHE_DIR"'
assert_contains 'export RESTIC_PASSWORD_FILE="$PASSWORD_FILE"'
assert_contains 'export RESTIC_REST_USERNAME="restic"'
assert_contains 'RESTIC_REST_PASSWORD="$(cat "$PASSWORD_FILE")"'
assert_contains 'export RESTIC_REST_PASSWORD'
assert_contains 'export RESTIC_REPOSITORY="rest:http://restic.edgard.org:8000/"'
assert_contains 'chmod 700 "$BACKUP_SCRIPT"'
assert_contains 'chown root:wheel "$BACKUP_SCRIPT"'
assert_contains 'chmod 640 "$LOG_FILE"'

assert_not_contains 'RESTIC_REPOSITORY="rest:http://restic:${RESTIC_PASSWORD}@restic.edgard.org:8000/"'
assert_not_contains 'RESTIC_PASSWORD="$(cat "$PASSWORD_FILE")"'
assert_not_contains 'export RESTIC_PASSWORD='
assert_not_contains 'OLD_CONFIG_DIR='
assert_not_contains 'OLD_PASSWORD_FILE='
assert_not_contains 'Migrating password from old user runtime directory'
