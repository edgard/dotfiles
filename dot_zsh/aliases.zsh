# Shell aliases

# General aliases
alias history='history 1'
alias grep="grep --color --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.git --exclude-dir=.bzr --exclude-dir=CVS --binary-files=without-match"
alias diff="diff --color=auto"
alias ip="ip --color=auto"
alias dmesg="dmesg --color=auto"
alias gcc="gcc -fdiagnostics-color=auto"
alias g++="g++ -fdiagnostics-color=auto"
alias journalctl="journalctl --output=auto-long"
alias watch="watch --color"

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
