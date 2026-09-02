#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
readonly TEMPLATE_DIR="${SCRIPT_DIR}/restic/macos"
readonly CONFIG_DIR="/Library/Application Support/restic-backup"
readonly CACHE_DIR="${CONFIG_DIR}/cache"
readonly PASSWORD_FILE="${CONFIG_DIR}/password"
readonly EXCLUDE_FILE="${CONFIG_DIR}/excludes.txt"
readonly RUNTIME_CONFIG="${CONFIG_DIR}/repository.conf"
readonly BACKUP_SCRIPT="${CONFIG_DIR}/restic-backup"
readonly LOG_FILE="/Library/Logs/restic-backup.log"
readonly PLIST_FILE="/Library/LaunchDaemons/com.restic.backup.plist"

usage() {
    cat <<EOF
Usage:
  sudo $0 install --repository URL [--username USER]
  sudo $0 uninstall
  sudo $0 run
  sudo $0 status
EOF
}

fail() {
    echo "Error: $*" >&2
    exit 1
}

warn_for_http() {
    case "$1" in
        rest:http://*|http://*)
            echo "Warning: repository uses unencrypted HTTP transport." >&2
            ;;
    esac
}

validate_value() {
    local label="$1"
    local value="$2"
    [ -n "$value" ] || fail "$label must not be empty"
    case "$value" in
        *$'\n'*|*$'\r'*) fail "$label must be a single line" ;;
    esac
}

shell_quote() {
    printf "'%s'" "$(printf '%s' "$1" | sed "s/'/'\\\\''/g")"
}

render_template() {
    local source="$1"
    local destination="$2"
    shift 2
    local contents
    contents="$(<"$source")"
    while [ "$#" -gt 0 ]; do
        local key="$1"
        local value="$2"
        shift 2
        contents="${contents//\{\{${key}\}\}/${value}}"
    done
    local temporary
    temporary="$(mktemp "${destination}.XXXXXX")"
    printf '%s\n' "$contents" > "$temporary"
    mv -f "$temporary" "$destination"
}

secure_permissions() {
    chown root:wheel "$CONFIG_DIR" "$CACHE_DIR"
    chmod 700 "$CONFIG_DIR" "$CACHE_DIR"
    [ ! -f "$PASSWORD_FILE" ] || { chown root:wheel "$PASSWORD_FILE"; chmod 600 "$PASSWORD_FILE"; }
    [ ! -f "$RUNTIME_CONFIG" ] || { chown root:wheel "$RUNTIME_CONFIG"; chmod 644 "$RUNTIME_CONFIG"; }
    [ ! -f "$EXCLUDE_FILE" ] || { chown root:wheel "$EXCLUDE_FILE"; chmod 644 "$EXCLUDE_FILE"; }
    [ ! -f "$BACKUP_SCRIPT" ] || { chown root:wheel "$BACKUP_SCRIPT"; chmod 700 "$BACKUP_SCRIPT"; }
    [ ! -f "$LOG_FILE" ] || { chown root:wheel "$LOG_FILE"; chmod 640 "$LOG_FILE"; }
}

install_backup() {
    local repository="$1"
    local username="$2"

    [ "$EUID" -eq 0 ] || fail "install must run as root"
    command -v restic >/dev/null 2>&1 || fail "restic is not installed"
    local restic_bin
    restic_bin="$(command -v restic)"
    local target_user="${SUDO_USER:-${USER:-root}}"
    local target_home
    target_home="$(dscl . -read "/Users/${target_user}" NFSHomeDirectory 2>/dev/null | awk '{print $2}')"
    [ -n "$target_home" ] || fail "could not determine the home directory for ${target_user}"
    local hostname_short
    hostname_short="$(hostname -s | tr '[:upper:]' '[:lower:]')"

    mkdir -p "$CONFIG_DIR" "$CACHE_DIR" "$(dirname "$LOG_FILE")"
    touch "$LOG_FILE"
    if [ ! -f "$PASSWORD_FILE" ]; then
        read -rsp "Enter Restic Repository Password: " repository_password
        echo
        [ -n "$repository_password" ] || fail "repository password cannot be empty"
        (umask 077; printf '%s' "$repository_password" > "$PASSWORD_FILE")
        unset repository_password
    fi

    render_template "$TEMPLATE_DIR/repository.conf.tmpl" "$RUNTIME_CONFIG" \
        REPOSITORY "$(shell_quote "$repository")" \
        USERNAME "$(shell_quote "$username")"
    render_template "$TEMPLATE_DIR/excludes.txt.tmpl" "$EXCLUDE_FILE"
    render_template "$TEMPLATE_DIR/restic-backup.sh.tmpl" "$BACKUP_SCRIPT" \
        PASSWORD_FILE "$(shell_quote "$PASSWORD_FILE")" \
        RUNTIME_CONFIG "$(shell_quote "$RUNTIME_CONFIG")" \
        RESTIC_BIN "$(shell_quote "$restic_bin")" \
        HOSTNAME "$(shell_quote "$hostname_short")" \
        CACHE_DIR "$(shell_quote "$CACHE_DIR")" \
        EXCLUDE_FILE "$(shell_quote "$EXCLUDE_FILE")" \
        LOG_FILE "$(shell_quote "$LOG_FILE")" \
        BACKUP_PATH "$(shell_quote "$target_home/Documents")"
    render_template "$TEMPLATE_DIR/com.restic.backup.plist.tmpl" "$PLIST_FILE" \
        BACKUP_SCRIPT "$BACKUP_SCRIPT" \
        LOG_FILE "$LOG_FILE"
    chmod 644 "$PLIST_FILE"
    chown root:wheel "$PLIST_FILE"
    secure_permissions

    launchctl bootout system/com.restic.backup >/dev/null 2>&1 || true
    launchctl bootstrap system "$PLIST_FILE"
    launchctl enable system/com.restic.backup
    # Preserve the existing first-install behavior without duplicating backups.
    # shellcheck source=/dev/null
    source "$RUNTIME_CONFIG"
    export RESTIC_REPOSITORY RESTIC_REST_USERNAME
    IFS= read -r -d '' RESTIC_REST_PASSWORD < "$PASSWORD_FILE" || true
    export RESTIC_REST_PASSWORD
    if ! "$restic_bin" --retry-lock 30m snapshots \
        --host "$hostname_short" \
        --path "$target_home/Documents" \
        --json 2>/dev/null | grep -q '"id"'; then
        launchctl kickstart system/com.restic.backup
    fi
    unset RESTIC_REST_PASSWORD
    echo "Restic backup installed for ${repository} as ${username}; daily at 03:00."
}

uninstall_backup() {
    [ "$EUID" -eq 0 ] || fail "uninstall must run as root"
    launchctl bootout system/com.restic.backup >/dev/null 2>&1 || true
    rm -f "$PLIST_FILE"
    if [ -d "$CONFIG_DIR" ]; then
        rm -rf "$CONFIG_DIR"
    fi
    rm -f "$LOG_FILE"
    echo "Restic scheduler and local runtime configuration removed; remote backups were retained."
}

action="${1:-}"
[ -n "$action" ] || { usage >&2; exit 1; }
shift

case "$action" in
    install)
        repository=""
        username="restic"
        while [ "$#" -gt 0 ]; do
            case "$1" in
                --repository)
                    [ "$#" -ge 2 ] || fail "--repository requires a URL"
                    repository="$2"
                    shift 2
                    ;;
                --username)
                    [ "$#" -ge 2 ] || fail "--username requires a value"
                    username="$2"
                    shift 2
                    ;;
                *) fail "unknown install option: $1" ;;
            esac
        done
        [ -n "$repository" ] || fail "install requires --repository URL"
        validate_value "repository" "$repository"
        validate_value "username" "$username"
        warn_for_http "$repository"
        install_backup "$repository" "$username"
        ;;
    uninstall)
        [ "$#" -eq 0 ] || fail "uninstall takes no arguments"
        uninstall_backup
        ;;
    run)
        [ "$#" -eq 0 ] || fail "run takes no arguments"
        [ "$EUID" -eq 0 ] || fail "run must run as root"
        [ -x "$BACKUP_SCRIPT" ] || fail "backup runtime is not installed"
        "$BACKUP_SCRIPT"
        ;;
    status)
        [ "$#" -eq 0 ] || fail "status takes no arguments"
        [ "$EUID" -eq 0 ] || fail "status must run as root"
        launchctl print system/com.restic.backup || true
        [ ! -f "$LOG_FILE" ] || tail -n 50 "$LOG_FILE"
        ;;
    *) usage >&2; exit 1 ;;
esac
