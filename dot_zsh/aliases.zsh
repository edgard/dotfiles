# -----------------------------------------------------------------------------
# aliases
# -----------------------------------------------------------------------------

# misc
alias history='history 1'
alias grep="grep --color --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.git --exclude-dir=.bzr --exclude-dir=CVS --binary-files=without-match"
[[ "${OSTYPE}" == "darwin"* ]] && alias ls="ls -FGh"
[[ "${OSTYPE}" == "linux"* ]] && alias ls="ls -FGhN --color=auto"

# kubernetes
alias k="kubectl"
alias kns="kubens"
alias kctx="kubectx"
