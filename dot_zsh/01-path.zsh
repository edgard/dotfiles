#!/usr/bin/env zsh
# shellcheck disable=all

# --- PATH and FPATH Configuration ---
# This file manages the shell's command search path (PATH)
# and function search path (FPATH).

# --- Type Declarations ---
# Ensure PATH/path and FPATH/fpath are tied, unique, and exported.
typeset -gU path PATH
typeset -gUT FPATH fpath

# --- macOS System Path Setup ---
# Initialize PATH using path_helper on macOS if available.
[[ "$OSTYPE" == darwin* && -x "/usr/libexec/path_helper" ]] && eval "$(/usr/libexec/path_helper -s)"

# --- Homebrew Environment Setup ---
# Detects Homebrew installation and adds its paths to the environment.
function _setup_homebrew() {
    local brew_executable
    # Check standard Homebrew locations for macOS and Linux
    if [[ "$OSTYPE" == darwin* ]]; then
        # Apple Silicon or Intel
        [[ -x "/opt/homebrew/bin/brew" ]] && brew_executable="/opt/homebrew/bin/brew"
        [[ -z "$brew_executable" && -x "/usr/local/bin/brew" ]] && brew_executable="/usr/local/bin/brew"
    else # Linux
        [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]] && brew_executable="/home/linuxbrew/.linuxbrew/bin/brew"
        [[ -z "$brew_executable" && -x "$HOME/.linuxbrew/bin/brew" ]] && brew_executable="$HOME/.linuxbrew/bin/brew"
    fi

    # If found, evaluate brew shellenv
    if [[ -n "$brew_executable" ]]; then
        eval "$("$brew_executable" shellenv)"
        return 0
    fi
    return 1 # Indicate Homebrew not found
}

_setup_homebrew # Execute the setup function
unfunction _setup_homebrew # Remove the temporary function

# --- Language Environment Variables and Paths ---
# Add paths for specific programming language tools if installed via Homebrew.

local brew_prefix # Use local variable for efficiency

# Go
if (( $+commands[brew] )) && brew_prefix=$(brew --prefix go 2>/dev/null); then
    export GOPATH="${GOPATH:-${HOME}/.go}" # Set GOPATH if not already set
    path+=("${GOPATH}/bin") # Add Go binary path
fi

# Rust (via rustup)
# Cargo bin directory is typically added automatically by rustup installation
# If rustup was installed via brew, ensure its shims are in PATH
if (( $+commands[brew] )) && brew_prefix=$(brew --prefix rustup-init 2>/dev/null); then
    path+=("${brew_prefix}/bin")
fi
# Standard cargo path
path+=("${HOME}/.cargo/bin")

# Node.js (via brew)
if (( $+commands[brew] )) && brew_prefix=$(brew --prefix node 2>/dev/null); then
    # Configure npm global install location
    export NPM_CONFIG_PREFIX="${NPM_CONFIG_PREFIX:-${HOME}/.npm-global}"
    path+=("${NPM_CONFIG_PREFIX}/bin") # Add npm global bin path
fi

# --- User Custom Paths ---
# Add user-specific binary directories to the PATH.
local -a user_paths=(
    "${HOME}/.local/bin"
    "${HOME}/Documents/Projects/dev-utils/bin"
)
for user_path in $user_paths; do
    # Add path only if it's a directory
    [[ -d "$user_path" ]] && path+=("$user_path")
done

# --- Cleanup ---
unset brew_prefix user_path user_paths # Remove temporary variables
