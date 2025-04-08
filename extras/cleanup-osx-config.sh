#!/usr/bin/env bash

# Cleanup script to delete old options that were removed or renamed
# This script focuses only on reverting the specific old options to defaults

# Close System Settings to prevent overriding changes
osascript -e 'tell application "System Settings" to quit'

# Ask for admin password upfront and keep sudo timestamp alive
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Deleting old options that were removed or renamed..."

###############################################################################
# Delete removed options (old options that no longer exist in new config)
###############################################################################

# Delete removed trackpad options
defaults delete com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture
defaults delete com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture
defaults delete com.apple.BezelServices kDimTime

# Delete removed Safari options
defaults delete com.apple.Safari IncludeDevelopMenu
defaults delete com.apple.Safari SendDoNotTrackHTTPHeader
defaults delete com.apple.Safari FindOnPageMatchesWordStartsOnly

###############################################################################
# Delete old option names (options that were renamed in new config)
###############################################################################

# Delete old Mission Control window grouping
defaults delete com.apple.dock "expose-group-by-app"
# New config uses: com.apple.dock "expose-group-apps"

# Delete old TextEdit RichText setting format
# Old config used: RichText -int 0
# New config uses: RichText -bool false
# No action needed as they use the same key name

# Delete old NSQuitAlwaysKeepsWindows (with 's')
defaults delete NSGlobalDomain NSQuitAlwaysKeepsWindows
# New config uses: NSGlobalDomain NSQuitAlwaysKeepsWindow (without 's')

# Restart affected applications
for app in "Dock" "Finder" "Safari" "SystemUIServer" "TextEdit"; do
    killall "${app}" &> /dev/null
done

echo "Cleanup complete. Old options have been deleted and reverted to defaults."
echo "Some changes may require a logout/restart to take effect."
