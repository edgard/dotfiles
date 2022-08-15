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

# update function
function update() {
    chezmoi update
    brew update
    brew upgrade
    brew cleanup -s

    if [[ "${OSTYPE}" == "linux"* ]]; then
        sudo apt update
        sudo apt dist-upgrade -y
        sudo apt autoremove --purge -y
    fi
}
