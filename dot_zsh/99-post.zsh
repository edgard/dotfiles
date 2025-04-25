#!/usr/bin/env zsh
# --- Post-Initialization Script ---
# This file is sourced last and contains setup or fixes that might depend
# on previously loaded configurations or environment variables.

# --- WSL2 Runtime Directory Fix ---
# Ensure XDG_RUNTIME_DIR is correctly set and exists within WSL2 environments.
# This is often needed for applications relying on D-Bus or Wayland.
if [[ "$OSTYPE" == linux* ]] && command grep -qi microsoft /proc/version 2>/dev/null; then
    # Construct the expected runtime directory path
    expected_runtime_dir="/run/user/$(id -u)"

    # Check if XDG_RUNTIME_DIR is unset or doesn't match the expected path
    if [[ -z "$XDG_RUNTIME_DIR" || "$XDG_RUNTIME_DIR" != "$expected_runtime_dir" ]]; then
        export XDG_RUNTIME_DIR="$expected_runtime_dir"
    fi

    # Create the directory with correct permissions if it doesn't exist
    if [[ ! -d "$XDG_RUNTIME_DIR" ]]; then
        # Use sudo to create, set permissions, and change ownership in one go
        sudo mkdir -p "$XDG_RUNTIME_DIR" && \
        sudo chmod 700 "$XDG_RUNTIME_DIR" && \
        sudo chown "$(id -u):$(id -g)" "$XDG_RUNTIME_DIR"
    fi
    # Ensure the variable is exported
    export XDG_RUNTIME_DIR
fi

# --- VS Code Shell Integration ---
# Source VS Code's shell integration script if running within its integrated terminal.
if [[ "$TERM_PROGRAM" == "vscode" ]] && (( $+commands[code] )); then
    # Locate the integration script path
    local vscode_integration_path
    vscode_integration_path="$(code --locate-shell-integration-path zsh 2>/dev/null)"

    # Source the script if it exists and is readable
    if [[ -n "$vscode_integration_path" && -r "$vscode_integration_path" ]]; then
        source "$vscode_integration_path"
    fi
    unset vscode_integration_path # Clean up local variable
fi
