# -----------------------------------------------------------------------------
# aliases
# -----------------------------------------------------------------------------

alias history='history 1'
alias grep="grep --color --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.git --exclude-dir=.bzr --exclude-dir=CVS --binary-files=without-match"
[[ "${OSTYPE}" == "darwin"* ]] && alias ls="ls -FGh"
[[ "${OSTYPE}" == "linux"* ]] && alias ls="ls -FGhN --color=auto"

# kubernetes
alias k="kubectl"
alias kg="kubectl get"
alias kl="kubectl logs"
alias kd="kubectl describe"
alias krm="kubectl delete"
alias kns="kubens"
alias kctx="kubectx"

# update functions
[[ "${OSTYPE}" == "darwin"* ]] && function update() {
    chezmoi update
    brew update
    brew upgrade
    brew cask outdated | xargs brew cask reinstall
    mas upgrade
    brew cleanup -s
    asdf update
    asdf plugin update --all
    asdf install
    asdf reshim
}

[[ "${OSTYPE}" == "linux"* ]] && function update() {
    chezmoi update
    sudo apt update
    sudo apt dist-upgrade -y
    sudo apt autoremove --purge -y
    asdf update
    asdf plugin update --all
    asdf install
    asdf reshim
}
