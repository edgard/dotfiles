#!/usr/bin/env zsh

#---------------------------------------
# Environment Variables and Core Settings
#---------------------------------------

# Pager and Manpage Color Support
if less --help 2>&1 | grep -q -- --use-color; then
    export LESS='--use-color -R -i -j4 -M -X -F'
    export MANPAGER='less --use-color -R -Dd+r -Du+b'
else
    export LESS='-R -i -j4 -M -X -F'
    export MANPAGER='less -R -Dd+r -Du+b'
fi
export PAGER=less
export MANROFFOPT='-c'
export LESSHISTFILE=-

# Default Editor Selection
if [[ "${TERM_PROGRAM}" == "vscode" ]] && command -v code >/dev/null 2>&1; then
    export EDITOR='code -w' VISUAL='code -w'
elif command -v nvim >/dev/null 2>&1; then
    export EDITOR=nvim VISUAL=nvim
elif command -v vim >/dev/null 2>&1; then
    export EDITOR=vim VISUAL=vim
elif command -v vi >/dev/null 2>&1; then
    export EDITOR=vi VISUAL=vi
fi

# Terminal Colors (dircolors / gdircolors)
if [[ "${OSTYPE}" == linux* ]]; then
    if [[ -f "${HOME}/.dir_colors" ]] && command -v dircolors >/dev/null 2>&1; then
        eval "$(dircolors -b "${HOME}/.dir_colors")" || printf "Warning: Failed to load dircolors\n" >&2
    fi
elif [[ "${OSTYPE}" == darwin* ]]; then
    if command -v gdircolors >/dev/null 2>&1 && [[ -f "${HOME}/.dir_colors" ]]; then
        eval "$(gdircolors -b "${HOME}/.dir_colors")" || printf "Warning: Failed to load gdircolors\n" >&2
    else
        export CLICOLOR=1
        export LSCOLORS='exfxbxdxDxhbxDxecex'
    fi
fi
