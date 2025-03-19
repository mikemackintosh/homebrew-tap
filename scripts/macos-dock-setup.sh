#!/bin/bash

echo "Configuring Dock..."

# Creates a temporary plist file to work with
defaults export com.apple.dock /tmp/dock.plist

# Bundle identifiers for required apps
FINDER_BUNDLE_ID="com.apple.finder"
SYSTEM_SETTINGS_BUNDLE_ID="com.apple.systempreferences"

# Flags to track if we found the apps
FOUND_FINDER=false
FOUND_SYSTEM_SETTINGS=false

# Scan for required apps
echo "Scanning current dock for Finder and System Settings..."
for i in {0..100}; do
  BUNDLE_ID=$(/usr/libexec/PlistBuddy -c "Print :persistent-apps:$i:tile-data:bundle-identifier" /tmp/dock.plist 2>/dev/null)
  
  # If we've reached the end of the array or encountered an error, break
  if [ $? -ne 0 ]; then
    break
  fi
  
  # Check for Finder
  if [ "$BUNDLE_ID" = "$FINDER_BUNDLE_ID" ]; then
    echo "Found Finder at index $i"
    FOUND_FINDER=true
  fi
  
  # Check for System Settings
  if [ "$BUNDLE_ID" = "$SYSTEM_SETTINGS_BUNDLE_ID" ]; then
    echo "Found System Settings at index $i"
    FOUND_SYSTEM_SETTINGS=true
  fi
done

# If Finder wasn't found, add it at the beginning
if [ "$FOUND_FINDER" = false ]; then
  echo "Adding Finder to the dock..."
  
  # First, get existing persistent-apps
  EXISTING_APPS=$(/usr/libexec/PlistBuddy -c "Print :persistent-apps" /tmp/dock.plist)
  
  # Delete the existing array and create a new one
  /usr/libexec/PlistBuddy -c "Delete :persistent-apps" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-apps array" /tmp/dock.plist
  
  # Add Finder as the first item
  /usr/libexec/PlistBuddy -c "Add :persistent-apps:0 dict" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-apps:0:tile-data dict" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-apps:0:tile-data:file-data dict" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-apps:0:tile-data:file-data:_CFURLString string file:///System/Library/CoreServices/Finder.app/" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-apps:0:tile-data:file-data:_CFURLStringType integer 15" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-apps:0:tile-data:bundle-identifier string $FINDER_BUNDLE_ID" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-apps:0:tile-type string file-tile" /tmp/dock.plist
  
  # Merge back the existing array (shifted by 1)
  if [ ! -z "$EXISTING_APPS" ]; then
    defaults export com.apple.dock /tmp/dock_original.plist
    for j in {0..100}; do
      EXISTING_ENTRY=$(/usr/libexec/PlistBuddy -c "Print :persistent-apps:$j" /tmp/dock_original.plist 2>/dev/null)
      if [ $? -ne 0 ]; then
        break
      fi
      
      NEW_INDEX=$((j + 1))
      /usr/libexec/PlistBuddy -c "Add :persistent-apps:$NEW_INDEX dict" /tmp/dock.plist
      /usr/libexec/PlistBuddy -c "Merge :persistent-apps:$j :persistent-apps:$NEW_INDEX" /tmp/dock_original.plist /tmp/dock.plist
    done
    rm /tmp/dock_original.plist
  fi
fi

# If System Settings wasn't found, add it after Finder
if [ "$FOUND_SYSTEM_SETTINGS" = false ]; then
  echo "Adding System Settings to the dock..."
  
  # Export the current state
  defaults export com.apple.dock /tmp/dock_current.plist
  
  # Find the insertion point (after Finder, or at index 1 if Finder wasn't there before)
  INSERTION_INDEX=1
  
  # Get existing persistent-apps
  EXISTING_APPS=$(/usr/libexec/PlistBuddy -c "Print :persistent-apps" /tmp/dock_current.plist)
  
  # Delete the existing array and create a new one
  /usr/libexec/PlistBuddy -c "Delete :persistent-apps" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-apps array" /tmp/dock.plist
  
  # Copy items before insertion point
  for j in $(seq 0 $((INSERTION_INDEX - 1))); do
    EXISTING_ENTRY=$(/usr/libexec/PlistBuddy -c "Print :persistent-apps:$j" /tmp/dock_current.plist 2>/dev/null)
    if [ $? -ne 0 ]; then
      break
    fi
    
    /usr/libexec/PlistBuddy -c "Add :persistent-apps:$j dict" /tmp/dock.plist
    /usr/libexec/PlistBuddy -c "Merge :persistent-apps:$j :persistent-apps:$j" /tmp/dock_current.plist /tmp/dock.plist
  done
  
  # Add System Settings at insertion point
  /usr/libexec/PlistBuddy -c "Add :persistent-apps:$INSERTION_INDEX dict" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-apps:$INSERTION_INDEX:tile-data dict" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-apps:$INSERTION_INDEX:tile-data:file-data dict" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-apps:$INSERTION_INDEX:tile-data:file-data:_CFURLString string file:///System/Applications/System%20Settings.app/" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-apps:$INSERTION_INDEX:tile-data:file-data:_CFURLStringType integer 15" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-apps:$INSERTION_INDEX:tile-data:bundle-identifier string $SYSTEM_SETTINGS_BUNDLE_ID" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-apps:$INSERTION_INDEX:tile-type string file-tile" /tmp/dock.plist
  
  # Copy items after insertion point
  for j in $(seq $INSERTION_INDEX 100); do
    EXISTING_ENTRY=$(/usr/libexec/PlistBuddy -c "Print :persistent-apps:$j" /tmp/dock_current.plist 2>/dev/null)
    if [ $? -ne 0 ]; then
      break
    fi
    
    NEW_INDEX=$((j + 1))
    /usr/libexec/PlistBuddy -c "Add :persistent-apps:$NEW_INDEX dict" /tmp/dock.plist
    /usr/libexec/PlistBuddy -c "Merge :persistent-apps:$j :persistent-apps:$NEW_INDEX" /tmp/dock_current.plist /tmp/dock.plist
  done
  
  rm /tmp/dock_current.plist
fi

# Check for existing Applications and Downloads folders in persistent-others
FOUND_APPLICATIONS=false
FOUND_DOWNLOADS=false

# Gets the current user's home directory
USER_HOME=$(eval echo ~$USER)
APPLICATIONS_PATH="file:///Applications/"
DOWNLOADS_PATH="file://$USER_HOME/Downloads/"

echo "Checking for existing Applications and Downloads folders in dock..."
for i in {0..100}; do
  URL_STRING=$(/usr/libexec/PlistBuddy -c "Print :persistent-others:$i:tile-data:file-data:_CFURLString" /tmp/dock.plist 2>/dev/null)
  
  # If we've reached the end of the array or encountered an error, break
  if [ $? -ne 0 ]; then
    break
  fi
  
  # Check for Applications folder
  if [ "$URL_STRING" = "$APPLICATIONS_PATH" ]; then
    echo "Found Applications folder at index $i"
    FOUND_APPLICATIONS=true
  fi
  
  # Check for Downloads folder
  if [ "$URL_STRING" = "$DOWNLOADS_PATH" ]; then
    echo "Found Downloads folder at index $i"
    FOUND_DOWNLOADS=true
  fi
done

# Gets the current size of the persistent-others array to determine the new index
ARRAY_SIZE=$(/usr/libexec/PlistBuddy -c "Print :persistent-others" /tmp/dock.plist | grep -c "Dict")
if [ -z "$ARRAY_SIZE" ]; then
  ARRAY_SIZE=0
fi

# Add Applications folder if not already present
if [ "$FOUND_APPLICATIONS" = false ]; then
  echo "Adding Applications folder at index $ARRAY_SIZE"
  
  # Adds Applications folder at the end of the persistent-others array
  /usr/libexec/PlistBuddy -c "Add :persistent-others:$ARRAY_SIZE dict" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-others:$ARRAY_SIZE:tile-data dict" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-others:$ARRAY_SIZE:tile-data:file-data dict" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-others:$ARRAY_SIZE:tile-data:file-data:_CFURLString string $APPLICATIONS_PATH" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-others:$ARRAY_SIZE:tile-data:file-data:_CFURLStringType integer 15" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-others:$ARRAY_SIZE:tile-data:file-type integer 2" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-others:$ARRAY_SIZE:tile-data:showas integer 1" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-others:$ARRAY_SIZE:tile-type string directory-tile" /tmp/dock.plist
  
  # Increment array size for next item
  ARRAY_SIZE=$((ARRAY_SIZE + 1))
else
  echo "Applications folder already exists in dock. Skipping."
fi

# Add Downloads folder if not already present
if [ "$FOUND_DOWNLOADS" = false ]; then
  echo "Adding Downloads folder at index $ARRAY_SIZE"
  
  # Adds Downloads folder after Applications folder
  /usr/libexec/PlistBuddy -c "Add :persistent-others:$ARRAY_SIZE dict" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-others:$ARRAY_SIZE:tile-data dict" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-others:$ARRAY_SIZE:tile-data:file-data dict" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-others:$ARRAY_SIZE:tile-data:file-data:_CFURLString string $DOWNLOADS_PATH" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-others:$ARRAY_SIZE:tile-data:file-data:_CFURLStringType integer 15" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-others:$ARRAY_SIZE:tile-data:file-type integer 2" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-others:$ARRAY_SIZE:tile-data:showas integer 1" /tmp/dock.plist
  /usr/libexec/PlistBuddy -c "Add :persistent-others:$ARRAY_SIZE:tile-type string directory-tile" /tmp/dock.plist
else
  echo "Downloads folder already exists in dock. Skipping."
fi

# Imports the modified plist back into defaults
defaults import com.apple.dock /tmp/dock.plist

# Restarts the Dock to apply changes
killall Dock

# Removes the temporary file
rm /tmp/dock.plist