#!/bin/zsh

# aliases
alias j='z'
alias history='history 1'
alias grep='grep --color --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.git --exclude-dir=.bzr --exclude-dir=CVS --binary-files=without-match'
alias ls='ls -FGh'
alias update='brew update && brew upgrade; mas upgrade'

showhiddenfiles(){
  case "$1" in
    on)
        defaults write com.apple.finder AppleShowAllFiles true
        killall Finder
        ;;
    off)
        defaults write com.apple.finder AppleShowAllFiles false
        killall Finder
        ;;
    *)
        echo "Usage: $0 {on|off}"
        ;;
  esac
}
