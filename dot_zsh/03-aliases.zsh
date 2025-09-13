#!/usr/bin/env zsh
# shellcheck disable=all

# --- Command Aliases ---
# Defines various command aliases for convenience and consistency.

# --- Command Aliases (native macOS) ---
# Keep aliases compatible with BSD userland.

# --- History Alias ---
# Simple alias for viewing command history.
alias history='fc -l 1' # Show history starting from command 1

# --- ls Alias ---
# Native macOS ls with color and file type indicators.
alias ls='ls -F -G'

# --- Sudo Alias ---
# Alias to easily run the previous command with sudo.
alias please='sudo $(fc -ln -1)'

# --- Kubernetes Aliases (kubectl) ---
# Define short aliases for common kubectl commands if kubectl is installed.
if (( $+commands[kubectl] )); then
    alias k='kubectl'
    alias kg='kubectl get'
    alias kl='kubectl logs'
    alias kd='kubectl describe'
    alias krm='kubectl delete'

    # Load kubectl completions if not disabled.
    # Check ZSH_DISABLE_COMPFIX to avoid potential compinit issues.
    if [[ -z "${ZSH_DISABLE_COMPFIX}" ]]; then
        # Ensure completions are loaded without errors
        source <(kubectl completion zsh 2>/dev/null) || print -P "%F{yellow}Warning: Failed to load kubectl completions.%f" >&2
    fi

    # Aliases for kubens/kubectx if installed
    (( $+commands[kubens] ))  && alias kns='kubens'
    (( $+commands[kubectx] )) && alias kctx='kubectx'
fi
