#!/bin/bash
set -e

# -----------------------------------------------------------------------------
# Kopia Setup Script for macOS
#
# INSTALLATION INSTRUCTIONS:
#
# Install KopiaUI:
#   brew install --cask kopiaui
#
# The first time you run this script, it will prompt you for the repository
# password. It will be securely stored in the macOS Keychain.
# -----------------------------------------------------------------------------

# Check for Kopia CLI or find it inside KopiaUI
KOPIA_CMD="kopia"
if ! command -v kopia >/dev/null 2>&1; then
    if [ -f "/Applications/KopiaUI.app/Contents/Resources/server/kopia" ]; then
        KOPIA_CMD="/Applications/KopiaUI.app/Contents/Resources/server/kopia"
    else
        echo "Kopia CLI not found in PATH and KopiaUI not found in /Applications."
        echo "Please install KopiaUI: brew install --cask kopiaui"
        exit 1
    fi
fi

# Retrieve or Prompt for Password
SERVICE_NAME="kopia-server"
ACCOUNT_NAME="$USER"

if ! KOPIA_PASSWORD=$(security find-generic-password -s "$SERVICE_NAME" -a "$ACCOUNT_NAME" -w 2>/dev/null); then
    echo "Password not found in keychain."
    read -rsp "Enter Kopia Server Password (for user 'admin'): " KOPIA_PASSWORD
    echo ""

    if [ -z "$KOPIA_PASSWORD" ]; then
        echo "Password cannot be empty."
        exit 1
    fi

    # Save to Keychain
    if security add-generic-password -s "$SERVICE_NAME" -a "$ACCOUNT_NAME" -w "$KOPIA_PASSWORD" 2>/dev/null; then
        echo "Password securely saved to Keychain."
    else
        echo "Failed to save password to Keychain."
        exit 1
    fi
fi

KOPIA_SERVER="https://kopia.edgard.org:51515"
KOPIA_HOSTNAME=$(hostname -s | tr '[:upper:]' '[:lower:]')

BACKUP_PATHS=(
  "$HOME/Documents"
)

echo "==> Connecting to Kopia server..."
"$KOPIA_CMD" repository connect server \
  --url="$KOPIA_SERVER" \
  --password="$KOPIA_PASSWORD" \
  --override-hostname="$KOPIA_HOSTNAME" \
  --override-username="admin"

echo "==> Configuring snapshot policies..."
for path in "${BACKUP_PATHS[@]}"; do
  if [ -d "$path" ]; then
    echo "Configuring policy for $path"
    "$KOPIA_CMD" policy set "$path" \
      --snapshot-time=03:00 \
      --run-missed=true \
      --add-ignore=.DS_Store \
      --add-ignore='**/.venv' \
      --add-ignore='**/node_modules'
  fi
done

echo "==> Creating initial snapshots..."
for path in "${BACKUP_PATHS[@]}"; do
  if [ -d "$path" ]; then
    if "$KOPIA_CMD" snapshot list "$path" | grep -q .; then
      echo "Snapshots already exist for $path, skipping initial creation."
    else
      echo "Creating initial snapshot of $path"
      "$KOPIA_CMD" snapshot create "$path" || true
    fi
  fi
done

echo "==> Setup complete!"
