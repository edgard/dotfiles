# -----------------------------------------------------------------------------
# environment
# -----------------------------------------------------------------------------

# history
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=100000
SAVEHIST=${HISTSIZE}

# pager
export PAGER="less"
export LESS="FRX"

# editor
export EDITOR="vi"
if command -v code 1>/dev/null 2>&1; then
    if [[ -z "$SSH_CONNECTION" ]]; then
        export EDITOR="code -w"
    fi
fi
export VISUAL="$EDITOR"

# ls colors
[[ "${OSTYPE}" == "linux"* && -f "${HOME}/.dir_colors" ]] && eval "$(dircolors -b "${HOME}/.dir_colors")"
[[ "${OSTYPE}" == "darwin"* ]] && export CLICOLOR=1 LSCOLORS="ExFxBxDxCxegedabagacad"

# brew
[[ "${OSTYPE}" == "linux"* ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
[[ "${OSTYPE}" == "darwin"* ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# starship
if command -v starship 1>/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# direnv
if command -v direnv 1>/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi

# fzf
if command -v fzf 1>/dev/null 2>&1; then
    export FZF_DEFAULT_OPTS="--inline-info --layout=reverse --height 10 --color=dark --color=fg:#abb2bf,bg:#282c34,hl:#5c6370,fg+:#abb2bf,bg+:#2c323c,hl+:#c678dd,info:#e5c07b,prompt:#c678dd,pointer:#c678dd,marker:#e06c75,spinner:#c678dd,header:#5c6370"
    if command -v fd 1>/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND="fd . ${HOME}"
        export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
        export FZF_ALT_C_COMMAND="fd -t d . ${HOME}"
    fi

    FZF_INSTALL_PATH=$(brew --prefix fzf)
    source "${FZF_INSTALL_PATH}/shell/completion.zsh"
    source "${FZF_INSTALL_PATH}/shell/key-bindings.zsh"
    zle     -N             fzf-cd-widget
    bindkey -M emacs '\ex' fzf-cd-widget
    bindkey -M vicmd '\ex' fzf-cd-widget
    bindkey -M viins '\ex' fzf-cd-widget
fi

# go
if command -v go 1>/dev/null 2>&1; then
    export GOPATH="${HOME}/.go"
    export PATH="${GOPATH}/bin:${PATH}"
fi
