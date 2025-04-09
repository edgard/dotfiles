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

# Source Zim initialization synchronously
source "${ZIM_HOME}/init.zsh"

##############################################################################
# Plugin Configurations
##############################################################################

# Fast Syntax Highlighting (Catppuccin-inspired colors)
if [[ -f "${ZIM_HOME}/modules/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]]; then
  FAST_HIGHLIGHT_STYLES[default]="fg=${COLOR_TEXT}"
  FAST_HIGHLIGHT_STYLES[unknown-token]="fg=${COLOR_RED}"
  FAST_HIGHLIGHT_STYLES[reserved-word]="fg=${COLOR_MAUVE}"
  FAST_HIGHLIGHT_STYLES[alias]="fg=${COLOR_BLUE}"
  FAST_HIGHLIGHT_STYLES[suffix-alias]="fg=${COLOR_BLUE}"
  FAST_HIGHLIGHT_STYLES[global-alias]="fg=${COLOR_BLUE}"
  FAST_HIGHLIGHT_STYLES[builtin]="fg=${COLOR_BLUE}"
  FAST_HIGHLIGHT_STYLES[function]="fg=${COLOR_BLUE}"
  FAST_HIGHLIGHT_STYLES[command]="fg=${COLOR_BLUE}"
  FAST_HIGHLIGHT_STYLES[precommand]="fg=${COLOR_BLUE},italic"
  FAST_HIGHLIGHT_STYLES[commandseparator]="fg=${COLOR_MAUVE}"
  FAST_HIGHLIGHT_STYLES[hashed-command]="fg=${COLOR_BLUE}"
  FAST_HIGHLIGHT_STYLES[path]="fg=${COLOR_LAVENDER}"
  FAST_HIGHLIGHT_STYLES[path-to-dir]="fg=${COLOR_LAVENDER}"
  FAST_HIGHLIGHT_STYLES[globbing]="fg=${COLOR_PEACH}"
  FAST_HIGHLIGHT_STYLES[history-expansion]="fg=${COLOR_MAUVE}"
  FAST_HIGHLIGHT_STYLES[single-quoted-argument]="fg=${COLOR_YELLOW}"
  FAST_HIGHLIGHT_STYLES[double-quoted-argument]="fg=${COLOR_YELLOW}"
  FAST_HIGHLIGHT_STYLES[dollar-quoted-argument]="fg=${COLOR_YELLOW}"
  FAST_HIGHLIGHT_STYLES[back-quoted-argument]="fg=${COLOR_YELLOW}"
  FAST_HIGHLIGHT_STYLES[assign]="fg=${COLOR_TEXT}"
  FAST_HIGHLIGHT_STYLES[redirection]="fg=${COLOR_MAUVE}"
  FAST_HIGHLIGHT_STYLES[comment]="fg=${COLOR_SUBTEXT},italic"
  FAST_HIGHLIGHT_STYLES[variable]="fg=${COLOR_SKY}"
fi

# Autosuggestions
if [[ -f "${ZIM_HOME}/modules/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=${COLOR_OVERLAY}"
fi

# FZF Configuration
if [[ -f "${ZIM_HOME}/modules/fzf/init.zsh" ]]; then
  export FZF_DEFAULT_OPTS="--height 10 --layout=reverse \
--color=bg+:${COLOR_SURFACE0},bg:${COLOR_BASE},spinner:${COLOR_ROSEWATER},hl:${COLOR_RED} \
--color=fg:${COLOR_TEXT},header:${COLOR_RED},info:${COLOR_MAUVE},pointer:${COLOR_ROSEWATER} \
--color=marker:${COLOR_ROSEWATER},fg+:${COLOR_TEXT},prompt:${COLOR_MAUVE},hl+:${COLOR_RED}"
fi

# Direnv Configuration
if [[ -f "${ZIM_HOME}/modules/direnv/init.zsh" ]]; then
  DIRENV_LOG_FORMAT=""
fi
