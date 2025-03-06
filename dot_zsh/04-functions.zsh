#!/usr/bin/env zsh

## HELPER FUNCTIONS ##
get_brewfiles() {
    local os_suffix="$([[ "${OSTYPE}" == darwin* ]] && echo "darwin" || echo "linux")"
    local base_dir="$(cd "${1:-$HOME/.local/share/chezmoi/extras}" && pwd)"
    echo "${base_dir}/Brewfile.common" "${base_dir}/Brewfile.${os_suffix}"
}

## PACKAGE MANAGEMENT FUNCTIONS ##
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

## SYSTEM UPDATE FUNCTION ##
update() {
    local errors=0 success=0 available=0 cmd_result=""
    local cmds_to_run=""

    # Check for available package managers
    command -v chezmoi >/dev/null 2>&1 && cmds_to_run+="chezmoi:Dotfiles "
    command -v brew >/dev/null 2>&1 && cmds_to_run+="brew:Homebrew "
    command -v apt >/dev/null 2>&1 && cmds_to_run+="apt:System "

    if [[ -z "${cmds_to_run}" ]]; then
        printf "Error: No supported package managers found\n" >&2
        return 1
    fi

    # Count actual number of package managers
    available=$(echo "${cmds_to_run}" | tr ' ' '\n' | grep -c ':')

    printf "Starting system update...\n\n"

    # Process each package manager
    for pair in ${(z)cmds_to_run}; do
        [[ -z "${pair}" ]] && continue
        cmd="${pair%%:*}"
        msg="${pair#*:}"
        printf "Updating %s packages...\n" "${msg}"

        case "${cmd}" in
            chezmoi)
                if "${cmd}" update; then
                    cmd_result="${cmd_result} ${cmd}"
                    success=$((success + 1))
                else
                    printf "Error: Dotfiles update failed\n" >&2
                    errors=$((errors + 1))
                fi
                ;;

            brew)
                if ! "${cmd}" update; then
                    printf "Error: Homebrew update failed\n" >&2
                    errors=$((errors + 1))
                    continue
                fi

                if ! "${cmd}" upgrade; then
                    printf "Error: Package upgrade failed\n" >&2
                    errors=$((errors + 1))
                    continue
                fi

                if [[ "${OSTYPE}" == darwin* ]]; then
                    if brew commands | grep -q "^cu$"; then
                        brew cu -y -q --cleanup --no-brew-update
                    else
                        printf "Warning: brew cu subcommand not available, skipping cask updates\n" >&2
                    fi
                fi

                "${cmd}" cleanup -s
                cmd_result="${cmd_result} ${cmd}"
                success=$((success + 1))
                ;;

            apt)
                if [[ "${OSTYPE}" == linux* ]]; then
                    if ! sudo "${cmd}" update; then
                        printf "Error: Package list update failed\n" >&2
                        errors=$((errors + 1))
                        continue
                    fi

                    if ! sudo "${cmd}" dist-upgrade -y; then
                        printf "Error: Package upgrade failed\n" >&2
                        errors=$((errors + 1))
                        continue
                    fi

                    sudo "${cmd}" autoremove --purge -y || printf "Warning: Autoremove failed\n" >&2
                    cmd_result="${cmd_result} ${cmd}"
                    success=$((success + 1))
                fi
                ;;
        esac
        printf "\n"
    done

    # Print summary
    if [[ "$success" -eq "$available" ]]; then
        printf "All updates (%d/%d) completed successfully.\n" "$success" "$available"
        return 0
    fi

    if [[ "$success" -gt 0 ]]; then
        printf "Partial success: %d/%d updates completed.\n" "$success" "$available"
        [[ "$errors" -gt 0 ]] && return 1 || return 0
    fi

    printf "Error: No updates completed successfully.\n"
    return 1
}
