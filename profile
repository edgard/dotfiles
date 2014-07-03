#!/bin/bash

# lang
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# aliases
alias vim=mvim
alias vi=mvim
alias ls="ls -GFh"

# editor
export EDITOR="vim"

# misc options
export GREP_OPTIONS="--exclude-dir=.svn --exclude-dir=.git --binary-files=without-match"
export LESS="-XMcifR"

# go
#export GOPATH="$HOME/.go"
#export GOROOT="(brew --prefix)/Cellar/go/(go version | cut -f3 -d' ' | sed 's/go//')/libexec"
#export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"

# autojump
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
