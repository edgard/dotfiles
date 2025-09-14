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

if [[ "${TERM_PROGRAM}" == "vscode" ]] && (( $+commands[code] )); then
    export EDITOR='code -w'
    export VISUAL='code -w'
elif (( $+commands[nvim] )); then
    export EDITOR=nvim
    export VISUAL=nvim
elif (( $+commands[vim] )); then
    export EDITOR=vim
    export VISUAL=vim
elif (( $+commands[vi] )); then
    export EDITOR=vi
    export VISUAL=vi
fi

export CLICOLOR=1
export LSCOLORS='ExGxFxDxCxegedabagacad'

if (( $+commands[fzf] )); then
    export FZF_DEFAULT_OPTS="--height 10 --layout=reverse --color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 --color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf --color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"
    if (( $+commands[fd] )); then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi
    source <(fzf --zsh) 2>/dev/null || print -P "%F{yellow}Warning: Failed to source fzf shell integration%f" >&2
fi

if (( $+commands[direnv] )); then
    export DIRENV_LOG_FORMAT=""
    eval "$(direnv hook zsh)" 2>/dev/null || print -P "%F{yellow}Warning: Failed to initialize direnv hook%f" >&2
fi

if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)" 2>/dev/null || print -P "%F{yellow}Warning: Failed to initialize zoxide%f" >&2
fi

if (( $+commands[starship] )); then
    eval "$(starship init zsh)" 2>/dev/null || print -P "%F{yellow}Warning: Failed to initialize starship prompt%f" >&2
fi

# ---- Local environment overrides ----
{
    local _env_local="${HOME}/.config/local/env.zsh"
    [[ -r "${_env_local}" ]] && source "${_env_local}"
    unset _env_local
}
