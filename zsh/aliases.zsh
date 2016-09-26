# aliases
alias j='z'
alias history='history 1'
alias ls='ls -FGh --color=auto'
alias grep='grep --color --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.git --exclude-dir=.bzr --exclude-dir=CVS --binary-files=without-match'
alias update='pacaur -Syyu; sudo pacman -Rns $(pacman -Qtdq); (cd /opt/hardcode-fixer && git pull); sudo /opt/hardcode-fixer/fix.sh; (cd /opt/Hardcode-Tray && git pull); /opt/Hardcode-Tray/hardcode-tray --apply; (cd /opt/numix-folders && git pull); sudo /opt/numix-folders/numix-folders -p; rm -f ~/.local/share/applications/telegramdesktop.desktop; sudo chown -R edgard.users /opt/{hardcode-fixer,Hardcode-Tray,numix-folders}'
alias open='xdg-open &> /dev/null'
