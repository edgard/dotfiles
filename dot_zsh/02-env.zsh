#!/usr/bin/env zsh
# shellcheck disable=all

# --- Environment Variables and Utility Initialization ---
# Sets various environment variables and initializes common shell utilities.

# --- Core Environment Variables ---

# Pager Configuration
export PAGER=less
export LESSHISTFILE="-" # Disable less history file

# Configure `less` options.
if (( $+commands[less] )); then
    # Check if --use-color is supported
    if less --help 2>&1 | command grep -q -- '--use-color'; then
        export LESS='--use-color -R -i -j4 -M -X -F'
        export MANPAGER='less --use-color -R -Dd+r -Du+b' # Colorized man pages
    else
        export LESS='-R -i -j4 -M -X -F' # Basic less options
        export MANPAGER='less -R -Dd+r -Du+b'
    fi
fi

# Man Page Rendering Options
export MANROFFOPT='-c' # Use `groff -c` for better rendering

# --- Editor Configuration ---
# Set EDITOR and VISUAL environment variables based on available editors.
if [[ "${TERM_PROGRAM}" == "vscode" ]] && (( $+commands[code] )); then
    export EDITOR='code -w'   # Use VS Code, wait for file close
    export VISUAL='code -w'
elif (( $+commands[nvim] )); then
    export EDITOR=nvim
    export VISUAL=nvim
elif (( $+commands[vim] )); then
    export EDITOR=vim
    export VISUAL=vim
elif (( $+commands[vi] )); then
    export EDITOR=vi
    export VISUAL=vi
fi

# --- Terminal Colors and Appearance ---

# Load dircolors for `ls` command based on OS.
if [[ "${OSTYPE}" == linux* ]]; then
    # Linux: Use dircolors if available
    if [[ -f "${HOME}/.dir_colors" ]] && (( $+commands[dircolors] )); then
        eval "$(dircolors -b "${HOME}/.dir_colors")" || print -P "%F{yellow}Warning: Failed to eval dircolors%f" >&2
    fi
elif [[ "${OSTYPE}" == darwin* ]]; then
    # macOS: Prefer gdircolors (coreutils) if available
    if (( $+commands[gdircolors] )) && [[ -f "${HOME}/.dir_colors" ]]; then
        eval "$(gdircolors -b "${HOME}/.dir_colors")" || print -P "%F{yellow}Warning: Failed to eval gdircolors%f" >&2
    else
        # Fallback to native macOS LSCOLORS
        export CLICOLOR=1
        export LSCOLORS='exfxbxdxDxhbxDxecex' # Standard macOS colors
    fi
fi

# --- Utility Configuration ---

# FZF (Fuzzy Finder) Settings
export FZF_DEFAULT_OPTS="--height 10 --layout=reverse --color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 --color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf --color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"
# Use fd (if available) for faster file searching with fzf
if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# Direnv Settings
export DIRENV_LOG_FORMAT="" # Suppress direnv loading messages

# --- Utility Initialization ---
# Load shell integrations for various tools if they exist.

# FZF Keybindings and Completions
if (( $+commands[fzf] )); then
    # Source the keybindings and completion script provided by fzf
    source <(fzf --zsh) 2>/dev/null || print -P "%F{yellow}Warning: Failed to source fzf shell integration%f" >&2
fi

# Direnv Hook
if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)" 2>/dev/null || print -P "%F{yellow}Warning: Failed to initialize direnv hook%f" >&2
fi

# Zoxide (Smart Directory Changer)
if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)" 2>/dev/null || print -P "%F{yellow}Warning: Failed to initialize zoxide%f" >&2
fi

# Starship Prompt
if (( $+commands[starship] )); then
    eval "$(starship init zsh)" 2>/dev/null || print -P "%F{yellow}Warning: Failed to initialize starship prompt%f" >&2
fi
