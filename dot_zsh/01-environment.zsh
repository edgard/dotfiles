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

## COLOR CONFIGURATION ##
export LESS_TERMCAP_mb=$'\e[38;5;183m'      # Begin bold (Pink)
export LESS_TERMCAP_md=$'\e[38;5;110m'      # Begin double-bright (Blue)
export LESS_TERMCAP_me=$'\e[0m'             # end mode
export LESS_TERMCAP_so=$'\e[38;5;137m'      # begin standout -> Peach
export LESS_TERMCAP_se=$'\e[0m'             # end standout
export LESS_TERMCAP_us=$'\e[38;5;149m'      # begin underline -> Green
export LESS_TERMCAP_ue=$'\e[0m'             # end underline
export LESS_TERMCAP_mr=$'\e[38;5;203m'      # Mode change -> Red
export LESS_TERMCAP_mh=$'\e[38;5;246m'      # Mode change -> Gray
export LESS_COLORS='RsK*w'                  # Raw search highlighting style
export LESS_HIGHLIGHTCOLOR=$'\e[38;5;213m'  # Search highlight color -> Pink
export LESS_HIGHLIGHTBGCOLOR=$'\e[48;5;239m' # Search highlight bg -> Surface0

export GREP_COLORS='ms=38;5;213:ln=38;5;149:fn=38;5;110:se=38;5;246'

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
