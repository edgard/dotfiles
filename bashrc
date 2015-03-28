#
# ~/.bashrc
#

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# bash prompt
PS1='[\u@\h \W]\$ '

# bash options
shopt -s histappend
shopt -s checkwinsize
shopt -s direxpand

# environment variables
export PAGER="less"
export EDITOR="atom -w -n"
export VISUAL="atom -w -n"

# aliases
alias ls="ls -Fh --color=auto"
alias grep="grep --color --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.git --binary-files=without-match"
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias open="xdg-open"
alias update="sudo yum upgrade -y --skip-broken; apm upgrade"
syncdoc() { rsync -azv --delete --include="*" /home/edgard/Documents/ $1:/home/edgard/Documents/; }

# dircolors
[[ -f "$HOME/.dir_colors" ]] && eval "$(dircolors -b $HOME/.dir_colors)"

# autojump
[[ -s /etc/profile.d/autojump.bash ]] && source /etc/profile.d/autojump.bash

# autocomplete
[[ -e "$HOME/.ssh/config" ]] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

# go
export GOPATH=$HOME/Documents/code/go
export PATH=$PATH:$GOPATH/bin

# cwd first in path
export PATH=.:$PATH
