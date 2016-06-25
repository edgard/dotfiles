#!/bin/bash

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

# Disable the 'Are you sure you want to open this application?' dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Enable custom languages
defaults write NSGlobalDomain AppleLanguages -array "en" "pt-BR"

# Disable reopening of windows during login
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false


###############################################################################
# General Power and Performance modifications
###############################################################################

# Speeding up wake from sleep to 24 hours from an hour
sudo pmset -a standbydelay 86400

# Disable open and close window animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -boolean false

# Disable focus ring animation
defaults write NSGlobalDomain NSUseAnimatedFocusRing -boolean false

# Reduce transparency in OS X
defaults write com.apple.universalaccess reduceTransparency -boolean true


################################################################################
# Trackpad, mouse, keyboard
###############################################################################

# Disabling press-and-hold for special keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Use fn-keys as stantard function key
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

# Turn off keyboard illumination when computer is not used for 5 minutes
defaults write com.apple.BezelServices kDimTime -int 300


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
defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Disable auto-adjust brightness
#sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor.plist "Automatic Display Enabled" -bool false


###############################################################################
# Finder
###############################################################################

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Default file windows opens at user homedir
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false


###############################################################################
# Dock & Mission Control
###############################################################################

# Wipe all (default) app icons from the Dock
# defaults write com.apple.dock persistent-apps -array

# Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate
defaults write com.apple.dock tilesize -int 36

# Speeding up Mission Control animations and grouping windows by application
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock "expose-group-by-app" -bool true

# Set Dock to auto-hide and remove the auto-hiding delay
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15

# Set application minimize/maximize effects to scale
defaults write com.apple.dock mineffect -string scale

# Minimize windows into application icon
defaults write com.apple.dock minimize-to-application -bool true

# Do not rearrange spaces on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Disable launchpad gesture
defaults write com.apple.dock showLaunchpadGestureEnabled -bool false


###############################################################################
# Time Machine
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


###############################################################################
# Chrome
###############################################################################

# Using the system-native print preview dialog in Chrome
defaults write com.google.Chrome DisablePrintPreview -bool true


###############################################################################
# Brew
###############################################################################

echo "Would you like to install brew and apps? (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  # Install brew and cask
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew tap caskroom/cask
  
  # Install applications
  brew install android-platform-tools
  brew install ansible
  brew install aria2
  brew install asciinema
  brew install autojump
  brew install bash-completion
  brew install go
  brew install node
  brew install gpg
  brew install mercurial
  brew install ssh-copy-id
  brew install the_silver_searcher
  
  brew cask install android-file-transfer
  brew cask install appcleaner
  brew cask install caffeine
  brew cask install calibre
  brew cask install darktable
  brew cask install dropbox
  brew cask install flux
  brew cask install gimp
  brew cask install google-chrome
  brew cask install java
  brew cask install spectacle
  brew cask install spotify
  brew cask install telegram-desktop
  brew cask install the-unarchiver
  brew cask install transmission
  brew cask install virtualbox  
  brew cask install visual-studio-code  
  brew cask install vlc
fi
