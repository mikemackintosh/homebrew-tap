#!/bin/bash

echo "Setting Google Chrome as default browser..."

# Check if Chrome is installed
if [ ! -d "/Applications/Google Chrome.app" ]; then
  echo "Google Chrome not found in /Applications. Please install Chrome first."
  exit 1
fi

# Get the bundle identifier for Chrome
BROWSER_BUNDLE_ID="com.google.chrome"
loggedInUser=$(stat -f%Su /dev/console)
loggedInUserHome=$(dscl . -read "/Users/${loggedInUser}" NFSHomeDirectory | awk '{print $NF}')
launchServicesPlistFolder="${loggedInUserHome}/Library/Preferences/com.apple.LaunchServices"
launchServicesPlist="${launchServicesPlistFolder}/com.apple.launchservices.secure.plist"
plistbuddyPath="/usr/libexec/PlistBuddy"
lsregisterPath="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"

# Clear out LSHandlers array data from LaunchServices plist, or create new plist if file does not exist
if [ -e "$launchServicesPlist" ]; then
  "$plistbuddyPath" -c "Delete :LSHandlers" "$launchServicesPlist"
else
  mkdir -p "$launchServicesPlistFolder"
  "$plistbuddyPath" -c "Save" "$launchServicesPlist"
fi

# Add new LSHandlers array
"$plistbuddyPath" -c "Add :LSHandlers array" "$launchServicesPlist"

# Set handler for each URL scheme and content type to Chrome
"$plistbuddyPath" -c "Add :LSHandlers:0:LSHandlerRoleAll string ${BROWSER_BUNDLE_ID}" "$launchServicesPlist"
"$plistbuddyPath" -c "Add :LSHandlers:0:LSHandlerURLScheme string http" "$launchServicesPlist"
"$plistbuddyPath" -c "Add :LSHandlers:1:LSHandlerRoleAll string ${BROWSER_BUNDLE_ID}" "$launchServicesPlist"
"$plistbuddyPath" -c "Add :LSHandlers:1:LSHandlerURLScheme string https" "$launchServicesPlist"
"$plistbuddyPath" -c "Add :LSHandlers:2:LSHandlerRoleViewer string ${BROWSER_BUNDLE_ID}" "$launchServicesPlist"
"$plistbuddyPath" -c "Add :LSHandlers:2:LSHandlerContentType string public.html" "$launchServicesPlist"
"$plistbuddyPath" -c "Add :LSHandlers:3:LSHandlerRoleViewer string ${BROWSER_BUNDLE_ID}" "$launchServicesPlist"
"$plistbuddyPath" -c "Add :LSHandlers:3:LSHandlerContentType string public.url" "$launchServicesPlist"
"$plistbuddyPath" -c "Add :LSHandlers:4:LSHandlerRoleViewer string ${BROWSER_BUNDLE_ID}" "$launchServicesPlist"
"$plistbuddyPath" -c "Add :LSHandlers:4:LSHandlerContentType string public.xhtml" "$launchServicesPlist"

# Fix ownership on logged-in user's LaunchServices plist folder
chown -R "$loggedInUser" "$launchServicesPlistFolder"

# Reset Launch Services database
"$lsregisterPath" -kill -r -domain local -domain system -domain user

echo "Attempting to open a web URL with Chrome to confirm default browser setting..."
open -a "Google Chrome" "https://www.google.com"

echo "Chrome has been set as the default browser."
echo "Note: You may still see a system prompt asking to confirm this change."
echo "This is by design in macOS and requires user interaction to complete."