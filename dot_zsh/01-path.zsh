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

if (( $+commands[go] )); then
    export GOPATH="${GOPATH:-${HOME}/.go}"
    path+=("${GOPATH}/bin")
fi

if (( $+commands[node] )); then
    export NPM_CONFIG_PREFIX="${NPM_CONFIG_PREFIX:-${HOME}/.npm-global}"
    path+=("${NPM_CONFIG_PREFIX}/bin")
fi

if [[ -d "${HOME}/.krew/bin" ]]; then
    path+=("${HOME}/.krew/bin")
fi

[[ -d "${HOME}/.local/bin" ]] && path+=("${HOME}/.local/bin")
