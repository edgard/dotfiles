#
# ~/.bash_profile
#

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# os detection
if_os () { [[ $OSTYPE == *$1* ]]; }
if_nix () {
  case "$OSTYPE" in
    *linux*|*hurd*|*msys*|*cygwin*|*sua*|*interix*) sys="gnu";;
    *bsd*|*darwin*) sys="bsd";;
    *sunos*|*solaris*|*indiana*|*illumos*|*smartos*) sys="sun";;
  esac
  [[ "${sys}" == "$1" ]];
}

# bash prompt
PS1='[\u@\h \W]\$ '

# bash options
shopt -s histappend
shopt -s checkwinsize
shopt -s cmdhist
HISTCONTROL="erasedups:ignoreboth"
HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history"
HISTSIZE=500000
HISTFILESIZE=100000

# environment variables
export PAGER="less"
export EDITOR="code -w -n"
export VISUAL="code -w -n"

# aliases
alias grep="grep --color --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.git --binary-files=without-match"
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
if_nix gnu && alias ls="ls -FGh --color=auto"
if_nix bsd && alias ls="ls -FGh"
if_os linux && alias update="sudo apt-get update && sudo apt-get dist-upgrade; sudo /opt/hardcode-fixer/fix.sh; /opt/Hardcode-Tray/hardcode-tray --apply; rm -f ~/.local/share/applications/telegramdesktop.desktop; sudo chown -R edgard.edgard /opt/{telegram,hardcode-fixer,Hardcode-Tray}"
if_os darwin && alias update="brew update && brew upgrade"
if_nix gnu && alias open="gnome-open &> /dev/null"

# dircolors
[[ -f "$HOME/.dir_colors" ]] && eval "$(dircolors -b $HOME/.dir_colors)"

# autojump
(if_os linux && [[ -f /usr/share/autojump/autojump.bash ]]) && source "/usr/share/autojump/autojump.bash"
(if_os darwin && [[ -f /usr/local/etc/profile.d/autojump.sh ]]) && source "/usr/local/etc/profile.d/autojump.sh"

# bash completion
(if_os darwin && [[ -f /usr/local/etc/bash_completion ]]) && source "/usr/local/etc/bash_completion"

# autocomplete ssh
[[ -f "$HOME/.ssh/config" ]] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

# go
export GOPATH=$HOME/Documents/Projects/go
export PATH=$PATH:$GOPATH/bin

# cwd first in path
export PATH=.:$PATH
