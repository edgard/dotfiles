#
# ~/.bash_profile
#

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# bash prompt
PS1='[\u@\h \W]\$ '

# bash options
shopt -s histappend
shopt -s checkwinsize
HISTCONTROL=ignoreboth

# environment variables
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export PAGER="less"
export EDITOR="atom -w -n"
export VISUAL="atom -w -n"

# aliases
alias ls="ls -FGh"
alias grep="grep --color --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.git --binary-files=without-match"
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# dircolors
[[ -f "$HOME/.dir_colors" ]] && eval "$(dircolors -b $HOME/.dir_colors)"

# autojump
[[ -f /usr/local/etc/profile.d/autojump.sh ]] && source "/usr/local/etc/profile.d/autojump.sh"

# bash completion
[[ -f /usr/local/etc/bash_completion ]] && source "/usr/local/etc/bash_completion"

# autocomplete ssh
[[ -f "$HOME/.ssh/config" ]] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

# go
export GOPATH=$HOME/Documents/code/go
export PATH=$PATH:$GOPATH/bin

# cwd first in path
export PATH=.:$PATH
