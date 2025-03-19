#!/bin/bash

echo "Configuring trackpad settings..."

# Point & Click settings (Screenshot 1)
echo "Setting Point & Click preferences..."

# Tracking speed (set to roughly middle-high based on screenshot)
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 0.875

# Force Click and haptic feedback - Enabled
defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool false
defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -bool true

# Tap to click - Enabled
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Secondary click - "Click or Tap with Two Fingers"
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 0

# Look up & data detectors - "Tap with Three Fingers"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 2

# Scroll & Zoom settings (Screenshot 2)
echo "Setting Scroll & Zoom preferences..."

# Natural scrolling - Disabled (turned off in the screenshot)
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Zoom in or out - Enabled
defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -bool true

# Smart zoom - Disabled
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -int 0

# Rotate - Enabled
defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -bool true

# More Gestures settings (Screenshot 3)
echo "Setting More Gestures preferences..."

# Swipe between pages - "Scroll Left or Right with Two Fingers"
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0

# Swipe between full-screen applications - "Swipe Left or Right with Three Fingers"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 2

# Notification Center - Enabled
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3

# Mission Control - "Swipe Up with Three Fingers"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 2

# App Exposé - Off
defaults write com.apple.dock showAppExposeGestureEnabled -bool false

# Launchpad - Enabled
defaults write com.apple.dock showLaunchpadGestureEnabled -bool true

# Show Desktop - Enabled
defaults write com.apple.dock showDesktopGestureEnabled -bool true

echo "Trackpad settings applied to match screenshots."