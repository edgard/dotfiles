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

if (( $+commands[cursor] )); then
    export EDITOR='cursor -w'
elif (( $+commands[code] )); then
    export EDITOR='code -w'
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

if (( $+commands[fzf] )); then
    export FZF_DEFAULT_OPTS="--no-scrollbar --info=right --pointer='▌' --color=bg+:#414559,bg:#303446,spinner:#ca9ee6,hl:#e78284 --color=fg:#c6d0f5,header:#e78284,info:#949cbb,pointer:#ca9ee6 --color=marker:#ca9ee6,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"
    if (( $+commands[fd] )); then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi
fi

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
