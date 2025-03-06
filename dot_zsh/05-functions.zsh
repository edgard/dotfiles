#!/usr/bin/env zsh

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
