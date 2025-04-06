#!/usr/bin/env zsh

## PAGER CONFIGURATION ##
if less --help 2>&1 | grep -q -- --use-color; then
    export LESS='--use-color -R -i -j4 -M -X -F'
    export MANPAGER='less --use-color -R -Dd+r -Du+b'
else
    export LESS='-R -i -j4 -M -X -F'
    export MANPAGER='less -R -Dd+r -Du+b'
fi
export PAGER=less
export MANROFFOPT='-c'

## EDITOR CONFIGURATION ##
if [[ -n "${VSCODE_INJECTION}" ]] && command -v code >/dev/null 2>&1; then
    export EDITOR='code -w' VISUAL='code -w'
elif command -v nvim >/dev/null 2>&1; then
    export EDITOR=nvim VISUAL=nvim
elif command -v vim >/dev/null 2>&1; then
    export EDITOR=vim VISUAL=vim
elif command -v vi >/dev/null 2>&1; then
    export EDITOR=vi VISUAL=vi
fi

## TERMINAL COLORS ##
if [[ "${OSTYPE}" == linux* ]]; then
    if [[ -f "${HOME}/.dir_colors" ]] && command -v dircolors >/dev/null 2>&1; then
        eval "$(dircolors -b "${HOME}/.dir_colors")" || printf "Warning: Failed to load dircolors\n" >&2
    fi
elif [[ "${OSTYPE}" == darwin* ]]; then
    if command -v gdircolors >/dev/null 2>&1 && [[ -f "${HOME}/.dir_colors" ]]; then
        eval "$(gdircolors -b "${HOME}/.dir_colors")" || printf "Warning: Failed to load gdircolors\n" >&2
    else
        export CLICOLOR=1 LSCOLORS='exfxbxdxDxhbxDxecex'
    fi
fi

## TERMINAL OPTIMIZATIONS ##
if [[ "${TERM}" == *-256color ]]; then
    KEYTIMEOUT=1
    REPORTTIME=5
fi
