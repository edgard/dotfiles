#!/usr/bin/env bash

###############################################################################
# Initial Setup
###############################################################################

# Close System Settings to prevent overriding changes
osascript -e 'tell application "System Settings" to quit'

# Ask for admin password upfront and keep sudo timestamp alive
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# System-wide Settings
###############################################################################

# Language and Region
defaults write NSGlobalDomain AppleLanguages -array "en-US" "pt-BR"  # Set system languages priority
defaults write NSGlobalDomain AppleLocale -string "en_PL"  # Set system locale to English (Poland)

# General UI/UX
defaults write com.apple.LaunchServices LSQuarantine -bool false  # Disable "app downloaded from the internet" warning dialog
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false  # Don't reopen apps when logging back in
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindow -bool false  # Don't restore windows when quitting and re-opening apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true  # Prevent apps from being automatically terminated
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false  # Save new documents to local disk instead of iCloud by default

# Text Behavior
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false  # Disable automatic smart quotes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false  # Disable automatic smart dashes
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false  # Disable automatic spelling correction
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false  # Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false  # Disable automatic period insertion on double-space

# Save/Print Dialogs
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true  # Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true  # Expand save panel by default (newer apps)
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true  # Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true  # Expand print panel by default (newer apps)
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true  # Auto-quit printer app when print jobs complete

# Updates
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1  # Check for software updates daily

# Time Machine
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true  # Don't prompt to use new hard drives for Time Machine
defaults write com.apple.TimeMachine AutoBackup -bool true  # Enable automatic Time Machine backups
defaults write com.apple.TimeMachine ExcludeByPath -array "${HOME}/Downloads"  # Exclude Downloads folder from Time Machine backups
defaults write com.apple.TimeMachine RequiresACPower -bool true  # Only perform Time Machine backups when connected to power

###############################################################################
# Security and Privacy
###############################################################################

# Screen Lock
defaults write com.apple.screensaver askForPassword -int 1  # Require password after screensaver or sleep
defaults write com.apple.screensaver askForPasswordDelay -int 0  # Require password immediately after screensaver starts

###############################################################################
# Input Devices
###############################################################################

# Keyboard
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false  # Enable key repeat instead of character picker
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true  # Use F1, F2, etc. keys as standard function keys
defaults write NSGlobalDomain KeyRepeat -int 2  # Set fast keyboard repeat rate
defaults write NSGlobalDomain InitialKeyRepeat -int 15  # Reduce delay before key repeat begins

# Trackpad and Mouse
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true  # Enable tap to click
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1  # Enable tap to click for current user
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1  # Enable tap to click for login screen
defaults write NSGlobalDomain swipescrolldirection -bool false  # Use traditional scrolling direction

###############################################################################
# Display and Screen
###############################################################################

# Screenshots
defaults write com.apple.screencapture location -string "${HOME}/Desktop"  # Save screenshots to Desktop
defaults write com.apple.screencapture type -string "png"  # Save screenshots as PNG files
defaults write com.apple.screencapture disable-shadow -bool true  # Remove window shadow from screenshots

# Font Rendering
defaults write NSGlobalDomain AppleFontSmoothing -int 1  # Enable font smoothing (anti-aliasing)
defaults write NSGlobalDomain CGFontRenderingFontSmoothingDisabled -bool false  # Enable font smoothing in all apps

# Night Shift
defaults write com.apple.CoreBrightness CBBlueReductionStatus -dict AutoBlueReductionEnabled 0  # Disable automatic Night Shift

###############################################################################
# Finder and File Management
###############################################################################

# Desktop Icons
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false  # Hide internal hard drives on desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true  # Show external hard drives on desktop
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true  # Show connected servers on desktop
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true  # Show removable media on desktop

# Finder Behavior
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"  # Search the current folder by default
defaults write com.apple.finder NewWindowTarget -string "PfLo"  # New Finder windows show home folder
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"  # Set path for new Finder windows
defaults write com.apple.finder _FXSortFoldersFirst -bool true  # Sort folders before files in Finder windows
defaults write com.apple.finder FXInfoPanesExpanded -dict General -bool true Preview -bool true  # Show General and Preview panes in Finder info window

# File Operations
defaults write com.apple.finder WarnOnEmptyTrash -bool false  # Don't warn before emptying the Trash
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false  # Don't warn when changing file extensions

# Disk Image Verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true  # Skip verification of disk images
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true  # Skip verification of locked disk images
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true  # Skip verification of remote disk images

###############################################################################
# Dock and Mission Control
###############################################################################

# Dock Appearance and Behavior
defaults write com.apple.dock tilesize -int 24  # Set Dock icon size to 24 pixels
defaults write com.apple.dock mineffect -string "scale"  # Use scale effect when minimizing windows
defaults write com.apple.dock minimize-to-application -bool true  # Minimize windows into their application icon

# Mission Control
defaults write com.apple.dock expose-animation-duration -float 0.1  # Speed up Mission Control animations
defaults write com.apple.dock "expose-group-apps" -bool true  # Group windows by application in Mission Control
defaults write com.apple.dock mru-spaces -bool false  # Don't automatically rearrange Spaces based on most recent use
defaults write com.apple.dock showLaunchpadGestureEnabled -bool false  # Disable trackpad gesture for showing Launchpad

###############################################################################
# Network and Storage
###############################################################################

# .DS_Store Files
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true  # Don't create .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true  # Don't create .DS_Store files on USB volumes

###############################################################################
# Power and Performance
###############################################################################

# Power Management - AC Power
sudo pmset -c displaysleep 15  # Turn display off after 15 minutes when on power
sudo pmset -c sleep 0  # Never put computer to sleep when on power

# Power Management - Battery
sudo pmset -b displaysleep 5  # Turn display off after 5 minutes when on battery
sudo pmset -b sleep 5  # Put computer to sleep after 5 minutes when on battery

# Power Management - General
sudo pmset -a lidwake 1  # Wake when opening laptop lid
sudo pmset -a autorestart 1  # Automatically restart on power loss
sudo pmset -a standbydelay 86400  # Wait 24 hours before entering standby mode
sudo pmset -a powernap 0  # Disable Power Nap (background tasks during sleep)
sudo pmset -a proximitywake 0  # Disable wake when iPhone/Apple Watch is nearby

###############################################################################
# Sandboxed Applications
###############################################################################

# Function to set preferences for sandboxed apps
set_sandboxed_pref() {
    local app_id="$1"
    local key="$2"
    local type="$3"
    local value="$4"

    # Check if the container directory exists
    local container_path="/Users/${USER}/Library/Containers/${app_id}/Data/Library/Preferences"
    if [ -d "$container_path" ]; then
        defaults write "${app_id}" "$key" "$type" "$value"
    else
        echo "Warning: Container for ${app_id} not found. Setting may not apply."
        # Try writing directly to the app's preference domain anyway
        defaults write "${app_id}" "$key" "$type" "$value"
    fi
}

# TextEdit
defaults write com.apple.TextEdit RichText -bool false || set_sandboxed_pref "com.apple.TextEdit" "RichText" "-bool" "false"
defaults write com.apple.TextEdit NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false || set_sandboxed_pref "com.apple.TextEdit" "NSShowAppCentricOpenPanelInsteadOfUntitledFile" "-bool" "false"
defaults write com.apple.TextEdit SmartSubstitutions -bool false || set_sandboxed_pref "com.apple.TextEdit" "SmartSubstitutions" "-bool" "false"
defaults write com.apple.TextEdit SmartDashes -bool false || set_sandboxed_pref "com.apple.TextEdit" "SmartDashes" "-bool" "false"
defaults write com.apple.TextEdit SmartQuotes -bool false || set_sandboxed_pref "com.apple.TextEdit" "SmartQuotes" "-bool" "false"
defaults write com.apple.TextEdit CheckSpellingWhileTyping -bool false || set_sandboxed_pref "com.apple.TextEdit" "CheckSpellingWhileTyping" "-bool" "false"

# Safari
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true || set_sandboxed_pref "com.apple.Safari" "ShowFullURLInSmartSearchField" "-bool" "true"
defaults write com.apple.Safari HomePage -string "about:blank" || set_sandboxed_pref "com.apple.Safari" "HomePage" "-string" "about:blank"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false || set_sandboxed_pref "com.apple.Safari" "AutoOpenSafeDownloads" "-bool" "false"
defaults write com.apple.Safari ShowFavoritesBar -bool true || set_sandboxed_pref "com.apple.Safari" "ShowFavoritesBar" "-bool" "true"
defaults write com.apple.Safari ShowOverlayStatusBar -bool true || set_sandboxed_pref "com.apple.Safari" "ShowOverlayStatusBar" "-bool" "true"
defaults write com.apple.Safari AutoFillFromAddressBook -bool true || set_sandboxed_pref "com.apple.Safari" "AutoFillFromAddressBook" "-bool" "true"
defaults write com.apple.Safari AutoFillPasswords -bool false || set_sandboxed_pref "com.apple.Safari" "AutoFillPasswords" "-bool" "false"
defaults write com.apple.Safari AutoFillCreditCardData -bool false || set_sandboxed_pref "com.apple.Safari" "AutoFillCreditCardData" "-bool" "false"
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool true || set_sandboxed_pref "com.apple.Safari" "AutoFillMiscellaneousForms" "-bool" "true"
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true || set_sandboxed_pref "com.apple.Safari" "InstallExtensionUpdatesAutomatically" "-bool" "true"

# Chrome
defaults write com.google.Chrome DisablePrintPreview -bool true || set_sandboxed_pref "com.google.Chrome" "DisablePrintPreview" "-bool" "true"
defaults write com.google.Chrome PasswordManagerEnabled -bool false || set_sandboxed_pref "com.google.Chrome" "PasswordManagerEnabled" "-bool" "false"

###############################################################################
# Apply Changes
###############################################################################

# Restart affected applications
for app in "Dock" "Finder" "Safari" "TextEdit" "Chrome" "SystemUIServer"; do
    killall "${app}" &> /dev/null
done

echo "macOS configuration complete. Some changes may require a logout/restart to take effect."
