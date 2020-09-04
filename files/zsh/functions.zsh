# -----------------------------------------------------------------------------
# functions
# -----------------------------------------------------------------------------

[[ "${OSTYPE}" == "darwin"* ]] && function update() {
    brew update
    brew upgrade
    brew cask outdated | xargs brew cask reinstall
    mas upgrade
    brew cleanup -s
}

[[ "${OSTYPE}" == "linux"* ]] && function update() {
    sudo apt update
    sudo apt dist-upgrade
}
