#!/bin/bash

# install gnome-extensions
read -n 1 -p "Would you like to install gnome extensions? (y/n) " -r response; echo
if [[ $response =~ ^([yY])$ ]]; then
    GNOME_VERSION=$(gnome-shell --version | awk '{split($3,a,"."); print a[1]"."a[2];}')
    ./gnomeshell-extension-manage --install --version "${GNOME_VERSION}" --extension-id 517    # caffeine
    ./gnomeshell-extension-manage --install --version "${GNOME_VERSION}" --extension-id 307    # dash-to-dock
    ./gnomeshell-extension-manage --install --version "${GNOME_VERSION}" --extension-id 1005   # focus my window
    ./gnomeshell-extension-manage --install --version "${GNOME_VERSION}" --extension-id 277    # impatience
    ./gnomeshell-extension-manage --install --version "${GNOME_VERSION}" --extension-id 495    # topicons
    ./gnomeshell-extension-manage --install --version "${GNOME_VERSION}" --extension-id 657    # shelltile
    ./gnomeshell-extension-manage --install --version "${GNOME_VERSION}" --extension-id 15     # alternate-tab
    ./gnomeshell-extension-manage --install --version "${GNOME_VERSION}" --extension-id 355    # status area horizontal spacing
    ./gnomeshell-extension-manage --install --version "${GNOME_VERSION}" --extension-id 118    # no topleft hot corner
    ./gnomeshell-extension-manage --install --version "${GNOME_VERSION}" --extension-id 320    # window overlay icons
    ./gnomeshell-extension-manage --install --version "${GNOME_VERSION}" --extension-id 905    # refresh wifi connections
    ./gnomeshell-extension-manage --install --version "${GNOME_VERSION}" --extension-id 904    # disconnect wifi
    gsettings set org.gnome.shell enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com', 'caffeine@patapon.info', 'dash-to-dock@micxgx.gmail.com', 'focus-my-window@varianto25.com', 'impatience@gfxmonk.net', 'topIcons@adel.gadllah@gmail.com', 'ShellTile@emasab.it', 'alternate-tab@gnome-shell-extensions.gcampax.github.com', 'status-area-horizontal-spacing@mathematical.coffee.gmail.com', 'nohotcorner@azuri.free.fr', 'windowoverlay-icons@sustmidown.centrum.cz', 'refresh-wifi@kgshank.net', 'disconnect-wifi@kgshank.net']"
fi

# install atom extensions
read -n 1 -p "Would you like to install atom extensions? (y/n) " -r response; echo
if [[ $response =~ ^([yY])$ ]]; then
  apm install atom-beautify go-plus language-ansible linter-ansible-linting linter-pylint pigments sort-lines tab-control
  apm dedupe
fi

# install icon fixers
read -n 1 -p "Would you like to install icon fixers? (y/n) " -r response; echo
if [[ $response =~ ^([yY])$ ]]; then
  sudo git clone https://github.com/Foggalong/hardcode-fixer.git /opt/hardcode-fixer/
  sudo git clone https://github.com/bil-elmoussaoui/Hardcode-Tray.git /opt/Hardcode-Tray/

  TOUSER=${USER}
  TOGROUP=$(id -gn)
  sudo chown -R "${TOUSER}"."${TOGROUP}" /opt/{hardcode-fixer,Hardcode-Tray}
fi


# gnome-shell
gsettings set org.gnome.desktop.datetime automatic-timezone true
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+intl')]"
gsettings set org.gnome.desktop.interface clock-format "'12h'"
gsettings set org.gtk.Settings.FileChooser clock-format "'12h'"
gsettings set org.gnome.desktop.interface icon-theme "'Numix-Circle'"
gsettings set org.gnome.desktop.interface gtk-theme "'Arc'"
gsettings set org.gnome.shell.extensions.user-theme name "'Arc-Dark'"
gsettings set org.gnome.desktop.peripherals.mouse speed -0.8
gsettings set org.gnome.desktop.wm.preferences button-layout "'appmenu:minimize,maximize,close'"
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type "'suspend'"
gsettings set org.gnome.shell.overrides dynamic-workspaces false
gsettings set org.gnome.system.locale region "'en_US.UTF-8'"
gsettings set org.gnome.system.location enabled true
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'gnome-terminal.desktop', 'atom.desktop', 'spotify.desktop', 'whatsie.desktop', 'telegramdesktop.desktop', 'google-chrome.desktop']"
gsettings set org.gnome.nautilus.preferences sort-directories-first true
gsettings set org.gtk.Settings.FileChooser sort-directories-first true
gsettings set org.gnome.nautilus.preferences executable-text-activation "'launch'"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Shift><Super>1']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Shift><Super>2']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Shift><Super>3']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Shift><Super>4']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Shift><Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1  "['<Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2  "['<Super>2']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3  "['<Super>3']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4  "['<Super>4']"
gsettings set org.gnome.settings-daemon.plugins.xsettings hinting "'full'"
gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing "'rgba'"

# app shortcuts
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "'<Super>Return'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "'gnome-terminal'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "'Launch Terminal'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "'<Super>slash'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "'google-chrome-stable'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "'Launch Browser'"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"

# ext: caffeine
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/caffeine@patapon.info/schemas gsettings set org.gnome.shell.extensions.caffeine show-notifications false

# ext: dash-to-dock
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas gsettings set org.gnome.shell.extensions.dash-to-dock preferred-monitor 0
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas gsettings set org.gnome.shell.extensions.dash-to-dock dock-position "'BOTTOM'"
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas gsettings set org.gnome.shell.extensions.dash-to-dock apply-custom-theme true
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas gsettings set org.gnome.shell.extensions.dash-to-dock click-action "'minimize'"
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas gsettings set org.gnome.shell.extensions.dash-to-dock animation-time 0.100
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas gsettings set org.gnome.shell.extensions.dash-to-dock hide-delay 0.200
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas gsettings set org.gnome.shell.extensions.dash-to-dock show-delay 0.0
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas gsettings set org.gnome.shell.extensions.dash-to-dock require-pressure-to-show false
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas gsettings set org.gnome.shell.extensions.dash-to-dock apply-custom-theme false

# ext: impatience
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/impatience@gfxmonk.net/schemas gsettings set org.gnome.shell.extensions.net.gfxmonk.impatience speed-factor 0.5

# ext: status area horizontal spacing
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/status-area-horizontal-spacing@mathematical.coffee.gmail.com/schemas gsettings set org.gnome.shell.extensions.status-area-horizontal-spacing hpadding 3

# ext: shelltile
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/ShellTile@emasab.it/schemas gsettings set org.gnome.shell.extensions.shelltile gap-between-windows 5

# terminal (one-dark)
gsettings set org.gnome.Terminal.Legacy.Settings new-terminal-mode "'tab'"
gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" use-system-font false
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" font "'PragmataPro Mono 12'"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" login-shell true
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" palette "['rgb(0,0,0)', 'rgb(224,108,117)', 'rgb(152,195,121)', 'rgb(209,154,102)', 'rgb(97,174,238)', 'rgb(198,120,221)', 'rgb(86,182,194)', 'rgb(171,178,191)', 'rgb(92,99,112)', 'rgb(224,108,117)', 'rgb(152,195,121)', 'rgb(209,154,102)', 'rgb(98,175,238)', 'rgb(198,120,221)', 'rgb(86,182,194)', 'rgb(255,255,255)']"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" background-color "'rgb(40,44,52)'"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" foreground-color "'rgb(171,178,191)'"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" bold-color "'rgb(171,178,191)'"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" bold-color-same-as-fg true
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" use-theme-colors false
