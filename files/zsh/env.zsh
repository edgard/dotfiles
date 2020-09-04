# -----------------------------------------------------------------------------
# environment
# -----------------------------------------------------------------------------

# history
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=500000
SAVEHIST=500000

# prompt
AGKOZAK_MULTILINE=0
AGKOZAK_PROMPT_CHAR=( ❯ ❯ ❮ )
AGKOZAK_COLORS_PROMPT_CHAR="magenta"
AGKOZAK_CUSTOM_SYMBOLS=( "⇣⇡" "⇣" "⇡" "+" "x" "!" ">" "?" "S")
#PROMPT='[%n:%1~]%(!.#.$) '

# editor
[[ "${OSTYPE}" == "darwin"* ]] && export EDITOR="code -w -n"
[[ "${OSTYPE}" == "darwin"* ]] && export VISUAL="code -w -n"

# pager
export PAGER="less"
export LESS="FRX"

# ls colors
[[ "${OSTYPE}" == "linux"* && -f "${HOME}/.dir_colors" ]] && eval "$(dircolors -b "${HOME}/.dir_colors")"
[[ "${OSTYPE}" == "darwin"* ]] && export LSCOLORS="ExGxFxdaCxDaDahbadacec"

# fzf
if command -v fzf 1>/dev/null 2>&1; then
    export FZF_DEFAULT_OPTS="--inline-info --layout=reverse --height 10 --color=dark --color=fg:#abb2bf,bg:#282c34,hl:#5c6370,fg+:#abb2bf,bg+:#2c323c,hl+:#c678dd,info:#e5c07b,prompt:#c678dd,pointer:#c678dd,marker:#e06c75,spinner:#c678dd,header:#5c6370"
    if command -v fd 1>/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND="fd . ${HOME}"
        export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
        export FZF_ALT_C_COMMAND="fd -t d . ${HOME}"
    fi
fi

# go
if command -v go 1>/dev/null 2>&1; then
    export GOPATH="${HOME}/.go"
    export PATH="${GOPATH}/bin:${PATH}"
fi

# dotnet
if command -v dotnet 1>/dev/null 2>&1; then
    export PATH="${HOME}/.dotnet/tools:${PATH}"
fi

# gcloud
[[ "${OSTYPE}" == "linux"* && -d "/opt/google-cloud-sdk/path.zsh.inc" ]] && source "/opt/google-cloud-sdk/path.zsh.inc"
[[ "${OSTYPE}" == "darwin"* && -d "$(brew --prefix)/Caskroom/google-cloud-sdk" ]] && source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
