# Zim framework and plugin configuration

# Zim Home
export ZIM_HOME="${HOME}/.zim"

# Download zimfw plugin manager if missing
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing modules and update init.zsh if needed
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi

# Initialize modules
source ${ZIM_HOME}/init.zsh

# Configure syntax highlighting
if [[ -f "${ZIM_HOME}/modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    typeset -gA ZSH_HIGHLIGHT_STYLES

    # Catppuccin Frappé theme
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

# Configure autosuggestions
if [[ -f "${ZIM_HOME}/modules/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#737994'
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
    ZSH_AUTOSUGGEST_USE_ASYNC=1
    ZSH_AUTOSUGGEST_MANUAL_REBIND=1
fi

# Configure prompt (eriner)
if [[ -f "${ZIM_HOME}/modules/eriner/eriner.zsh-theme" ]]; then
    typeset -g STATUS_COLOR='59'  # Base (#303446)
    typeset -g PWD_COLOR='147'    # Lavender (#babbf1)
    typeset -g CLEAN_COLOR='183'  # Mauve (#ca9ee6)
    typeset -g DIRTY_COLOR='110'  # Sapphire/Cyan (#85c1dc)
fi

# Configure fzf
if [[ -f "${ZIM_HOME}/modules/fzf/init.zsh" ]]; then
    export FZF_DEFAULT_OPTS="--height 10 --layout=reverse --color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284,fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf,marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"
fi

# Configure direnv
if [[ -f "${ZIM_HOME}/modules/direnv/init.zsh" ]]; then
    export DIRENV_LOG_FORMAT=""  # Silence direnv loading messages
fi
