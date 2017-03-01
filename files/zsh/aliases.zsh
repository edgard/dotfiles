# aliases
alias j='z'
alias history='history 1'
alias ls='ls -FGhN --color=auto'
alias grep='grep --color --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.git --exclude-dir=.bzr --exclude-dir=CVS --binary-files=without-match'
alias open='xdg-open &> /dev/null'
alias cleanup='sudo pacman -Rsn $(pacman -Qqdt)'

update() {
    pacaur -Syyuu --needed $* && sudo pacman -Rns $(pacman -Qtdq)

    sudo hardcode-fixer
    hardcode-tray --apply --conversion-tool Inkscape --theme Papirus --size 22

    rm -f ~/.local/share/applications/telegramdesktop.desktop
}
