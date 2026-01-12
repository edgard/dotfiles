#!/usr/bin/env zsh
# shellcheck disable=all

# Colorize less/man if supported
if (( $+commands[less] )); then
    export PAGER=less
    export LESSHISTFILE="-"

    if less --help 2>&1 | command grep -q -- '--use-color'; then
        export LESS='--use-color -R -i -j4 -M -X -F'
        export MANPAGER='less --use-color -R -Dd+r -Du+b'
    else
        export LESS='-R -i -j4 -M -X -F'
        export MANPAGER='less -R -Dd+r -Du+b'
    fi
fi

export MANROFFOPT='-c'

if (( $+commands[zed] )); then
    export EDITOR='zed -w'
elif (( $+commands[nvim] )); then
    export EDITOR=nvim
elif (( $+commands[vim] )); then
    export EDITOR=vim
elif (( $+commands[vi] )); then
    export EDITOR=vi
fi
export VISUAL="${EDITOR}"

export CLICOLOR=1
export LSCOLORS='ExGxFxDxCxegedabagacad'

if (( $+commands[direnv] )); then
    export DIRENV_LOG_FORMAT=""
    eval "$(direnv hook zsh)" 2>/dev/null || print -P "%F{yellow}Warning: Failed to initialize direnv hook%f" >&2
fi

if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)" 2>/dev/null || print -P "%F{yellow}Warning: Failed to initialize zoxide%f" >&2
fi

if (( $+commands[atuin] )); then
    eval "$(atuin init zsh)" 2>/dev/null || print -P "%F{yellow}Warning: Failed to initialize atuin%f" >&2
fi

if (( $+commands[starship] )); then
    eval "$(starship init zsh)" 2>/dev/null || print -P "%F{yellow}Warning: Failed to initialize starship prompt%f" >&2
fi
