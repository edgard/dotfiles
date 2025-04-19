#!/usr/bin/env zsh

#---------------------------------------
# Brewfile Merge Function
#---------------------------------------

# Merges multiple Brewfiles into one based on OS
# Args:
#   $1 - Optional directory containing Brewfiles (defaults to ~/.local/share/chezmoi/extras)
# Returns:
#   Path to the merged temporary Brewfile
_get_merged_brewfile() {
    local base_dir="${1:-$HOME/.local/share/chezmoi/extras}"
    base_dir="${base_dir:A}"  # Resolve to absolute path

    # Determine OS-specific suffix
    local os_suffix
    case "$OSTYPE" in
        darwin*) os_suffix="darwin" ;;
        linux*)  os_suffix="linux" ;;
        *)
            print -P "%F{$ZSH_COLOR_RED}Error: Unsupported OS type: $OSTYPE%f" >&2
            return 1
            ;;
    esac

    # Define input and output files
    local -a brewfiles=("${base_dir}/Brewfile.common" "${base_dir}/Brewfile.${os_suffix}")
    local temp_file="${TMPDIR:-/tmp}/brewfile_merged_${(%):-%n}.$$"

    # Create header for merged file
    {
        print -P "# Merged Brewfile generated on $(date)"
        print -P "# Sources:"
        for file in ${brewfiles}; do
            [[ -f "${file}" ]] && print -P "#  - ${file:t}"
        done
        print ""
    } > "${temp_file}"

    # Initialize data structures to store directives
    local -A directives_by_type seen_directives
    local -a section_types=(tap brew cask mas)

    # First pass: collect and deduplicate directives
    for brewfile in ${brewfiles}; do
        [[ -f "${brewfile}" ]] || continue

        local -a file_lines=("${(@f)$(<${brewfile})}")

        for line in "${file_lines[@]}"; do
            # Skip comments and empty lines
            [[ "${line}" =~ '^[[:space:]]*(#|$)' ]] && continue

            # Clean and normalize the line
            local clean_line="${${line%%\#*}##[[:space:]]}"  # Remove comments and leading whitespace
            clean_line="${clean_line%%[[:space:]]}"          # Trim trailing whitespace
            [[ -z "${clean_line}" ]] && continue             # Skip if empty after cleaning

            # Skip if already seen (deduplication)
            (( ${+seen_directives["${clean_line}"]} )) && continue
            seen_directives["${clean_line}"]=1

            # Categorize directive by type
            local directive_type=""
            case "${clean_line}" in
                (tap[[:space:]]*)    directive_type="tap" ;;
                (brew[[:space:]]*)   directive_type="brew" ;;
                (cask[[:space:]]*)   directive_type="cask" ;;
                (mas[[:space:]]*)    directive_type="mas" ;;
                (*) continue ;;
            esac

            # Store directive by its type
            directives_by_type[$directive_type]+="${clean_line}"$'\n'
        done
    done

    # Second pass: write directives by type in preferred order
    for type in ${section_types}; do
        [[ -n "${directives_by_type[$type]}" ]] || continue

        # Sort directives alphabetically
        local -a sorted_directives=("${(@f)directives_by_type[$type]}")
        sorted_directives=("${(@o)sorted_directives}")

        # Write each directive to output file
        for directive in ${sorted_directives}; do
            [[ -n "$directive" ]] && print -r "$directive" >> "${temp_file}"
        done

        print "" >> "${temp_file}"  # Add empty line between sections
    done

    # Return path to merged file
    print "${temp_file}"
}

#---------------------------------------
# Package Management Functions
#---------------------------------------

# Clean up unused Homebrew packages
brew-cleanup() {
    local brewfiles_dir="${HOME}/.local/share/chezmoi/extras"

    # Verify brewfiles directory exists
    if [[ ! -d "${brewfiles_dir}" ]]; then
        print -P "%F{$ZSH_COLOR_RED}Error: Brewfiles directory not found%f" >&2
        return 1
    fi

    print -P "Analyzing installed packages..."
    local merged_file=$(_get_merged_brewfile "${brewfiles_dir}")

    print -P "Checking for packages to clean up..."
    local -a cleanup_lines=("${(@f)$(brew bundle cleanup --file="${merged_file}" --zap 2>&1)}")

    # Display cleanup results, filtering out diagnostic messages
    print -P "${(@)cleanup_lines:#Using*}"

    # If there are packages to uninstall, prompt for confirmation
    if (( ${#${(M)cleanup_lines:#*Would uninstall*}} > 0 )); then
        print -Pn "\nWould you like to remove these packages? [y/N] "
        read -q "answer"; echo

        if [[ "$answer" == "y" ]]; then
            print -P "Removing packages..."
            if brew bundle cleanup --file="${merged_file}" --zap --force; then
                print -P "Cleanup completed successfully."
            else
                print -P "%F{$ZSH_COLOR_RED}Error: Some packages could not be removed.%f" >&2
                command rm "${merged_file}"
                return 1
            fi
        else
            print -P "Cleanup cancelled. No packages were removed."
        fi
    else
        print -P "No unused packages found."
    fi

    command rm "${merged_file}"
    return 0
}

# Install packages from Brewfiles
brew-install() {
    local brewfiles_dir="${HOME}/.local/share/chezmoi/extras"

    # Verify brewfiles directory exists
    if [[ ! -d "${brewfiles_dir}" ]]; then
        print -P "%F{$ZSH_COLOR_RED}Error: Brewfiles directory not found%f" >&2
        return 1
    fi

    print -P "Updating Homebrew..."
    brew update || {
        print -P "%F{$ZSH_COLOR_RED}Error: Homebrew update failed%f" >&2
        return 1
    }

    print -P "Installing packages from merged Brewfile..."
    local merged_file=$(_get_merged_brewfile "${brewfiles_dir}")

    if brew bundle --file="${merged_file}"; then
        print -P "All packages installed successfully."
        command rm "${merged_file}"
        return 0
    else
        print -P "%F{$ZSH_COLOR_RED}Some packages failed to install.%f" >&2
        command rm "${merged_file}"
        return 1
    fi
}

#---------------------------------------
# System Update Function
#---------------------------------------

# Update system components (dotfiles, packages, etc.)
update() {
    # Check for available package managers
    local -A managers
    local -a available_cmds

    # Detect available package managers
    whence -p chezmoi >/dev/null && managers[chezmoi]="Dotfiles"
    whence -p brew >/dev/null && managers[brew]="Homebrew"
    whence -p apt >/dev/null && managers[apt]="System"
    [[ -d "${ZSH}" ]] && managers[omz]="Oh My Zsh"

    available_cmds=(${(k)managers})

    if (( ${#available_cmds} == 0 )); then
        print -P "%F{$ZSH_COLOR_RED}Error: No supported package managers found%f" >&2
        return 1
    fi

    # Initialize tracking variables
    local success=0
    local total=${#available_cmds}
    local -a successful_cmds=()

    print -P "Starting system update...\n"

    # Process each available package manager
    for cmd in ${available_cmds}; do
        local manager_name="${managers[$cmd]}"
        print -P "Updating %F{$ZSH_COLOR_SKY}${manager_name}%f packages..."

        case "${cmd}" in
            (chezmoi)
                # Update dotfiles
                if "${cmd}" update; then
                    successful_cmds+=("${cmd}")
                    (( success++ ))
                else
                    print -P "%F{$ZSH_COLOR_RED}Error: Dotfiles update failed%f" >&2
                fi
                ;;
            (brew)
                # Update Homebrew and packages
                if ! "${cmd}" update; then
                    print -P "%F{$ZSH_COLOR_RED}Error: Homebrew update failed%f" >&2
                    continue
                fi

                if ! "${cmd}" upgrade; then
                    print -P "%F{$ZSH_COLOR_RED}Error: Package upgrade failed%f" >&2
                    continue
                fi

                # Update casks on macOS if brew-cu is available
                if [[ "$OSTYPE" == darwin* ]]; then
                    if brew cu --help >/dev/null 2>&1; then
                        brew cu -y -q --cleanup --no-brew-update
                    else
                        print -P "%F{$ZSH_COLOR_YELLOW}Warning: brew cu subcommand not available, skipping cask updates%f" >&2
                    fi
                fi

                # Run brew-install and brew-cleanup
                brew-install
                brew-cleanup

                # Clean up old versions
                "${cmd}" cleanup -s
                successful_cmds+=("${cmd}")
                (( success++ ))
                ;;
            (apt)
                # Update system packages (Linux only)
                if [[ "$OSTYPE" == linux* ]]; then
                    if ! sudo "${cmd}" update; then
                        print -P "%F{$ZSH_COLOR_RED}Error: Package list update failed%f" >&2
                        continue
                    fi

                    if ! sudo "${cmd}" dist-upgrade -y; then
                        print -P "%F{$ZSH_COLOR_RED}Error: Package upgrade failed%f" >&2
                        continue
                    fi

                    # Clean up unused packages
                    sudo "${cmd}" autoremove --purge -y ||
                        print -P "%F{$ZSH_COLOR_YELLOW}Warning: Autoremove failed%f" >&2

                    successful_cmds+=("${cmd}")
                    (( success++ ))
                fi
                ;;
            (omz)
                # Update Oh My Zsh core only (not custom plugins or themes)
                if [[ -d "${ZSH}" ]]; then
                    if "${ZSH}/tools/upgrade.sh"; then
                        successful_cmds+=("${cmd}")
                        (( success++ ))
                    else
                        print -P "%F{$ZSH_COLOR_RED}Error: Oh My Zsh update failed%f" >&2
                    fi
                else
                    print -P "%F{$ZSH_COLOR_RED}Error: Oh My Zsh directory not found%f" >&2
                fi
                ;;
        esac
        print ""  # Add empty line between updates
    done

    # Print summary of results
    if (( success == total )); then
        print -P "%F{$ZSH_COLOR_GREEN}All updates (${success}/${total}) completed successfully.%f"
        return 0
    elif (( success > 0 )); then
        print -P "%F{$ZSH_COLOR_YELLOW}Partial success: ${success}/${total} updates completed.%f"
        return $(( success < total ? 1 : 0 ))
    else
        print -P "%F{$ZSH_COLOR_RED}Error: No updates completed successfully.%f"
        return 1
    fi
}
