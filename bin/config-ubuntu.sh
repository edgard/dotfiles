#!/bin/bash

# ubuntu settings
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ icon-size 32
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/expo/x-offset/ icon-size 48
gsettings set org.gnome.desktop.session idle-delay "uint32 0"
gsettings set com.canonical.Unity.Lenses remote-content-search 'none'
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+intl')]"
gsettings set com.canonical.indicator.keyboard visible false
gsettings set com.canonical.indicator.datetime time-format '12-hour'
gsettings set com.canonical.indicator.datetime show-day true
gsettings set com.canonical.indicator.datetime show-date false
gsettings set com.canonical.indicator.datetime show-auto-detected-location true
gsettings set com.canonical.Unity minimize-count 100
gsettings set org.gnome.settings-daemon.peripherals.mouse motion-threshold 10
gsettings set org.gnome.settings-daemon.peripherals.mouse motion-acceleration 1.0

# unity tweak tools
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-minimize-window true
gsettings set com.canonical.Unity.ApplicationsLens display-available-apps false
gsettings set org.compiz.grid:/org/compiz/profiles/unity/plugins/grid/ top-edge-action 8
gsettings set org.compiz.grid:/org/compiz/profiles/unity/plugins/grid/ bottom-edge-action 2
gsettings set org.compiz.grid:/org/compiz/profiles/unity/plugins/grid/ top-left-corner-action 7
gsettings set org.compiz.grid:/org/compiz/profiles/unity/plugins/grid/ bottom-left-corner-action 1
gsettings set org.compiz.grid:/org/compiz/profiles/unity/plugins/grid/ top-right-corner-action 9
gsettings set org.compiz.grid:/org/compiz/profiles/unity/plugins/grid/ bottom-right-corner-action 3
gsettings set org.gnome.desktop.wm.preferences theme 'Numix'
gsettings set org.gnome.desktop.interface gtk-theme 'Numix'
gsettings set org.gnome.desktop.interface icon-theme 'Numix-Circle'
gsettings set org.compiz.animation:/org/compiz/profiles/unity/plugins/animation/ unminimize-effects "['animation:Zoom']"
gsettings set org.compiz.animation:/org/compiz/profiles/unity/plugins/animation/ minimize-effects "['animation:Zoom']"

# compiz settings manager
gsettings set org.compiz.place:/org/compiz/profiles/unity/plugins/place/ mode 1

# launcher applications
gsettings set com.canonical.Unity.Launcher favorites "['application://google-chrome.desktop', 'application://chrome-hmjkmjkepdijhoojdojkdfohbdgmmhki-Default.desktop', 'application://chrome-ojcflmmmcfpacggndoaaflkmcoblhnbh-Default.desktop', 'application://chrome-mojepfklcankkmikonjlnidiooanmpbb-Default.desktop', 'application://sublime-text.desktop', 'application://gnome-terminal.desktop', 'unity://running-apps', 'application://org.gnome.Nautilus.desktop', 'unity://expo-icon', 'unity://devices', 'unity://desktop-icon']"

# terminal
gsettings set org.gnome.Terminal.Legacy.Settings new-terminal-mode 'tab'
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" use-system-font false
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" font "'PragmataPro 12'"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" login-shell true
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" palette "['rgb(26,26,26)', 'rgb(244,0,95)', 'rgb(152,224,36)', 'rgb(250,132,25)', 'rgb(157,101,255)', 'rgb(244,0,95)', 'rgb(88,209,235)', 'rgb(196,197,181)', 'rgb(98,94,76)', 'rgb(244,0,95)', 'rgb(152,224,36)', 'rgb(224,213,97)', 'rgb(157,101,255)', 'rgb(244,0,95)', 'rgb(88,209,235)', 'rgb(246,246,239)']"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" background-color "'rgb(26,26,26)'"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" foreground-color "'rgb(196,197,181)'"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" bold-color "'rgb(196,197,181)'"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" bold-color-same-as-fg true
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | sed s/^\'// | sed s/\'$//)/" use-theme-colors false

# deja-dup
gsettings set org.gnome.DejaDup include-list "['\$HOME']"
gsettings set org.gnome.DejaDup exclude-list "['\$TRASH', '\$DOWNLOAD']"
gsettings set org.gnome.DejaDup backend "'file'"
gsettings set org.gnome.DejaDup.File path "'smb://user@tc/tc-disk/Backup/${HOSTNAME}'"
gsettings set org.gnome.DejaDup delete-after 182
gsettings set org.gnome.DejaDup periodic-period 1
