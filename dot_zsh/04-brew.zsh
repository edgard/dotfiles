#!/usr/bin/env zsh

## BREW CHECK ##
command -v brew >/dev/null 2>&1 || return 0

## HELPER FUNCTIONS ##
get_brewfiles() {
    local os_suffix="$([[ "${OSTYPE}" == darwin* ]] && echo "darwin" || echo "linux")"
    local base_dir="$(cd "${1:-$HOME/.local/share/chezmoi/extras}" && pwd)"
    echo "${base_dir}/Brewfile.common" "${base_dir}/Brewfile.${os_suffix}"
}

## CLEANUP FUNCTION ##
brew-cleanup() {
    local brewfiles_dir="${HOME}/.local/share/chezmoi/extras"

    if [[ ! -d "${brewfiles_dir}" ]]; then
        printf "Error: Brewfiles directory not found\n" >&2
        return 1
    fi

    printf "Analyzing installed packages...\n"
    local cleanup_output
    cleanup_output=$(brew bundle cleanup --file=<(cat $(get_brewfiles "${brewfiles_dir}")) --zap 2>&1) || {
        printf "Error: Failed to analyze packages\n" >&2
        return 1
    }

    echo "${cleanup_output}" | grep -v "^Using "

    if echo "${cleanup_output}" | grep -q "Would uninstall"; then
        printf "\nRemove these packages? [y/N] "
        read answer

        if [[ "$answer" == "y" ]] || [[ "$answer" == "Y" ]]; then
            if brew bundle cleanup --file=<(cat $(get_brewfiles "${brewfiles_dir}")) --zap --force; then
                printf "Cleanup completed.\n"
            else
                printf "Error: Cleanup failed\n" >&2
                return 1
            fi
        else
            printf "Cleanup cancelled.\n"
        fi
    else
        printf "No unused packages found.\n"
    fi
}

## INSTALL FUNCTION ##
brew-install() {
    local brewfiles_dir="${HOME}/.local/share/chezmoi/extras"

    if [[ ! -d "${brewfiles_dir}" ]]; then
        printf "Error: Brewfiles directory not found\n" >&2
        return 1
    fi

    printf "Updating Homebrew...\n"
    brew update || { printf "Error: Homebrew update failed\n" >&2; return 1; }

    local install_status=0
    for file in $(get_brewfiles "${brewfiles_dir}"); do
        if [[ -f "${file}" ]]; then
            printf "Installing from %s...\n" "$(basename "${file}")"
            brew bundle --file="${file}" || install_status=$((install_status + 1))
        fi
    done

    if [[ "${install_status}" -eq 0 ]]; then
        printf "All packages installed successfully.\n"
        return 0
    else
        printf "Some packages failed to install.\n" >&2
        return 1
    fi
}
