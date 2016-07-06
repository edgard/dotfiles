#!/bin/bash

# install gnome-extensions
GNOME_VERSION=$(gnome-shell --version | awk '{split($3,a,"."); print a[1]"."a[2];}')
./shell-extension-install "${GNOME_VERSION}" 517    # caffeine
./shell-extension-install "${GNOME_VERSION}" 307    # dash-to-dock
./shell-extension-install "${GNOME_VERSION}" 1005   # focus my window
./shell-extension-install "${GNOME_VERSION}" 277    # impatience
./shell-extension-install "${GNOME_VERSION}" 495    # topicons
gsettings set org.gnome.shell enabled-extensions "['caffeine@patapon.info', 'dash-to-dock@micxgx.gmail.com', 'focus-my-window@varianto25.com', 'impatience@gfxmonk.net', 'topIcons@adel.gadllah@gmail.com']"

# gnome-shell
gsettings set org.gnome.desktop.datetime automatic-timezone true
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+intl')]"
gsettings set org.gnome.desktop.interface clock-format "'12h'"
gsettings set org.gtk.Settings.FileChooser clock-format "'12h'"
gsettings set org.gnome.desktop.interface icon-theme "'Numix-Circle'"
gsettings set org.gnome.desktop.peripherals.mouse speed -1.0
gsettings set org.gnome.desktop.wm.preferences button-layout "'appmenu:minimize,maximize,close'"
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type "'suspend'"
gsettings set org.gnome.shell.overrides dynamic-workspaces false
gsettings set org.gnome.system.locale region "'en_US.UTF-8'"
gsettings set org.gnome.system.location enabled true
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'gnome-terminal.desktop', 'code.desktop', 'chrome-hmjkmjkepdijhoojdojkdfohbdgmmhki-Default.desktop', 'thunderbird.desktop', 'telegram.desktop', 'google-chrome.desktop']"

# ext: caffeine
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/caffeine@patapon.info/schemas gsettings set org.gnome.shell.extensions.caffeine show-notifications false

# ext: dash-to-dock
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas gsettings set org.gnome.shell.extensions.dash-to-dock preferred-monitor 0
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas gsettings set org.gnome.shell.extensions.dash-to-dock dock-position "'BOTTOM'"
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas gsettings set org.gnome.shell.extensions.dash-to-dock apply-custom-theme true

# terminal (one-dark)
gsettings set org.gnome.Terminal.Legacy.Settings new-terminal-mode "'tab'"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" use-system-font false
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" font "''PragmataPro Mono 12''"
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

# thunderbird
gvfs-mime --set text/calendar thunderbird.desktop
