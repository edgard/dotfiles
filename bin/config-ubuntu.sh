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
    ./shell-extension-install "${GNOME_VERSION}" 39     # putwindows
    ./shell-extension-install "${GNOME_VERSION}" 15     # alternate-tab
    ./shell-extension-install "${GNOME_VERSION}" 355    # status area horizontal spacing
    gsettings set org.gnome.shell enabled-extensions "['caffeine@patapon.info', 'dash-to-dock@micxgx.gmail.com', 'focus-my-window@varianto25.com', 'impatience@gfxmonk.net', 'topIcons@adel.gadllah@gmail.com', 'putWindow@clemens.lab21.org', 'alternate-tab@gnome-shell-extensions.gcampax.github.com', 'status-area-horizontal-spacing@mathematical.coffee.gmail.com']"
fi

# gnome-shell
gsettings set org.gnome.desktop.datetime automatic-timezone true
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+intl')]"
gsettings set org.gnome.desktop.interface clock-format "'12h'"
gsettings set org.gtk.Settings.FileChooser clock-format "'12h'"
gsettings set org.gnome.desktop.interface icon-theme "'Numix-Circle'"
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

# shortcuts: printscreen
gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot "''"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "'shutter -f'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "'Screenshot'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "'Print'"
gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot "''"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "'shutter -w'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "'Screenshot Window'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "'<Alt>Print'"
gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot "''"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command "'shutter -s'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name "'Screenshot Area'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding "'<Shift>Print'"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/']"

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
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas gsettings set org.gnome.shell.extensions.dash-to-dock show-delay 0.100
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas gsettings set org.gnome.shell.extensions.dash-to-dock require-pressure-to-show false

# ext: putwindows
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow move-focus-enabled 0
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow move-focus-north-enabled 0
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow move-focus-east-enabled 0
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow move-focus-south-enabled 0
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow move-focus-west-enabled 0
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow move-focus-cycle-enabled 0
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow move-focus-left-screen-enabled 0
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow move-focus-right-screen-enabled 0
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow put-to-corner-ne-enabled 0
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow put-to-corner-nw-enabled 0
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow put-to-corner-se-enabled 0
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow put-to-corner-sw-enabled 0
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow put-to-center-enabled 0
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow put-to-location-enabled 0
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow put-to-right-screen-enabled 0
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow put-to-left-screen-enabled 0
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow put-to-side-w-enabled 1
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow put-to-side-s-enabled 1
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow put-to-side-e-enabled 1
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow put-to-side-n-enabled 1
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow put-to-side-w "['<Alt><Super>Left']"
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow put-to-side-s "['<Alt><Super>Down']"
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow put-to-side-e "['<Alt><Super>Right']"
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas gsettings set org.gnome.shell.extensions.org-lab21-putwindow put-to-side-n "['<Alt><Super>Up']"

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

# deja-dup
gsettings set org.gnome.DejaDup include-list "['\$HOME']"
gsettings set org.gnome.DejaDup exclude-list "['\$TRASH', '\$DOWNLOAD']"
gsettings set org.gnome.DejaDup backend "'file'"
gsettings set org.gnome.DejaDup.File path "'smb://user@tc/tc-disk/Backup/${HOSTNAME}'"
gsettings set org.gnome.DejaDup delete-after 182
gsettings set org.gnome.DejaDup periodic-period 1

# mimetypes
gvfs-mime --set x-scheme-handler/mailto google-chrome.desktop
gvfs-mime --set x-scheme-handler/webcal google-chrome.desktop
gvfs-mime --set text/calendar google-chrome.desktop
