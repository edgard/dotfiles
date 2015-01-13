#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Bash prompt
PS1='[\u@\h \W]\$ '

# environment variables
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export PAGER="less"
export LESS="-RQM"
export GZIP="-v9N"
export EDITOR="atom -w -n"

# aliases
alias ls="ls -GFh --color=auto"
alias grep="grep --color --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.git --binary-files=without-match"
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias update="pacaur -Syu; apm upgrade"
alias h='history | grep'

# dircolors
[[ -f "$HOME/.dir_colors" ]] && eval "$(dircolors -b $HOME/.dir_colors)"

# go
export GOPATH="$HOME/.go"
export PATH="$PATH:$GOPATH/bin"

# rbenv
[[ -f /usr/bin/rbenv ]] && eval "$(rbenv init -)"

# autojump
[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh

# autocomplete
[[ -e "$HOME/.ssh/config" ]] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;
