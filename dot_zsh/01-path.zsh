#!/usr/bin/env zsh
# shellcheck disable=all

# Unique, exported PATH/FPATH tied to arrays
typeset -gU path PATH
typeset -gUT FPATH fpath

[[ -x "/usr/libexec/path_helper" ]] && eval "$(/usr/libexec/path_helper -s)"

# Load Homebrew shellenv if installed
function _setup_homebrew() {
    local brew_executable
    [[ -x "/opt/homebrew/bin/brew" ]] && brew_executable="/opt/homebrew/bin/brew"
    [[ -z "$brew_executable" && -x "/usr/local/bin/brew" ]] && brew_executable="/usr/local/bin/brew"
    if [[ -n "$brew_executable" ]]; then
        eval "$("$brew_executable" shellenv)"
        return 0
    fi
    return 1
}

_setup_homebrew
unfunction _setup_homebrew

local brew_prefix

if (( $+commands[brew] )) && brew_prefix=$(brew --prefix go 2>/dev/null); then
    export GOPATH="${GOPATH:-${HOME}/.go}"
    path+=("${GOPATH}/bin")
fi

if (( $+commands[brew] )) && brew_prefix=$(brew --prefix node 2>/dev/null); then
    export NPM_CONFIG_PREFIX="${NPM_CONFIG_PREFIX:-${HOME}/.npm-global}"
    path+=("${NPM_CONFIG_PREFIX}/bin")
fi

if (( $+commands[brew] )) && brew_prefix=$(brew --prefix krew 2>/dev/null); then
    path+=("${HOME}/.krew/bin")
fi

local -a user_paths=(
    "${HOME}/.local/bin"
    "${HOME}/Documents/Projects/dev-utils/bin"
)
for user_path in $user_paths; do
    [[ -d "$user_path" ]] && path+=("$user_path")
done

unset brew_prefix user_path user_paths
