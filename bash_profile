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
shopt -s cmdhist
HISTCONTROL="erasedups:ignoreboth"
HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:update"
HISTSIZE=500000
HISTFILESIZE=100000

# environment variables
export PAGER="less"
export EDITOR="atom -w -n"
export VISUAL="atom -w -n"

# aliases
alias grep="grep --color --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.git --binary-files=without-match"
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias ls="ls -FGh --color=auto"
alias update="pacaur -Syyu; sudo pacman -Rns --noconfirm --noprogressbar $(pacman -Qtdq); apm upgrade; (cd /opt/hardcode-fixer && git pull); sudo /opt/hardcode-fixer/fix.sh; (cd /opt/Hardcode-Tray && git pull); /opt/Hardcode-Tray/hardcode-tray --apply; rm -f ~/.local/share/applications/telegramdesktop.desktop; sudo chown -R edgard.users /opt/{hardcode-fixer,Hardcode-Tray}"
alias open="xdg-open &> /dev/null"

# autojump
[[ -f /usr/share/autojump/autojump.bash ]] && source "/usr/share/autojump/autojump.bash"

# autocomplete ssh
[[ -f "$HOME/.ssh/config" ]] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

# go
export GOPATH=$HOME/Documents/Projects/go
export PATH=$PATH:$GOPATH/bin

# cwd first in path
export PATH=.:$PATH
