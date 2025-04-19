#!/usr/bin/env zsh

#---------------------------------------
# Plugin Specific Configurations
#---------------------------------------

# FZF Configuration (if fzf plugin is enabled)
if [[ -n "${plugins[(r)fzf]}" ]]; then
  # Using Catppuccin Frappe colors
  export FZF_DEFAULT_OPTS="--height 10 --layout=reverse \
--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"
fi

# Direnv Configuration (if direnv plugin is enabled)
if [[ -n "${plugins[(r)direnv]}" ]]; then
  export DIRENV_LOG_FORMAT="" # Keep direnv quiet
fi
