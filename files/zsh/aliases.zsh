#!/bin/zsh

# aliases
alias j='z'
alias history='history 1'
alias grep='grep --color --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.git --exclude-dir=.bzr --exclude-dir=CVS --binary-files=without-match'
if_nix gnu && alias ls='ls -FGhN --color=auto'
if_nix bsd && alias ls='ls -FGh'
if_os linux && alias open='xdg-open &> /dev/null'
if_os linux && alias cleanup='sudo pacman -Rsn $(pacman -Qqdt)'
if_os linux && alias update=update_linux
if_os darwin && alias update='brew update && brew upgrade'

update_linux() {
    pacaur -Syyuu --needed && sudo pacman -Rns $(pacman -Qtdq)

    sudo hardcode-fixer
    hardcode-tray --apply --conversion-tool Inkscape --theme Papirus --size 22

    rm -f ~/.local/share/applications/telegramdesktop.desktop
}
