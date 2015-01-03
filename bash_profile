#!/bin/bash

# environment variables
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export PAGER="less"
export LESS="-RQM"
export GZIP="-v9N"
export GREP_OPTIONS="--color --exclude-dir=.svn --exclude-dir=.git --binary-files=without-match"
export PATH="/usr/local/bin:$PATH"

# aliases
alias ls="ls -GFh"
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias hist='history | grep'

# go
export GOPATH="$HOME/.go"
export GOROOT="$(brew --prefix)/Cellar/go/$(go version | cut -f3 -d' ' | sed 's/go//')/libexec"
export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"

# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# autojump
[[ -f $(brew --prefix)/etc/autojump.sh ]] && . "$(brew --prefix)/etc/autojump.sh"

# bash completion
[[ -f $(brew --prefix)/etc/bash_completion ]] && . "$(brew --prefix)/etc/bash_completion"

# boot2docker
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=/Users/edgard/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1
