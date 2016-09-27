# aliases
alias j='z'
alias history='history 1'
alias ls='ls -FGh --color=auto'
alias grep='grep --color --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.git --exclude-dir=.bzr --exclude-dir=CVS --binary-files=without-match'
alias open='xdg-open &> /dev/null'

update() {
    pacaur -Syyu && sudo pacman -Rns $(pacman -Qtdq)

    opt_repos="hardcode-fixer,Hardcode-Tray,numix-folders"
    current_user=${USER}
    current_group=$(id -gn)
    for repo in ${opt_repos//,/ }; do
        echo "Updating opt repo ${repo}..."
        (cd "/opt/${repo}" && git pull)
        chown -R "${current_user}"."${current_group}" "/opt/${repo}"
    done

    sudo /opt/hardcode-fixer/fix.sh
    /opt/Hardcode-Tray/hardcode-tray --apply
    sudo /opt/numix-folders/numix-folders -p

    rm -f ~/.local/share/applications/telegramdesktop.desktop
}
