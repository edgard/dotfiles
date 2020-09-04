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
}

[[ "${OSTYPE}" == "linux"* ]] && function update() {
    sudo apt update
    sudo apt dist-upgrade -y
    sudo apt autoremove --purge -y
    zplug update
}
