# history
HISTFILE=~/.zsh_history
HISTSIZE=500000
SAVEHIST=500000


# prompt
PROMPT='[%n:%1~]%(!.#.$) '


# env
export PAGER='less'
export LESS='-R'
export EDITOR='code -w -n'
export VISUAL='code -w -n'
export BROWSER='chromium'


# env: go
if hash go 2>/dev/null; then
  export GOPATH=~/Documents/Projects/go
  echo $PATH | grep -q $GOPATH/bin || export PATH=$GOPATH/bin:$PATH
fi
