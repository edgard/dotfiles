#!/usr/bin/env zsh
# --- Command Aliases ---
# Defines various command aliases for convenience and consistency.

# --- Colorized Command Aliases ---
# Add color support to common commands if the command exists.
(( $+commands[grep] ))       && alias grep='grep --color=auto --exclude-dir={.git,.hg,.svn} --binary-files=without-match'
(( $+commands[diff] ))       && alias diff='diff --color=auto'
(( $+commands[ip] ))         && alias ip='ip --color=auto' # Linux specific
(( $+commands[dmesg] ))      && alias dmesg='dmesg --color=auto' # Linux specific
(( $+commands[journalctl] )) && alias journalctl='journalctl --output=short-precise --catalog --no-pager'
(( $+commands[watch] ))      && alias watch='watch --color'

# --- History Alias ---
# Simple alias for viewing command history.
alias history='fc -l 1' # Show history starting from command 1

# --- Cross-Platform 'ls' Alias ---
# Use 'gls' (GNU ls from coreutils) on macOS if available for consistency,
# otherwise use the native 'ls' with appropriate color flags.
if [[ "${OSTYPE}" == darwin* ]]; then
    # macOS: Prefer gls if installed via Homebrew
    if (( $+commands[gls] )); then
        alias ls='gls -F --color=auto --group-directories-first'
    else
        # Use native macOS ls with color flags
        alias ls='ls -F -G'
    fi
else
    # Linux/Other: Use ls with color if supported
    if ls --color=auto &>/dev/null; then
        alias ls='ls -F --color=auto --group-directories-first'
    else
        # Basic ls if color is not supported
        alias ls='ls -F'
    fi
fi


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
