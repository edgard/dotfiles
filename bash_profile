#!/bin/bash

# lang
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# aliases
alias ls="ls -GFh"
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias hist='history | grep'

# misc options
export GREP_OPTIONS="--color --exclude-dir=.svn --exclude-dir=.git --binary-files=without-match"

# go
#export GOPATH="$HOME/.go"
#export GOROOT="(brew --prefix)/Cellar/go/(go version | cut -f3 -d' ' | sed 's/go//')/libexec"
#export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"

# localbin before everything
export PATH="/usr/local/bin:$PATH"

# autojump
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
