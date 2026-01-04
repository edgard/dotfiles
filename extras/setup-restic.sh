#!/bin/bash
set -e

# -----------------------------------------------------------------------------
# Restic Setup Script for macOS
#
# USAGE:
#   sudo ./setup-restic.sh install    # Install and configure restic backup
#   sudo ./setup-restic.sh uninstall  # Remove restic backup configuration
#
# INSTALLATION INSTRUCTIONS:
#
# Install Restic:
#   brew install restic
#
# The first time you run this script, it will prompt you for the repository
# password. It will be stored in a file with restricted permissions.
#
# This script:
#   1. Stores credentials securely (restricted file permissions)
#   2. Creates exclude file
#   3. Installs a launchd daemon for scheduled backups (runs as root, hidden)
# -----------------------------------------------------------------------------

# Require root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root: sudo $0 [install|uninstall]"
    exit 1
fi

# Configuration
RESTIC_HOSTNAME=$(hostname -s | tr '[:upper:]' '[:lower:]')
TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME=$(eval echo "~$TARGET_USER")

BACKUP_PATHS=(
    "$TARGET_HOME/Documents"
)

CONFIG_DIR="$TARGET_HOME/Library/Application Support/restic"
PASSWORD_FILE="$CONFIG_DIR/password"
EXCLUDE_FILE="$CONFIG_DIR/excludes.txt"
BACKUP_SCRIPT="$CONFIG_DIR/restic-backup"
LOG_FILE="$TARGET_HOME/Library/Logs/restic-backup.log"
PLIST_FILE="/Library/LaunchDaemons/com.restic.backup.plist"

install() {
    # Check for Restic CLI and get full path
    if ! command -v restic >/dev/null 2>&1; then
        echo "Restic not found. Please install: brew install restic"
        exit 1
    fi
    RESTIC_BIN=$(command -v restic)

    # Create config directory and ensure log directory exists
    echo "==> Creating config directory..."
    mkdir -p "$CONFIG_DIR"
    mkdir -p "$(dirname "$LOG_FILE")"
    chmod 700 "$CONFIG_DIR"
    chown -R "$TARGET_USER" "$CONFIG_DIR"

    # Retrieve or prompt for password
    if [ -f "$PASSWORD_FILE" ]; then
        RESTIC_PASSWORD=$(cat "$PASSWORD_FILE")
    else
        read -rsp "Enter Restic Repository Password: " RESTIC_PASSWORD
        echo ""

        if [ -z "$RESTIC_PASSWORD" ]; then
            echo "Password cannot be empty."
            exit 1
        fi

        printf '%s' "$RESTIC_PASSWORD" > "$PASSWORD_FILE"
        chmod 600 "$PASSWORD_FILE"
        echo "Password saved to $PASSWORD_FILE"
    fi

    export RESTIC_PASSWORD
    export RESTIC_REPOSITORY="rest:http://restic:${RESTIC_PASSWORD}@restic.edgard.org:8000/"

    # Create exclude file
    echo "==> Creating exclude patterns..."
    cat > "$EXCLUDE_FILE" << 'EOF'
.DS_Store
.Trash
.venv
node_modules
__pycache__
*.tmp
*.temp
EOF
    chmod 644 "$EXCLUDE_FILE"
    echo "Exclude file created at $EXCLUDE_FILE"

    # Create backup script
    echo "==> Creating backup script..."
    cat > "$BACKUP_SCRIPT" << 'OUTER_EOF'
#!/bin/bash

PASSWORD_FILE="%%PASSWORD_FILE%%"
RESTIC_BIN="%%RESTIC_BIN%%"
RESTIC_HOSTNAME="%%RESTIC_HOSTNAME%%"
EXCLUDE_FILE="%%EXCLUDE_FILE%%"
LOG_FILE="%%LOG_FILE%%"
BACKUP_PATH="%%BACKUP_PATH%%"

RESTIC_PASSWORD="$(cat "$PASSWORD_FILE")"
export RESTIC_PASSWORD
export RESTIC_REPOSITORY="rest:http://restic:${RESTIC_PASSWORD}@restic.edgard.org:8000/"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

log "Starting backup..."

if "$RESTIC_BIN" backup \
    --host "$RESTIC_HOSTNAME" \
    --tag documents \
    --exclude-file "$EXCLUDE_FILE" \
    --exclude-caches \
    --verbose \
    "$BACKUP_PATH" >> "$LOG_FILE" 2>&1; then
    log "Backup complete."
else
    log "Backup failed with exit code $?"
    exit 1
fi
OUTER_EOF

    # Replace placeholders in backup script
    sed -i '' "s|%%PASSWORD_FILE%%|$PASSWORD_FILE|g" "$BACKUP_SCRIPT"
    sed -i '' "s|%%RESTIC_BIN%%|$RESTIC_BIN|g" "$BACKUP_SCRIPT"
    sed -i '' "s|%%RESTIC_HOSTNAME%%|$RESTIC_HOSTNAME|g" "$BACKUP_SCRIPT"
    sed -i '' "s|%%EXCLUDE_FILE%%|$EXCLUDE_FILE|g" "$BACKUP_SCRIPT"
    sed -i '' "s|%%LOG_FILE%%|$LOG_FILE|g" "$BACKUP_SCRIPT"
    sed -i '' "s|%%BACKUP_PATH%%|$TARGET_HOME/Documents|g" "$BACKUP_SCRIPT"

    chmod 755 "$BACKUP_SCRIPT"
    echo "Backup script created at $BACKUP_SCRIPT"

    # Create launchd daemon (runs as root, hidden from user)
    echo "==> Creating launchd daemon..."
    cat > "$PLIST_FILE" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.restic.backup</string>
    <key>ProgramArguments</key>
    <array>
        <string>$BACKUP_SCRIPT</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>3</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>$LOG_FILE</string>
    <key>StandardErrorPath</key>
    <string>$LOG_FILE</string>
    <key>RunAtLoad</key>
    <false/>
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

    # Load the daemon
    launchctl unload "$PLIST_FILE" 2>/dev/null || true
    launchctl load "$PLIST_FILE"
    echo "Launchd daemon installed and loaded."

    # Run initial backup via scheduled task
    echo "==> Running initial backup..."
    SKIP_INITIAL=false
    for path in "${BACKUP_PATHS[@]}"; do
        if [ -d "$path" ]; then
            SNAPSHOT_OUTPUT=$("$RESTIC_BIN" snapshots --host "$RESTIC_HOSTNAME" --path "$path" --json 2>/dev/null || echo "[]")
            if [ "$SNAPSHOT_OUTPUT" != "[]" ] && [ "$SNAPSHOT_OUTPUT" != "null" ] && [ -n "$SNAPSHOT_OUTPUT" ]; then
                echo "Snapshots already exist for $path, skipping initial backup."
                SKIP_INITIAL=true
            fi
        fi
    done

    if [ "$SKIP_INITIAL" = false ]; then
        echo "Triggering scheduled task for initial backup..."
        launchctl kickstart system/com.restic.backup
        echo "Initial backup started. Check log for progress: tail -f $LOG_FILE"
    fi

    echo ""
    echo "==> Setup complete!"
    echo ""
    echo "The backup runs daily at 3:00 AM as root (hidden from user)."
    echo ""
    echo "Useful commands:"
    echo "  sudo \"$BACKUP_SCRIPT\"                      # Run backup manually"
    echo "  tail -f \"$LOG_FILE\"                        # View backup log"
    echo ""
    echo "For other restic commands, set environment and run with sudo -E:"
    echo "  export RESTIC_PASSWORD=\$(sudo cat \"$PASSWORD_FILE\")"
    echo "  export RESTIC_REPOSITORY=\"rest:http://restic:\${RESTIC_PASSWORD}@restic.edgard.org:8000/\""
    echo "  sudo -E restic snapshots --host $RESTIC_HOSTNAME   # List snapshots for this host"
    echo "  sudo -E restic snapshots                           # List all snapshots"
    echo "  sudo -E restic forget SNAPSHOT_ID --prune          # Delete a snapshot"
}

uninstall() {
    echo "==> Uninstalling restic backup..."

    # Unload and remove launchd daemon
    if [ -f "$PLIST_FILE" ]; then
        echo "Removing launchd daemon..."
        launchctl unload "$PLIST_FILE" 2>/dev/null || true
        rm -f "$PLIST_FILE"
    fi

    # Remove config directory
    if [ -d "$CONFIG_DIR" ]; then
        echo "Removing config directory..."
        rm -rf "$CONFIG_DIR"
    fi

    # Remove log file
    if [ -f "$LOG_FILE" ]; then
        echo "Removing log file..."
        rm -f "$LOG_FILE"
    fi

    echo ""
    echo "==> Uninstall complete!"
    echo ""
    echo "Note: Restic binary was not removed. To remove it: brew uninstall restic"
    echo "Note: Remote backups were not deleted."
}

case "${1:-}" in
    install)
        install
        ;;
    uninstall)
        uninstall
        ;;
    *)
        echo "Usage: sudo $0 [install|uninstall]"
        exit 1
        ;;
esac
