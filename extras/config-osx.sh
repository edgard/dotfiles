#!/usr/bin/env bash

# Close System Settings to prevent overriding changes
osascript -e 'tell application "System Settings" to quit'

# Ask for admin password upfront and keep sudo timestamp alive
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX
###############################################################################

defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true  # Auto-quit printer app
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false  # Save to disk by default
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1  # Daily software updates
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false  # Disable smart quotes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false  # Disable smart dashes
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false  # Disable autocorrect
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false  # Disable capitalize words
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false  # Disable period on double space
defaults write com.apple.LaunchServices LSQuarantine -bool false  # Disable app open confirmation dialog
defaults write NSGlobalDomain AppleLanguages -array "en-US" "pt-BR"  # Set languages
defaults write NSGlobalDomain AppleLocale -string "en_PL"  # Set locale
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false  # Disable window reopening at login
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false  # Disable Resume system-wide
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true  # Disable auto app termination

###############################################################################
# Power and Performance
###############################################################################

sudo pmset -a lidwake 1  # Enable lid wakeup
sudo pmset -a autorestart 1  # Restart on power loss
sudo pmset -c displaysleep 15  # Display sleep after 15 min while charging
sudo pmset -b displaysleep 5  # Display sleep after 5 min on battery
sudo pmset -c sleep 0  # Disable sleep while charging
sudo pmset -b sleep 5  # Sleep after 5 min on battery
sudo pmset -a standbydelay 86400  # 24 hour standby delay

###############################################################################
# Trackpad, mouse, keyboard
###############################################################################

defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false  # Disable press-and-hold for keys
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true  # Use fn-keys as standard function keys
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true  # Enable tap to click
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false  # Disable natural scrolling
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -bool false  # Disable three finger tap
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -bool false  # Disable two finger double tap
defaults write com.apple.BezelServices kDimTime -int 5  # Keyboard backlight off after 5 sec
defaults write NSGlobalDomain KeyRepeat -int 2  # Fast key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15  # Short delay until repeat

###############################################################################
# Screen
###############################################################################

defaults write com.apple.screensaver askForPassword -int 1  # Require password after sleep/screensaver
defaults write com.apple.screensaver askForPasswordDelay -int 0  # No delay for password prompt
defaults write com.apple.screencapture location -string "${HOME}/Desktop"  # Screenshots to Desktop
defaults write com.apple.screencapture type -string "png"  # PNG format for screenshots
defaults write com.apple.screencapture disable-shadow -bool true  # No shadows in screenshots
defaults write NSGlobalDomain AppleFontSmoothing -int 1  # Enable subpixel font rendering
defaults write NSGlobalDomain CGFontRenderingFontSmoothingDisabled -bool false  # Re-enable font smoothing

###############################################################################
# Finder
###############################################################################

# Desktop icons
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"  # Search current folder by default
defaults write com.apple.finder NewWindowTarget -string "PfLo"  # New windows open to home
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"
defaults write com.apple.finder WarnOnEmptyTrash -bool false  # No warning before emptying trash
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false  # No warning when changing extension
defaults write com.apple.finder _FXSortFoldersFirst -bool true  # Sort folders first
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true  # Expanded save panel
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true  # Expanded print panel
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

###############################################################################
# Dock & Mission Control
###############################################################################

defaults write com.apple.dock tilesize -int 24  # Smaller dock icons
defaults write com.apple.dock expose-animation-duration -float 0.1  # Faster Mission Control
defaults write com.apple.dock "expose-group-by-app" -bool true  # Group windows by app
defaults write com.apple.dock mineffect -string scale  # Scale minimize effect
defaults write com.apple.dock minimize-to-application -bool true  # Minimize to app icon
defaults write com.apple.dock mru-spaces -bool false  # Don't rearrange spaces
defaults write com.apple.dock showLaunchpadGestureEnabled -bool false  # Disable launchpad gesture

###############################################################################
# Time Machine
###############################################################################

defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true  # Don't prompt for new backup disks

###############################################################################
# Misc
###############################################################################

defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true  # No .DS_Store on network
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true  # No .DS_Store on USB

###############################################################################
# Chrome
###############################################################################

defaults write com.google.Chrome DisablePrintPreview -bool true  # Use system print dialog

###############################################################################
# Safari
###############################################################################

defaults write com.apple.Safari IncludeDevelopMenu -int 1  # Enable Develop menu
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true  # Show full URL
defaults write com.apple.Safari HomePage -string "about:blank"  # Blank homepage
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false  # Don't auto-open downloads
defaults write com.apple.Safari ShowFavoritesBar -bool true  # Show bookmarks bar
defaults write com.apple.Safari ShowOverlayStatusBar -bool true  # Show status bar

# AutoFill settings
defaults write com.apple.Safari AutoFillFromAddressBook -bool true
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool true

defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true  # Enable Do Not Track
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true  # Auto-update extensions
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false  # Search contains vs starts with

###############################################################################
# TextEdit
###############################################################################

defaults write com.apple.TextEdit RichText -int 0  # Plain text mode
defaults write com.apple.TextEdit NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false  # New document by default
defaults write /Users/"${USER}"/Library/Containers/com.apple.TextEdit/Data/Library/Preferences/com.apple.TextEdit.plist CheckSpellingWhileTyping -bool false  # Disable spell check

# Restart affected applications
for app in "Dock" "Finder" "Safari" "SystemUIServer"; do
    killall "${app}" &> /dev/null
done

echo "macOS configuration complete. Some changes may require a logout/restart to take effect."
