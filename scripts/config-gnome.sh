#!/bin/bash

# -----------------------------------------------------------------------------
# configuration of gnome desktop
# -----------------------------------------------------------------------------
gsettings set org.gnome.desktop.datetime automatic-timezone true
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+intl')]"
gsettings set org.gnome.desktop.interface clock-format "'12h'"
gsettings set org.gnome.desktop.interface gtk-theme "'Arc'"
gsettings set org.gnome.desktop.interface icon-theme "'Papirus'"
gsettings set org.gnome.desktop.notifications show-in-lock-screen false
gsettings set org.gnome.desktop.peripherals.mouse accel-profile "'flat'"
gsettings set org.gnome.desktop.wm.preferences button-layout "'appmenu:minimize,maximize,close'"
gsettings set org.gnome.desktop.wm.preferences num-workspaces "6"
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.nautilus.preferences executable-text-activation "'launch'"
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type "'suspend'"
gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing "'rgba'"
gsettings set org.gnome.settings-daemon.plugins.xsettings hinting "'slight'"
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'atom.desktop', 'spotify.desktop', 'skypeforlinux.desktop', 'telegramdesktop.desktop', 'chromium.desktop']"
gsettings set org.gnome.shell.extensions.user-theme name "'Arc-Dark'"
gsettings set org.gnome.shell.overrides dynamic-workspaces false
gsettings set org.gnome.system.locale region "'en_US.UTF-8'"
gsettings set org.gnome.system.location enabled true
gsettings set org.gtk.Settings.FileChooser clock-format "'12h'"
gsettings set org.gtk.Settings.FileChooser sort-directories-first true

# shortcuts
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Shift><Super>1']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Shift><Super>2']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Shift><Super>3']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Shift><Super>4']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Shift><Super>5']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 "['<Shift><Super>6']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "['<Control><Shift><Alt>Down']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "['<Control><Shift><Alt>Up']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Control><Alt>Down']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Control><Alt>Up']"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "'<Super>Return'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "'gnome-terminal'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "'Launch Terminal'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "'<Super>slash'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "'chromium'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "'Launch Browser'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding "'<Super>period'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command "'gedit'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name "'Launch Editor'"

# terminal: one-dark
gsettings set org.gnome.Terminal.Legacy.Settings new-terminal-mode "'tab'"
gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" use-system-font false
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" font "'PragmataPro Mono 12'"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" login-shell true
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" allow-bold false
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" bold-color-same-as-fg true
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" use-theme-colors false
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" scrollbar-policy "'never'"

# terminal: one dark
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" palette "['#282c34', '#e06c75', '#98c379', '#e5c07b', '#61afef', '#c678dd', '#56b6c2', '#abb2bf', '#5c6370', '#be5046', '#7a9f60', '#d19a66', '#3b84c0', '#9a52af', '#3c909b', '#828997']"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" background-color "'#282c34'"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" foreground-color "'#abb2bf'"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" bold-color "'#abb2bf'"

# extensions
gsettings set org.gnome.shell enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com', 'alternate-tab@gnome-shell-extensions.gcampax.github.com', 'dash-to-panel@jderose9.github.com', 'openweather-extension@jenslody.de', 'caffeine@patapon.info', 'clipboard-indicator@tudmotu.com', 'nohotcorner@azuri.free.fr', 'TopIcons@phocean.net', 'impatience@gfxmonk.net', 'panel-osd@berend.de.schouwer.gmail.com']"

# ext: dash-to-panel
GSETTINGS_SCHEMA_DIR=/usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas gsettings set org.gnome.shell.extensions.dash-to-panel dot-style-focused "SQUARES"
GSETTINGS_SCHEMA_DIR=/usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas gsettings set org.gnome.shell.extensions.dash-to-panel dot-style-unfocused "SQUARES"
GSETTINGS_SCHEMA_DIR=/usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas gsettings set org.gnome.shell.extensions.dash-to-panel location-clock "'STATUSRIGHT'"
GSETTINGS_SCHEMA_DIR=/usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas gsettings set org.gnome.shell.extensions.dash-to-panel animate-show-apps true
GSETTINGS_SCHEMA_DIR=/usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas gsettings set org.gnome.shell.extensions.dash-to-panel tray-padding "2"
GSETTINGS_SCHEMA_DIR=/usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas gsettings set org.gnome.shell.extensions.dash-to-panel status-icon-padding "8"
GSETTINGS_SCHEMA_DIR=/usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas gsettings set org.gnome.shell.extensions.dash-to-panel appicon-margin "6"
GSETTINGS_SCHEMA_DIR=/usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas gsettings set org.gnome.shell.extensions.dash-to-panel show-showdesktop-button false

# ext: topicons-plus
GSETTINGS_SCHEMA_DIR=/usr/share/gnome-shell/extensions/TopIcons@phocean.net/schemas gsettings set org.gnome.shell.extensions.topicons icon-saturation "0.0"
GSETTINGS_SCHEMA_DIR=/usr/share/gnome-shell/extensions/TopIcons@phocean.net/schemas gsettings set org.gnome.shell.extensions.topicons icon-opacity "255"
GSETTINGS_SCHEMA_DIR=/usr/share/gnome-shell/extensions/TopIcons@phocean.net/schemas gsettings set org.gnome.shell.extensions.topicons icon-size "22"
GSETTINGS_SCHEMA_DIR=/usr/share/gnome-shell/extensions/TopIcons@phocean.net/schemas gsettings set org.gnome.shell.extensions.topicons icon-spacing "14"
GSETTINGS_SCHEMA_DIR=/usr/share/gnome-shell/extensions/TopIcons@phocean.net/schemas gsettings set org.gnome.shell.extensions.topicons tray-order "2"

# ext: openweather
gsettings set org.gnome.shell.extensions.openweather weather-provider "'darksky.net'"
gsettings set org.gnome.shell.extensions.openweather geolocation-provider "'geocode'"
gsettings set org.gnome.shell.extensions.openweather unit "'celsius'"
gsettings set org.gnome.shell.extensions.openweather wind-speed-unit "'kph'"
gsettings set org.gnome.shell.extensions.openweather pressure-unit "'hPa'"
gsettings set org.gnome.shell.extensions.openweather center-forecast true
gsettings set org.gnome.shell.extensions.openweather decimal-places "0"
gsettings set org.gnome.shell.extensions.openweather show-text-in-panel false

# ext: clipboard indicator
GSETTINGS_SCHEMA_DIR=/usr/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com/schemas gsettings set org.gnome.shell.extensions.clipboard-indicator notify-on-copy false
GSETTINGS_SCHEMA_DIR=/usr/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com/schemas gsettings set org.gnome.shell.extensions.clipboard-indicator enable-keybindings false

# ext: caffeine
gsettings set org.gnome.shell.extensions.caffeine show-notifications false

# ext: panel-osd
gsettings set org.gnome.shell.extensions.panel-osd x-pos 100.0
gsettings set org.gnome.shell.extensions.panel-osd y-pos 0.0
