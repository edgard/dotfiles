# aliases
alias j='z'
alias history='history 1'
alias ls='ls -FGh --color=auto'
alias grep='grep --color --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.git --exclude-dir=.bzr --exclude-dir=CVS --binary-files=without-match'
alias open='xdg-open &> /dev/null'
alias cleanup='sudo pacman -Rsn $(pacman -Qqdt)'

update() {
    pacaur -Syyuu --needed $* && sudo pacman -Rns $(pacman -Qtdq)

    sudo hardcode-fixer
    sudo -E /opt/hardcode-tray-fixer/script.py --apply
    sudo numix-folders -p

    rm -f ~/.local/share/applications/telegramdesktop.desktop
}
