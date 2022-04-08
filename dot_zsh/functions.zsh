# -----------------------------------------------------------------------------
# functions
# -----------------------------------------------------------------------------

[[ "${OSTYPE}" == "darwin"* ]] && function update() {
    brew update
    brew upgrade
    brew cask outdated | xargs brew cask reinstall
    mas upgrade
    brew cleanup -s
    zplug update
    asdf update
    asdf plugin update --all
    asdf reshim
    chezmoi update
}

[[ "${OSTYPE}" == "linux"* ]] && function update() {
    sudo apt update
    sudo apt dist-upgrade -y
    sudo apt autoremove --purge -y
    zplug update
    asdf update
    asdf plugin update --all
    asdf reshim
    chezmoi update
}
