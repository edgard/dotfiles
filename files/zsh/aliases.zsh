# -----------------------------------------------------------------------------
# aliases
# -----------------------------------------------------------------------------

alias hs='history -a; history -n'
alias grep="grep --color --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.git --exclude-dir=.bzr --exclude-dir=CVS --binary-files=without-match"
[[ "${OSTYPE}" == "darwin"* ]] && alias ls="ls -FGh"
[[ "${OSTYPE}" == "linux"* ]] && alias ls="ls -FGhN --color=auto"

# kubernetes
alias k='kubectl'
alias ksys='kubectl --namespace=kube-system'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kctx='kubectl config use-context'
