#!/bin/bash

echo "Configuring screenshot settings..."

# Gets the current user's home directory
USER_HOME=$(eval echo ~$USER)

# Create a Screenshots directory if it doesn't exist
if [ ! -d "$USER_HOME/Pictures/Screenshots" ]; then
  echo "Creating Screenshots directory in Pictures folder..."
  mkdir -p "$USER_HOME/Pictures/Screenshots"
fi

# Set the default location for screenshots
echo "Setting default screenshot location to ~/Pictures/Screenshots..."
defaults write com.apple.screencapture location "$USER_HOME/Pictures/Screenshots"

# Set screenshot format (options: png, jpg, tiff, pdf, bmp)
echo "Setting screenshot format to png..."
defaults write com.apple.screencapture type -string "png"

# Disable screenshot shadow
echo "Disabling screenshot shadow..."
defaults write com.apple.screencapture disable-shadow -bool true

# Include date in screenshot filename
echo "Including date in screenshot filename..."
defaults write com.apple.screencapture include-date -bool true

# Apply changes
echo "Applying changes..."
killall SystemUIServer

echo "Screenshot settings applied."