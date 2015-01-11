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
alias grep="grep --color --exclude-dir=.svn --exclude-dir=.git --binary-files=without-match"
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias hist='history | grep'

# dircolors
if [ -f "$HOME/.dir_colors" ] ; then
  eval $(dircolors -b $HOME/.dir_colors)
fi

# go
export GOPATH="$HOME/.go"
export PATH="$PATH:$GOPATH/bin"

# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# autojump
[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh
