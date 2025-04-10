#!/usr/bin/env zsh

##############################################################################
# Colorized Command Aliases
##############################################################################

command -v grep >/dev/null 2>&1 && alias grep="grep --color=auto --exclude-dir={.hg,.svn,.git,.bzr,CVS} --binary-files=without-match"
command -v diff >/dev/null 2>&1 && alias diff="diff --color=auto"
command -v ip >/dev/null 2>&1 && alias ip="ip --color=auto"
command -v dmesg >/dev/null 2>&1 && alias dmesg="dmesg --color=auto"
command -v journalctl >/dev/null 2>&1 && alias journalctl="journalctl --output=auto-long"
command -v watch >/dev/null 2>&1 && alias watch="watch --color"

##############################################################################
# History
##############################################################################

alias history='fc -l 1'

##############################################################################
# Cross-Platform 'ls' with Colors
##############################################################################

if [[ "${OSTYPE}" == darwin* ]]; then
    command -v gls >/dev/null 2>&1 && alias ls="gls -Fh --color=auto" || alias ls='ls -FhG'
else
    ls --version >/dev/null 2>&1 && alias ls="ls -Fh --color=auto" || alias ls="ls -F"
fi

##############################################################################
# Sudo Last Command
##############################################################################

alias please='sudo $(fc -ln -1)'

##############################################################################
# Kubernetes Aliases
##############################################################################

if command -v kubectl >/dev/null 2>&1; then
    alias k='kubectl'
    alias kg='kubectl get'
    alias kl='kubectl logs'
    alias kd='kubectl describe'
    alias krm='kubectl delete'

    if [[ -z "${ZSH_DISABLE_COMPFIX}" ]]; then
        source <(kubectl completion zsh 2>/dev/null)
    fi

    command -v kubens >/dev/null 2>&1 && alias kns='kubens'
    command -v kubectx >/dev/null 2>&1 && alias kctx='kubectx'
fi
