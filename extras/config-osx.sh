#!/usr/bin/env bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we're about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront and run a keep-alive to update
# existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX
###############################################################################

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Save to disk, rather than iCloud by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Disable smart quotes and smart dashes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable autocorrect
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable capitalize words
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable period on double space
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable the 'Are you sure you want to open this application?' dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Set language and text formats
defaults write NSGlobalDomain AppleLanguages -array "en-US" "pt-BR"
defaults write NSGlobalDomain AppleLocale -string "en_PL"

# Disable reopening of windows during login
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false

# Disable Resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

###############################################################################
# General Power and Performance modifications
###############################################################################

# Enable lid wakeup
sudo pmset -a lidwake 1

# Restart automatically on power loss
sudo pmset -a autorestart 1

# Sleep the display after 15 minutes while charging
sudo pmset -c displaysleep 15

# Sleep the display after 5 minutes on battery
sudo pmset -b displaysleep 5

# Disable machine sleep while charging
sudo pmset -c sleep 0

# Set machine sleep to 5 minutes on battery
sudo pmset -b sleep 5

# Set standby delay to 24 hours (default is 1 hour)
sudo pmset -a standbydelay 86400

# Disable open and close window animations
#defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -boolean false

# Disable focus ring animation
#defaults write NSGlobalDomain NSUseAnimatedFocusRing -boolean false

# Reduce transparency in OS X
#defaults write com.apple.universalaccess reduceTransparency -boolean true

################################################################################
# Trackpad, mouse, keyboard
###############################################################################

# Disabling press-and-hold for special keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Use fn-keys as standard function key
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# Enable trackpad tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable natural (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Trackpad gesture configurations
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -bool false

# Turn off keyboard illumination when computer is not used for 5 seconds
defaults write com.apple.BezelServices kDimTime -int 5

# Speed up key repeat
defaults write com.apple.Accessibility KeyRepeatDelay -float 0.5
defaults write com.apple.Accessibility KeyRepeatInterval -float 0.083333333

###############################################################################
# Screen
###############################################################################

# Requiring password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Set screenshot location to ~/Desktop as default
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Setting screenshot format to PNG
defaults write com.apple.screencapture type -string "png"

# Disable shadows in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Enabling subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 1

# Re-enable subpixel fond rendering
defaults write NSGlobalDomain CGFontRenderingFontSmoothingDisabled -bool false

# Disable auto-adjust brightness
# sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor.plist "Automatic Display Enabled" -bool false

###############################################################################
# Finder
###############################################################################

# Icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Default file windows opens at user homedir
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Sort Folders First
defaults write com.apple.finder _FXSortFoldersFirst -bool Yes

# Expand Save Panel by Default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

###############################################################################
# Dock & Mission Control
###############################################################################

# Wipe all (default) app icons from the Dock
# defaults write com.apple.dock persistent-apps -array

# Setting the icon size of Dock items to 24 pixels for optimal size/screen-realestate
defaults write com.apple.dock tilesize -int 24

# Speeding up Mission Control animations and grouping windows by application
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock "expose-group-apps" -bool true

# Set Dock to auto-hide and remove the auto-hiding delay
# defaults write com.apple.dock autohide -bool true
# defaults write com.apple.dock autohide-delay -float 0
# defaults write com.apple.dock autohide-time-modifier -float 0.15

# Set application minimize/maximize effects to scale
defaults write com.apple.dock mineffect -string scale

# Minimize windows into application icon
defaults write com.apple.dock minimize-to-application -bool true

# Do not rearrange spaces on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Disable launchpad gesture
defaults write com.apple.dock showLaunchpadGestureEnabled -bool false

# Disable dashboard
defaults write com.apple.dashboard dashboard-enabled-state -int 1

###############################################################################
# Time Machine
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
# Misc
###############################################################################

# Turn on local firewall
# sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

# Disable Creation of Metadata Files on Network Volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable Creation of Metadata Files on USB Volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

###############################################################################
# Chrome
###############################################################################

# Using the system-native print preview dialog in Chrome
defaults write com.google.Chrome DisablePrintPreview -bool true

###############################################################################
# Safari
###############################################################################

# Enable Develop menu
defaults write com.apple.Safari IncludeDevelopMenu -int 1

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Show Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool true

# Show Safari's status bar by default
defaults write com.apple.Safari ShowOverlayStatusBar -bool true

# AutoFill
defaults write com.apple.Safari AutoFillFromAddressBook -bool true
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool true

# Enable “Do Not Track”
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# Update extensions automatically
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

# Make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

###############################################################################
# TextEdit
###############################################################################

# Use Plain Text Mode as Default
defaults write com.apple.TextEdit RichText -int 0

# Open new document instead of file dialog by Default
defaults write com.apple.TextEdit NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false

# Disable auto spelling
defaults write /Users/"${USER}"/Library/Containers/com.apple.TextEdit/Data/Library/Preferences/com.apple.TextEdit.plist CheckSpellingWhileTyping -bool false

###############################################################################
# Brew
###############################################################################

echo "Would you like to install brew and apps? (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew bundle
fi
