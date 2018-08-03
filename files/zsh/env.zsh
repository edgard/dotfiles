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
export EDITOR='code -w -n'
export VISUAL='code -w -n'

# gcloud
source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
