#!/bin/zsh

# history
HISTFILE=~/.zsh_history
HISTSIZE=500000
SAVEHIST=500000


# prompt
PROMPT='[%n:%1~]%(!.#.$) '


# env
export PAGER='less'
export LESS='-R'
export EDITOR='atom -w -n'
export VISUAL='atom -w -n'
export PROJECT_HOME=~/Documents/Projects


# env: go
if hash go 2>/dev/null; then
  export GOPATH=$PROJECT_HOME/go
  echo $PATH | grep -q $GOPATH/bin || export PATH=$GOPATH/bin:$PATH
fi
