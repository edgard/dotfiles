# Environment configuration
# Loaded first to set up basic environment variables and PATH

# Basic environment setup
export PAGER="less"
export LESS="--use-color -R -i -j4 -M -X -F"
export MANPAGER="less --use-color -R -Dd+r -Du+b"
export MANROFFOPT="-c"

# Editor configuration
export EDITOR="vi"
[[ -z "$SSH_CONNECTION" ]] && command -v code >/dev/null 2>&1 && export EDITOR="code -w"
export VISUAL="$EDITOR"

# Color support configuration
if [[ "${OSTYPE}" == "linux"* && -f "${HOME}/.dir_colors" ]]; then
    eval "$(dircolors -b "${HOME}/.dir_colors")"
elif [[ "${OSTYPE}" == "darwin"* ]]; then
    if command -v gdircolors >/dev/null 2>&1 && [[ -f "${HOME}/.dir_colors" ]]; then
        eval "$(gdircolors -b "${HOME}/.dir_colors")"
    else
        export CLICOLOR=1 LSCOLORS="exfxhxDxCxegxhxbxDxHx"
    fi
fi

# Terminal performance
if [[ "$TERM" == "xterm-256color" ]]; then
    KEYTIMEOUT=1
    REPORTTIME=5
fi
