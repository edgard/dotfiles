#!/bin/bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Backrest Setup Script for macOS
#
# USAGE:
#   sudo ./setup-restic.sh install
#   sudo ./setup-restic.sh uninstall
#
# This script:
#   1. Installs the pinned Backrest release
#   2. Reuses the existing restic repository password file
#   3. Creates exclude patterns for the Documents backup plan
#   4. Installs a root launchd daemon for Backrest
#   5. Removes the old plain-restic launchd scheduler
# -----------------------------------------------------------------------------

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root: sudo $0 [install|uninstall]"
    exit 1
fi

BACKREST_VERSION="1.13.0"
BACKREST_TAG="v$BACKREST_VERSION"
RESTIC_HOSTNAME=$(hostname -s | tr '[:upper:]' '[:lower:]')
TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME=$(eval echo "~$TARGET_USER")

CONFIG_DIR="/Library/Application Support/restic-backup"
PASSWORD_FILE="$CONFIG_DIR/password"
EXCLUDE_FILE="$CONFIG_DIR/excludes.txt"
BACKREST_DIR="$CONFIG_DIR/backrest"
BACKREST_DATA="$BACKREST_DIR/data"
BACKREST_CONFIG_DIR="$BACKREST_DIR/config"
BACKREST_CONFIG="$BACKREST_CONFIG_DIR/config.json"
BACKREST_CACHE="$BACKREST_DIR/cache"
BACKREST_TMP="$BACKREST_DIR/tmp"
BACKREST_BIN="/usr/local/bin/backrest"
BACKREST_WRAPPER="$BACKREST_DIR/run-backrest"
LOG_FILE="/Library/Logs/backrest.log"
PLIST_FILE="/Library/LaunchDaemons/com.backrest.backup.plist"
OLD_PLIST_FILE="/Library/LaunchDaemons/com.restic.backup.plist"
OLD_BACKUP_SCRIPT="$CONFIG_DIR/restic-backup"

secure_runtime_permissions() {
    chown root:wheel "$CONFIG_DIR" "$BACKREST_DIR" "$BACKREST_DATA" "$BACKREST_CONFIG_DIR" "$BACKREST_CACHE" "$BACKREST_TMP"
    chmod 700 "$CONFIG_DIR" "$BACKREST_DIR" "$BACKREST_DATA" "$BACKREST_CONFIG_DIR" "$BACKREST_CACHE" "$BACKREST_TMP"

    if [ -f "$PASSWORD_FILE" ]; then
        chown root:wheel "$PASSWORD_FILE"
        chmod 600 "$PASSWORD_FILE"
    fi

    if [ -f "$EXCLUDE_FILE" ]; then
        chown root:wheel "$EXCLUDE_FILE"
        chmod 644 "$EXCLUDE_FILE"
    fi

    if [ -f "$BACKREST_WRAPPER" ]; then
        chown root:wheel "$BACKREST_WRAPPER"
        chmod 700 "$BACKREST_WRAPPER"
    fi

    if [ -f "$LOG_FILE" ]; then
        chown root:wheel "$LOG_FILE"
        chmod 640 "$LOG_FILE"
    fi
}

install_backrest_binary() {
    local machine arch asset tmp expected actual

    machine=$(uname -m)
    case "$machine" in
        arm64)
            arch="arm64"
            ;;
        x86_64)
            arch="x86_64"
            ;;
        *)
            echo "Unsupported macOS architecture: $machine"
            exit 1
            ;;
    esac

    asset="backrest_Darwin_${arch}.tar.gz"
    tmp=$(mktemp -d)

    echo "==> Installing Backrest $BACKREST_TAG..."
    mkdir -p "$(dirname "$BACKREST_BIN")"
    curl -fsSL "https://github.com/garethgeorge/backrest/releases/download/${BACKREST_TAG}/${asset}" -o "$tmp/backrest.tar.gz"
    curl -fsSL "https://github.com/garethgeorge/backrest/releases/download/${BACKREST_TAG}/backrest_${BACKREST_VERSION}_checksums.txt" -o "$tmp/checksums.txt"
    expected=$(awk -v asset="$asset" '$2 == asset {print $1}' "$tmp/checksums.txt")
    actual=$(shasum -a 256 "$tmp/backrest.tar.gz" | awk '{print $1}')
    if [ -z "$expected" ] || [ "$actual" != "$expected" ]; then
        echo "Backrest checksum verification failed for $asset"
        rm -rf "$tmp"
        exit 1
    fi
    tar -xzf "$tmp/backrest.tar.gz" -C "$tmp"
    install -m 0755 "$tmp/backrest" "$BACKREST_BIN"
    rm -rf "$tmp"
}

write_excludes() {
    echo "==> Creating exclude patterns..."
    cat > "$EXCLUDE_FILE" <<'EOF'
.DS_Store
.Trash
.venv
node_modules
__pycache__
*.tmp
*.temp
EOF
}

write_wrapper() {
    echo "==> Creating Backrest wrapper..."
    cat > "$BACKREST_WRAPPER" <<EOF
#!/bin/bash
set -euo pipefail

export HOME="/var/root"
export BACKREST_CONFIG="$BACKREST_CONFIG"
export BACKREST_DATA="$BACKREST_DATA"
export BACKREST_PORT="127.0.0.1:9898"
export RESTIC_PASSWORD="\$(cat "$PASSWORD_FILE")"
export RESTIC_PASSWORD_FILE="$PASSWORD_FILE"
export RESTIC_REST_USERNAME="restic"
export RESTIC_REST_PASSWORD="\$(cat "$PASSWORD_FILE")"
export RESTIC_REPOSITORY="rest:http://restic.edgard.org:8000/"
export TMPDIR="$BACKREST_TMP"
export XDG_CACHE_HOME="$BACKREST_CACHE"

exec "$BACKREST_BIN"
EOF
}

remove_old_restic_scheduler() {
    if [ -f "$OLD_PLIST_FILE" ]; then
        echo "==> Removing old restic launchd daemon..."
        launchctl unload "$OLD_PLIST_FILE" 2>/dev/null || true
        rm -f "$OLD_PLIST_FILE"
    fi

    if [ -f "$OLD_BACKUP_SCRIPT" ]; then
        rm -f "$OLD_BACKUP_SCRIPT"
    fi
}

write_launchd_daemon() {
    echo "==> Creating Backrest launchd daemon..."
    cat > "$PLIST_FILE" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.backrest.backup</string>
    <key>ProgramArguments</key>
    <array>
        <string>$BACKREST_WRAPPER</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$LOG_FILE</string>
    <key>StandardErrorPath</key>
    <string>$LOG_FILE</string>
    <key>Nice</key>
    <integer>10</integer>
    <key>LowPriorityIO</key>
    <true/>
    <key>ProcessType</key>
    <string>Background</string>
</dict>
</plist>
EOF
    chmod 644 "$PLIST_FILE"
    chown root:wheel "$PLIST_FILE"
}

install_backrest() {
    echo "==> Creating runtime directories..."
    mkdir -p "$CONFIG_DIR" "$BACKREST_DATA" "$BACKREST_CONFIG_DIR" "$BACKREST_CACHE" "$BACKREST_TMP"
    mkdir -p "$(dirname "$LOG_FILE")"
    touch "$LOG_FILE"

    if [ -f "$PASSWORD_FILE" ]; then
        echo "Using existing repository password file at $PASSWORD_FILE"
    else
        read -rsp "Enter Restic Repository Password: " RESTIC_PASSWORD
        echo ""

        if [ -z "$RESTIC_PASSWORD" ]; then
            echo "Password cannot be empty."
            exit 1
        fi

        printf '%s' "$RESTIC_PASSWORD" > "$PASSWORD_FILE"
        echo "Password saved to $PASSWORD_FILE"
    fi

    install_backrest_binary
    write_excludes
    write_wrapper
    secure_runtime_permissions
    remove_old_restic_scheduler
    write_launchd_daemon

    launchctl unload "$PLIST_FILE" 2>/dev/null || true
    launchctl load "$PLIST_FILE"

    echo ""
    echo "==> Setup complete!"
    echo ""
    echo "Backrest is running locally at http://127.0.0.1:9898"
    echo "Use instance ID: $RESTIC_HOSTNAME"
    echo "Create a Documents plan after pairing with the homelab Backrest server:"
    echo "  Path: $TARGET_HOME/Documents"
    echo "  Exclude file: $EXCLUDE_FILE"
    echo "  Schedule: 0 3 * * *"
    echo "  Repository: shared repo received from homelab"
    echo ""
    echo "Grant Full Disk Access to $BACKREST_BIN if macOS blocks Documents access."
    echo "Logs: tail -f \"$LOG_FILE\""
}

uninstall_backrest() {
    echo "==> Uninstalling Backrest backup..."

    if [ -f "$PLIST_FILE" ]; then
        launchctl unload "$PLIST_FILE" 2>/dev/null || true
        rm -f "$PLIST_FILE"
    fi

    remove_old_restic_scheduler
    rm -rf "$CONFIG_DIR"
    rm -f "$LOG_FILE"

    echo ""
    echo "==> Uninstall complete!"
    echo ""
    echo "Note: Backrest binary was not removed: $BACKREST_BIN"
    echo "Note: Remote backups were not deleted."
}

case "${1:-}" in
    install)
        install_backrest
        ;;
    uninstall)
        uninstall_backrest
        ;;
    *)
        echo "Usage: sudo $0 [install|uninstall]"
        exit 1
        ;;
esac
