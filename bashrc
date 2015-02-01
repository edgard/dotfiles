#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Bash prompt
PS1='[\u@\h \W]\$ '

# environment variables
export PAGER="less"
export EDITOR="atom -w -n"

# aliases
alias ls="ls -Fh --color=auto"
alias grep="grep --color --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.git --binary-files=without-match"
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias open="xdg-open"
alias update="sudo yum upgrade -y; apm upgrade"

# dircolors
[[ -f "$HOME/.dir_colors" ]] && eval "$(dircolors -b $HOME/.dir_colors)"

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
[[ -f "$HOME/.rbenv/bin/rbenv" ]] && eval "$(rbenv init -)"

# autojump
[[ -s /etc/profile.d/autojump.bash ]] && source /etc/profile.d/autojump.bash

# autocomplete
[[ -e "$HOME/.ssh/config" ]] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

# misctools
source ~/.bin/misctools

# dockertools
source ~/.bin/dockertools
