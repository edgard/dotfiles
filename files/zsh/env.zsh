# -----------------------------------------------------------------------------
# environment
# -----------------------------------------------------------------------------

# history
HISTFILE=~/.zsh_history
HISTSIZE=500000
SAVEHIST=500000

# prompt
PROMPT='[%n:%1~]%(!.#.$) '

# editor
export EDITOR="code -w -n"
export VISUAL="code -w -n"

# pager
export PAGER="less"
export LESS="FRX"

# ls colors
export LSCOLORS="ExGxFxdaCxDaDahbadacec"

# fzf
if command -v fzf 1>/dev/null 2>&1; then
    export FZF_DEFAULT_OPTS="--inline-info --layout=reverse --height 10 --color=dark --color=fg:#abb2bf,bg:#282c34,hl:#5c6370,fg+:#abb2bf,bg+:#2c323c,hl+:#c678dd,info:#e5c07b,prompt:#c678dd,pointer:#c678dd,marker:#e06c75,spinner:#c678dd,header:#5c6370"
    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND="fd . ${HOME}"
        export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
        export FZF_ALT_C_COMMAND="fd -t d . ${HOME}"
    fi
    if command -v brew 1>/dev/null 2>&1; then
        source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
    fi
fi

# go
if command -v go 1>/dev/null 2>&1; then
    export GOPATH="${HOME}/.go"
    export PATH="${GOPATH}/bin:${PATH}"
fi

# gcloud
if command -v brew 1>/dev/null 2>&1; then
    [[ -d "$(brew --prefix)/Caskroom/google-cloud-sdk" ]] && source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
fi