#!/bin/bash

echo "Resetting macOS settings to defaults..."

# Reset dock to defaults
defaults delete com.apple.dock
killall Dock

# Reset trackpad Point & Click settings
defaults delete NSGlobalDomain com.apple.trackpad.scaling
defaults delete com.apple.AppleMultitouchTrackpad ForceSuppressed
defaults delete com.apple.AppleMultitouchTrackpad ActuateDetents
defaults delete com.apple.AppleMultitouchTrackpad Clicking
defaults delete com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking
defaults delete NSGlobalDomain com.apple.mouse.tapBehavior
defaults -currentHost delete NSGlobalDomain com.apple.mouse.tapBehavior
defaults delete com.apple.AppleMultitouchTrackpad TrackpadRightClick
defaults delete com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick
defaults delete com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick
defaults delete com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick
defaults delete com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture
defaults delete com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture

# Reset trackpad Scroll & Zoom settings
defaults delete NSGlobalDomain com.apple.swipescrolldirection
defaults delete com.apple.AppleMultitouchTrackpad TrackpadPinch
defaults delete com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch
defaults delete com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture
defaults delete com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture
defaults delete com.apple.AppleMultitouchTrackpad TrackpadRotate
defaults delete com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate

# Reset trackpad More Gestures settings
defaults delete NSGlobalDomain AppleEnableSwipeNavigateWithScrolls
defaults delete com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture
defaults delete com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture
defaults delete com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture
defaults delete com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture
defaults delete com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture
defaults delete com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture
defaults delete com.apple.dock showAppExposeGestureEnabled
defaults delete com.apple.dock showLaunchpadGestureEnabled
defaults delete com.apple.dock showDesktopGestureEnabled

# Reset screenshot settings
defaults delete com.apple.screencapture location
defaults delete com.apple.screencapture type
defaults delete com.apple.screencapture disable-shadow
defaults delete com.apple.screencapture include-date
killall SystemUIServer

# Reset default browser (back to Safari)
if [ -d "/Applications/Safari.app" ]; then
  echo "Resetting default browser to Safari..."
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -setDefaultHandler com.apple.safari http https
fi

echo "All macOS settings have been reset to defaults."