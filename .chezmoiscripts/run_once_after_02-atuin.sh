#!/usr/bin/env bash
# Setup Atuin shell history (runs once after packages installed)
set -euo pipefail

# Skip if atuin not installed
command -v atuin &>/dev/null || { echo "==> Skipping Atuin (not installed)"; exit 0; }

echo "==> Setting up Atuin..."

# Login only if session file doesn't exist (not logged in)
if [[ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}/atuin/session" ]]; then
    echo "==> Logging in to Atuin..."
    if ! atuin login </dev/tty; then
        echo "==> Atuin login skipped. Run 'atuin login' to enable sync."
        exit 0
    fi
fi

# Import history (best-effort, may not exist if HISTFILE=/dev/null)
if [[ -f ~/.zsh_history ]]; then
    if atuin import auto 2>/dev/null; then
        rm -f ~/.zsh_history
        echo "==> Imported shell history"
    fi
fi

# Sync (best-effort, server may not be accessible)
if atuin sync 2>/dev/null; then
    echo "==> Synced with Atuin server"
else
    echo "==> Atuin sync skipped (server not accessible or not configured)"
fi
