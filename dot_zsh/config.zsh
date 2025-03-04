# History settings
HISTFILE="${HOME}/.zsh_history"

# Pager and editor
export PAGER="less"
export LESS="FRX"
export EDITOR="vi"
if command -v code 1>/dev/null 2>&1; then
    [[ -z "$SSH_CONNECTION" ]] && export EDITOR="code -w"
fi
export VISUAL="$EDITOR"

# Colors for ls
[[ "${OSTYPE}" == "linux"* && -f "${HOME}/.dir_colors" ]] && eval "$(dircolors -b "${HOME}/.dir_colors")"
[[ "${OSTYPE}" == "darwin"* ]] && export CLICOLOR=1 LSCOLORS="ExFxFxGxCxDxDxBxDxExEx"

# Homebrew setup
[[ "${OSTYPE}" == "darwin"* && -f "/usr/local/bin/brew" ]] && eval "$(/usr/local/bin/brew shellenv)"
[[ "${OSTYPE}" == "darwin"* && -f "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ "${OSTYPE}" == "linux"* && -f "/home/linuxbrew/.linuxbrew/bin/brew" ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
[[ -f "${HOME}/.linuxbrew/bin/brew" ]] && eval "$(${HOME}/.linuxbrew/bin/brew shellenv)"

# Go
if command -v go 1>/dev/null 2>&1; then
    export GOPATH="${HOME}/.go"
    export PATH="${GOPATH}/bin:${PATH}"
fi

# Node
if [[ -d "${HOME}/.npm-global" ]]; then
    export NPM_CONFIG_PREFIX="${HOME}/.npm-global"
    export PATH="${NPM_CONFIG_PREFIX}/bin:${PATH}"
fi

# Ruby
if command -v ruby 1>/dev/null 2>&1 && command -v gem 1>/dev/null 2>&1; then
    export GEM_HOME="${HOME}/.gem"
    export PATH="${GEM_HOME}/bin:${PATH}"
fi

# User binaries
if [[ -d "${HOME}/.local/bin" ]]; then
    export PATH="${HOME}/.local/bin:${PATH}"
fi

# Zsh options
setopt append_history       # Append to history file
setopt extended_history     # Save timestamp and duration
setopt hist_expire_dups_first # Remove duplicates first when trimming
setopt hist_fcntl_lock      # Use fcntl to lock history file
setopt hist_ignore_all_dups # Remove older duplicates
setopt hist_reduce_blanks   # Remove superfluous blanks
setopt hist_save_no_dups    # Don't write duplicate commands
setopt inc_append_history   # Add commands incrementally
setopt chase_links          # Resolve symlinks when cd'ing
setopt pushd_minus          # Make pushd - work like pushd +
setopt always_to_end        # Move cursor to end on completion
setopt auto_list            # List choices on ambiguous completion
setopt complete_in_word     # Complete from both ends
setopt correct              # Try to correct spelling
unsetopt beep               # Disable terminal beeping
unsetopt flow_control       # Disable Ctrl+S/Ctrl+Q flow control

# Remove duplicate path entries
typeset -U PATH path
