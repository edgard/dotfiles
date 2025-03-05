# Shell functions
# Contains utility functions and command enhancements

#
# System Management Functions
#

# Comprehensive system update function
# Updates dotfiles, homebrew packages, and system packages
function update() {
    local updated=0

    if command -v chezmoi >/dev/null 2>&1; then
        echo "Updating dotfiles with chezmoi..."
        chezmoi update
        updated=1
    fi

    if command -v brew >/dev/null 2>&1; then
        echo "Updating Homebrew packages..."
        brew update
        brew upgrade
        [[ "${OSTYPE}" == "darwin"* ]] && brew cu --help >/dev/null 2>&1 && brew cu -y -q --cleanup --no-brew-update
        brew cleanup -s
        updated=1
    fi

    if [[ "${OSTYPE}" == "linux"* ]] && command -v apt >/dev/null 2>&1; then
        echo "Updating system packages..."
        sudo apt update
        sudo apt dist-upgrade -y
        sudo apt autoremove --purge -y
        updated=1
    fi

    [[ $updated -eq 0 ]] && echo "No package managers found to update"
}

#
# File System Functions
#

# Enhanced ls function with cross-platform color support
function ls() {
    local exit_status

    if [[ "${OSTYPE}" == "darwin"* ]] && command -v gls >/dev/null 2>&1; then
        # macOS with GNU ls
        gls -FhN --color=auto "$@"
        exit_status=$?
    elif [[ "${OSTYPE}" == "darwin"* ]]; then
        # macOS with standard ls
        command ls -FGh "$@"
        exit_status=$?
    else
        # Linux
        command ls -FhN --color=auto "$@"
        exit_status=$?
    fi

    return $exit_status
}

#
# Homebrew Management Functions
#

if command -v brew >/dev/null 2>&1; then
    # Removes packages not listed in Brewfiles
    function brew-cleanup() {
        local brewfiles_dir="${HOME}/.local/share/chezmoi/extras"
        local common_brewfile="${brewfiles_dir}/Brewfile.common"
        local os_brewfile=""
        local temp_brewfile=$(mktemp)
        local cleanup_output=""

        # Determine OS-specific Brewfile
        if [[ "${OSTYPE}" == "darwin"* ]]; then
            os_brewfile="${brewfiles_dir}/Brewfile.darwin"
        elif [[ "${OSTYPE}" == "linux"* ]]; then
            os_brewfile="${brewfiles_dir}/Brewfile.linux"
        fi

        echo "Creating temporary combined Brewfile..."

        # Combine Brewfiles
        touch "${temp_brewfile}"
        [[ -f "${common_brewfile}" ]] && cat "${common_brewfile}" >> "${temp_brewfile}"
        [[ -f "${os_brewfile}" ]] && cat "${os_brewfile}" >> "${temp_brewfile}"

        # Check for packages to remove
        echo "Checking for packages not in any Brewfile..."
        cleanup_output=$(brew bundle cleanup --file="${temp_brewfile}" --zap 2>&1 || true)
        echo "$cleanup_output" | grep -v "^Using "

        # Prompt for cleanup if needed
        if echo "$cleanup_output" | grep -q "Would uninstall"; then
            echo -e "\nDo you want to remove these packages? (y/n)"
            read -r REPLY
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "Removing packages not in any Brewfile..."
                brew bundle cleanup --file="${temp_brewfile}" --zap --force
                echo "Homebrew cleanup complete."
            else
                echo "Cleanup cancelled."
            fi
        else
            echo "No packages to remove. All installed packages are in your Brewfiles."
        fi

        rm "${temp_brewfile}"
    }

    # Installs packages from Brewfiles
    function brew-install() {
        local brewfiles_dir="${HOME}/.local/share/chezmoi/extras"
        local common_brewfile="${brewfiles_dir}/Brewfile.common"
        local os_brewfile=""
        local install_success=true

        # Determine OS-specific Brewfile
        if [[ "${OSTYPE}" == "darwin"* ]]; then
            os_brewfile="${brewfiles_dir}/Brewfile.darwin"
        elif [[ "${OSTYPE}" == "linux"* ]]; then
            os_brewfile="${brewfiles_dir}/Brewfile.linux"
        fi

        echo "Updating Homebrew..."
        brew update

        # Install from common Brewfile
        if [[ -f "${common_brewfile}" ]]; then
            echo "Installing packages from common Brewfile..."
            if ! brew bundle --file="${common_brewfile}"; then
                echo "Warning: Some packages from common Brewfile failed to install."
                install_success=false
            fi
        else
            echo "Warning: Common Brewfile not found at ${common_brewfile}"
            install_success=false
        fi

        # Install from OS-specific Brewfile
        if [[ -n "${os_brewfile}" && -f "${os_brewfile}" ]]; then
            echo "Installing packages from OS-specific Brewfile..."
            if ! brew bundle --file="${os_brewfile}"; then
                echo "Warning: Some packages from OS-specific Brewfile failed to install."
                install_success=false
            fi
        elif [[ -n "${os_brewfile}" ]]; then
            echo "Warning: OS-specific Brewfile not found at ${os_brewfile}"
            install_success=false
        fi

        # Report results
        if [[ "$install_success" = true ]]; then
            echo "All packages installed successfully."
        else
            echo "Some packages failed to install. Check the output above for details."
        fi
    }
fi
