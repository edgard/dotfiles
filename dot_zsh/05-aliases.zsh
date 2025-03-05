# Shell aliases
# Contains all shell aliases organized by category

#
# General Unix Commands
#

# Add color support to basic commands
alias grep="grep --color=auto --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.git --exclude-dir=.bzr --exclude-dir=CVS --binary-files=without-match"
alias diff="diff --color=auto"
alias ip="ip --color=auto"

# System commands with improved output
alias dmesg="dmesg --color=auto"
alias journalctl="journalctl --output=auto-long"
alias watch="watch --color"

# Better defaults
alias history='history 1'  # Show timestamps in history

#
# Kubernetes Aliases
#

if command -v kubectl >/dev/null 2>&1; then
    # Core kubectl commands
    alias k="kubectl"
    alias kg="kubectl get"
    alias kl="kubectl logs"
    alias kd="kubectl describe"
    alias krm="kubectl delete"

    # Additional tooling if available
    command -v kubens >/dev/null 2>&1 && alias kns="kubens"
    command -v kubectx >/dev/null 2>&1 && alias kctx="kubectx"
fi
