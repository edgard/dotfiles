#!/bin/zsh

# plugins
export ZPLUG_HOME=/usr/local/opt/zplug && source $ZPLUG_HOME/init.zsh


# plugin list
zplug "zsh-users/zsh-completions"
zplug "bobthecow/git-flow-completion"
zplug "rupa/z", use:z.sh
zplug "zsh-users/zsh-autosuggestions", defer:1
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3


# install plugins which haven't been installed yet
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
      echo; zplug install
  else
      echo
  fi
fi


# load zplug
zplug load