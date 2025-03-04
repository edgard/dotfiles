alias history='history 1'
alias grep="grep --color --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.git --exclude-dir=.bzr --exclude-dir=CVS --binary-files=without-match"
[[ "${OSTYPE}" == "darwin"* ]] && alias ls="ls -FGh"
[[ "${OSTYPE}" == "linux"* ]] && alias ls="ls -FGhN --color=auto"

# Kubernetes aliases
if command -v kubectl >/dev/null 2>&1; then
    alias k="kubectl"
    alias kg="kubectl get"
    alias kl="kubectl logs"
    alias kd="kubectl describe"
    alias krm="kubectl delete"
    command -v kubens >/dev/null 2>&1 && alias kns="kubens"
    command -v kubectx >/dev/null 2>&1 && alias kctx="kubectx"
fi

# System update function
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
        [[ "${OSTYPE}" == "darwin"* ]] && command -v brew-cask-upgrade >/dev/null 2>&1 && brew cu -y -q --cleanup --no-brew-update
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

# Homebrew cleanup function - removes packages not in Brewfiles
if command -v brew >/dev/null 2>&1; then
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

        # Create combined Brewfile
        touch "${temp_brewfile}"

        if [[ -f "${common_brewfile}" ]]; then
            cat "${common_brewfile}" >> "${temp_brewfile}"
        else
            echo "Warning: Common Brewfile not found at ${common_brewfile}"
        fi

        if [[ -n "${os_brewfile}" && -f "${os_brewfile}" ]]; then
            cat "${os_brewfile}" >> "${temp_brewfile}"
        elif [[ -n "${os_brewfile}" ]]; then
            echo "Warning: OS-specific Brewfile not found at ${os_brewfile}"
        fi

        echo "Checking for packages not in any Brewfile..."
        cleanup_output=$(brew bundle cleanup --file="${temp_brewfile}" --zap 2>&1 || true)
        echo "$cleanup_output" | grep -v "^Using "

        if echo "$cleanup_output" | grep -q "Would uninstall"; then
            echo ""
            echo "Do you want to remove these packages? (y/n)"
            read REPLY
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

    # Homebrew install function - installs packages from Brewfiles
    function brew-install() {
        local brewfiles_dir="${HOME}/.local/share/chezmoi/extras"
        local common_brewfile="${brewfiles_dir}/Brewfile.common"
        local os_brewfile=""
        local install_success=true

        if [[ "${OSTYPE}" == "darwin"* ]]; then
            os_brewfile="${brewfiles_dir}/Brewfile.darwin"
        elif [[ "${OSTYPE}" == "linux"* ]]; then
            os_brewfile="${brewfiles_dir}/Brewfile.linux"
        fi

        echo "Updating Homebrew..."
        brew update

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

        if [[ "$install_success" = true ]]; then
            echo "All packages installed successfully."
        else
            echo "Some packages failed to install. Check the output above for details."
        fi
    }
fi
