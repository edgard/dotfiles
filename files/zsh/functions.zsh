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
    yay -Syyuu --needed
    yay -Rns "$(yay -Qtdq)"
}
