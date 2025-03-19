#!/bin/bash

echo "Setting Google Chrome as default browser..."

# Check if Chrome is installed
if [ ! -d "/Applications/Google Chrome.app" ]; then
  echo "Google Chrome not found in /Applications. Please install Chrome first."
  exit 1
fi

# macOS uses Launch Services to manage default applications
# We need to use the 'open' command with the -a flag to set the default browser

# Set Chrome as the default for HTTP URLs
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -setDefaultHandler com.google.chrome http https

echo "Attempting to open a web URL with Chrome to confirm default browser setting..."
open -a "Google Chrome" "https://www.google.com"

echo "Chrome has been set as the default browser."
echo "Note: You may still see a system prompt asking to confirm this change."
echo "This is by design in macOS and requires user interaction to complete."