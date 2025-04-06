#!/usr/bin/env zsh

##############################################################################
# Zim Plugin Manager Initialization
##############################################################################

ZIM_HOME="${HOME}/.zim"

# Bootstrap zimfw if missing
if [[ ! -e "${ZIM_HOME}/zimfw.zsh" ]]; then
  curl -fsSL --create-dirs -o "${ZIM_HOME}/zimfw.zsh" https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Regenerate init.zsh if outdated
if [[ ! "${ZIM_HOME}/init.zsh" -nt "${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc}" ]]; then
  source "${ZIM_HOME}/zimfw.zsh" init
fi

# Source Zim initialization
source "${ZIM_HOME}/init.zsh"

##############################################################################
# Plugin Configurations
##############################################################################

# Fast Syntax Highlighting (Catppuccin-inspired colors)
if [[ -f "${ZIM_HOME}/modules/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]]; then
    FAST_HIGHLIGHT_STYLES[default]='fg=#c6d0f5'
    FAST_HIGHLIGHT_STYLES[unknown-token]='fg=#e78284'
    FAST_HIGHLIGHT_STYLES[reserved-word]='fg=#ca9ee6'
    FAST_HIGHLIGHT_STYLES[alias]='fg=#8caaee'
    FAST_HIGHLIGHT_STYLES[suffix-alias]='fg=#8caaee'
    FAST_HIGHLIGHT_STYLES[global-alias]='fg=#8caaee'
    FAST_HIGHLIGHT_STYLES[builtin]='fg=#8caaee'
    FAST_HIGHLIGHT_STYLES[function]='fg=#8caaee'
    FAST_HIGHLIGHT_STYLES[command]='fg=#8caaee'
    FAST_HIGHLIGHT_STYLES[precommand]='fg=#8caaee,italic'
    FAST_HIGHLIGHT_STYLES[commandseparator]='fg=#ca9ee6'
    FAST_HIGHLIGHT_STYLES[hashed-command]='fg=#8caaee'
    FAST_HIGHLIGHT_STYLES[path]='fg=#babbf1'
    FAST_HIGHLIGHT_STYLES[path-to-dir]='fg=#babbf1'
    FAST_HIGHLIGHT_STYLES[globbing]='fg=#ef9f76'
    FAST_HIGHLIGHT_STYLES[history-expansion]='fg=#ca9ee6'
    FAST_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#e5c890'
    FAST_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#e5c890'
    FAST_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#e5c890'
    FAST_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#e5c890'
    FAST_HIGHLIGHT_STYLES[assign]='fg=#c6d0f5'
    FAST_HIGHLIGHT_STYLES[redirection]='fg=#ca9ee6'
    FAST_HIGHLIGHT_STYLES[comment]='fg=#838ba7,italic'
    FAST_HIGHLIGHT_STYLES[variable]='fg=#85c1dc'
fi

# Autosuggestions
if [[ -f "${ZIM_HOME}/modules/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
    ZSH_AUTOSUGGEST_USE_ASYNC=1
    ZSH_AUTOSUGGEST_MANUAL_REBIND=1
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#737994'
fi

# FZF Configuration
if [[ -f "${ZIM_HOME}/modules/fzf/init.zsh" ]]; then
    export FZF_DEFAULT_OPTS="--height 10 --layout=reverse \
--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"
fi

# Direnv Configuration
if [[ -f "${ZIM_HOME}/modules/direnv/init.zsh" ]]; then
    DIRENV_LOG_FORMAT=""
fi
