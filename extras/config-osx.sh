#!/usr/bin/env bash

###############################################################################
# Initial Setup
###############################################################################

# Close System Settings to prevent overriding changes
osascript -e 'tell application "System Settings" to quit'

###############################################################################
# User-specific Settings
###############################################################################

# Language and Region
defaults write NSGlobalDomain AppleLanguages -array "en-US" "pt-BR"                             # Set user languages priority
defaults write NSGlobalDomain AppleLocale -string "en_PL"                                       # Set user locale to English (Poland)
defaults write NSGlobalDomain AppleICUForce12HourTime -bool true                                # Use 12-hour time format

# General UI/UX
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindow -bool false                               # Don't restore windows when quitting and re-opening apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true                          # Prevent apps from being automatically terminated
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false                     # Save new documents to local disk instead of iCloud by default
defaults write NSGlobalDomain AppleActionOnDoubleClick -string "Fill"                           # Double-click window title bars to maximize/fill
defaults write NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool false                         # Don't minimize windows when double-clicking title bars
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"                                # Use dark appearance

# Text Behavior
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false                   # Disable automatic smart quotes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false                    # Disable automatic smart dashes
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false                  # Disable automatic spelling correction
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false                      # Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false                  # Disable automatic period insertion on double-space

# Save/Print Dialogs
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true                     # Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true                    # Expand save panel by default (newer apps)
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true                        # Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true                       # Expand print panel by default (newer apps)
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true                    # Auto-quit printer app when print jobs complete

###############################################################################
# Input Devices
###############################################################################

# Keyboard
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false                              # Enable key repeat instead of character picker
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true                             # Use F1, F2, etc. keys as standard function keys
# defaults write NSGlobalDomain KeyRepeat -int 2                                                # Set fast keyboard repeat rate
# defaults write NSGlobalDomain InitialKeyRepeat -int 15                                        # Reduce delay before key repeat begins

# Trackpad and Mouse
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true           # Enable tap to click
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1                   # Enable tap to click for current user
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false                        # Use traditional scrolling direction

###############################################################################
# Display and Screen
###############################################################################

# Screenshots
defaults write com.apple.screencapture location -string "${HOME}/Desktop"                       # Save screenshots to Desktop
defaults write com.apple.screencapture type -string "png"                                       # Save screenshots as PNG files
defaults write com.apple.screencapture disable-shadow -bool true                                # Remove window shadow from screenshots

# Font Rendering
defaults write NSGlobalDomain AppleFontSmoothing -int 1                                         # Enable font smoothing (anti-aliasing)
defaults write NSGlobalDomain CGFontRenderingFontSmoothingDisabled -bool false                  # Enable font smoothing in all apps

###############################################################################
# Finder and File Management
###############################################################################

# Desktop Icons
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false                             # Hide internal hard drives on desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true                      # Show external hard drives on desktop
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true                          # Show connected servers on desktop
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true                          # Show removable media on desktop

# Finder Behavior
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"                             # Search the current folder by default
defaults write com.apple.finder NewWindowTarget -string "PfLo"                                  # New Finder windows show home folder
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"                    # Set path for new Finder windows
defaults write com.apple.finder _FXSortFoldersFirst -bool true                                  # Sort folders before files in Finder windows
defaults write com.apple.finder FXInfoPanesExpanded -dict General -bool true Preview -bool true # Show General and Preview panes in Finder info window

# File Operations
defaults write com.apple.finder WarnOnEmptyTrash -bool false                                    # Don't warn before emptying the Trash
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false                      # Don't warn when changing file extensions
defaults write com.apple.finder FXRemoveOldTrashItems -bool true                                # Remove items from Trash after 30 days

# Disk Image Verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true                           # Skip verification of disk images
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true                    # Skip verification of locked disk images
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true                    # Skip verification of remote disk images

###############################################################################
# Dock and Mission Control
###############################################################################

# Dock Appearance and Behavior
defaults write com.apple.dock tilesize -int 24                                                  # Set Dock icon size to 24 pixels
defaults write com.apple.dock mineffect -string "scale"                                         # Use scale effect when minimizing windows
defaults write com.apple.dock minimize-to-application -bool true                                # Minimize windows into their application icon
defaults write com.apple.dock show-recents -bool false                                          # Don't show recent applications in Dock
defaults write com.apple.dock wvous-br-corner -int 14                                           # Set bottom-right hot corner to Quick Note

# Desktop
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false             # Disable click to show desktop
defaults write com.apple.WindowManager GloballyEnabled -bool false                              # Disable Stage Manager
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false                     # Remove margins around tiled windows
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool true                        # Enable window tiling by dragging to screen edges
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool true                 # Enable Option-key window tiling shortcuts
defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool true                     # Enable top-edge drag tiling

# Mission Control
defaults write com.apple.dock "expose-group-apps" -bool true                                    # Group windows by application in Mission Control
defaults write com.apple.dock mru-spaces -bool false                                            # Don't automatically rearrange Spaces based on most recent use

# Apps (formerly Launchpad)
defaults write com.apple.dock springboard-rows -int 7                                           # Set Apps grid rows to 7
defaults write com.apple.dock springboard-columns -int 9                                        # Set Apps grid columns to 9

###############################################################################
# Network and Storage
###############################################################################

# .DS_Store Files
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true                    # Don't create .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true                        # Don't create .DS_Store files on USB volumes

###############################################################################
# Apply Changes
###############################################################################

# Restart affected applications
for app in "Dock" "Finder" "SystemUIServer"; do
    killall "${app}" &>/dev/null
done

echo "User-specific macOS configuration complete. Some changes may require a logout/restart to take effect."
