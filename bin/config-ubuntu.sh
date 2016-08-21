#!/bin/bash

# install gnome-extensions
read -n 1 -p "Would you like to install gnome extensions? (y/n) " -r response; echo
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    GNOME_VERSION=$(gnome-shell --version | awk '{split($3,a,"."); print a[1]"."a[2];}')
    ./shell-extension-install "${GNOME_VERSION}" 517    # caffeine
    ./shell-extension-install "${GNOME_VERSION}" 307    # dash-to-dock
    ./shell-extension-install "${GNOME_VERSION}" 1005   # focus my window
    ./shell-extension-install "${GNOME_VERSION}" 277    # impatience
    ./shell-extension-install "${GNOME_VERSION}" 495    # topicons
    ./shell-extension-install "${GNOME_VERSION}" 657    # shelltile
    ./shell-extension-install "${GNOME_VERSION}" 15     # alternate-tab
    ./shell-extension-install "${GNOME_VERSION}" 355    # status area horizontal spacing
    ./shell-extension-install "${GNOME_VERSION}" 118    # no topleft hot corner
    ./shell-extension-install "${GNOME_VERSION}" 18     # native window placement
    ./shell-extension-install "${GNOME_VERSION}" 320    # window overlay icons
    gsettings set org.gnome.shell enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com', 'caffeine@patapon.info', 'dash-to-dock@micxgx.gmail.com', 'focus-my-window@varianto25.com', 'impatience@gfxmonk.net', 'topIcons@adel.gadllah@gmail.com', 'ShellTile@emasab.it', 'alternate-tab@gnome-shell-extensions.gcampax.github.com', 'status-area-horizontal-spacing@mathematical.coffee.gmail.com', 'nohotcorner@azuri.free.fr', 'native-window-placement@gnome-shell-extensions.gcampax.github.com', 'windowoverlay-icons@sustmidown.centrum.cz']"
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
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'gnome-terminal.desktop', 'code.desktop', 'spotify.desktop', 'whatsie.desktop', 'telegram.desktop', 'google-chrome.desktop']"
gsettings set org.gnome.nautilus.preferences sort-directories-first true
gsettings set org.gtk.Settings.FileChooser sort-directories-first true
gsettings set org.gnome.nautilus.preferences executable-text-activation "'launch'"
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "'<Super>Return'"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Shift><Super>1']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Shift><Super>2']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Shift><Super>3']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Shift><Super>4']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Shift><Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1  "['<Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2  "['<Super>2']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3  "['<Super>3']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4  "['<Super>4']"

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

# terminal (one-dark)
gsettings set org.gnome.Terminal.Legacy.Settings new-terminal-mode "'tab'"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" use-system-font false
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" font "'PragmataPro Mono 12'"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" login-shell true
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" palette "['rgb(0,0,0)', 'rgb(224,108,117)', 'rgb(152,195,121)', 'rgb(209,154,102)', 'rgb(97,174,238)', 'rgb(198,120,221)', 'rgb(86,182,194)', 'rgb(171,178,191)', 'rgb(92,99,112)', 'rgb(224,108,117)', 'rgb(152,195,121)', 'rgb(209,154,102)', 'rgb(98,175,238)', 'rgb(198,120,221)', 'rgb(86,182,194)', 'rgb(255,255,255)']"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" background-color "'rgb(40,44,52)'"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" foreground-color "'rgb(171,178,191)'"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" bold-color "'rgb(171,178,191)'"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" bold-color-same-as-fg true
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" use-theme-colors false

# mimetypes
gvfs-mime --set x-scheme-handler/mailto thunderbird.desktop
gvfs-mime --set x-scheme-handler/webcal thunderbird.desktop
gvfs-mime --set text/calendar thunderbird.desktop
