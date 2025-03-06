#!/usr/bin/env zsh

## ZIM CONFIGURATION ##

ZIM_HOME="${HOME}/.zim"

if [[ ! -e "${ZIM_HOME}/zimfw.zsh" ]]; then
  curl -fsSL --create-dirs -o "${ZIM_HOME}/zimfw.zsh" https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

if [[ ! "${ZIM_HOME}/init.zsh" -nt "${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc}" ]]; then
  source "${ZIM_HOME}/zimfw.zsh" init
fi

source "${ZIM_HOME}/init.zsh"

## PLUGIN CONFIGURATIONS ##

# Syntax highlighting
if [[ -f "${ZIM_HOME}/modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
    ZSH_HIGHLIGHT_STYLES[default]='fg=#c6d0f5'
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#e78284'
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#ca9ee6'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6d189'
    ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#a6d189'
    ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#a6d189'
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=#ef9f76'
    ZSH_HIGHLIGHT_STYLES[function]='fg=#8caaee'
    ZSH_HIGHLIGHT_STYLES[command]='fg=#8caaee'
    ZSH_HIGHLIGHT_STYLES[precommand]='fg=#ef9f76,italic'
    ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#ca9ee6'
    ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#8caaee'
    ZSH_HIGHLIGHT_STYLES[path]='fg=#babbf1,underline'
    ZSH_HIGHLIGHT_STYLES[path-to-dir]='fg=#babbf1,underline'
    ZSH_HIGHLIGHT_STYLES[globbing]='fg=#85c1dc'
    ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#ca9ee6'
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#e5c890'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#e5c890'
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#e5c890'
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#ca9ee6'
    ZSH_HIGHLIGHT_STYLES[assign]='fg=#c6d0f5'
    ZSH_HIGHLIGHT_STYLES[redirection]='fg=#ca9ee6'
    ZSH_HIGHLIGHT_STYLES[comment]='fg=#838ba7,italic'
    ZSH_HIGHLIGHT_STYLES[variable]='fg=#85c1dc'
fi

# Autosuggestions
if [[ -f "${ZIM_HOME}/modules/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
    ZSH_AUTOSUGGEST_USE_ASYNC=1
    ZSH_AUTOSUGGEST_MANUAL_REBIND=1
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#737994'
fi

# Prompt theme
if [[ -f "${ZIM_HOME}/modules/eriner/eriner.zsh-theme" ]]; then
    STATUS_COLOR='0'
    PWD_COLOR='147'
    CLEAN_COLOR='108'
    DIRTY_COLOR='186'
fi

# FZF configuration
[[ -f "${ZIM_HOME}/modules/fzf/init.zsh" ]] && \
    export FZF_DEFAULT_OPTS="--height 10 --layout=reverse \
    --color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
    --color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
    --color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"

# Direnv configuration
[[ -f "${ZIM_HOME}/modules/direnv/init.zsh" ]] && DIRENV_LOG_FORMAT=""
