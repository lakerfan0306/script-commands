#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Move Tab to New Window
# @raycast.mode silent

# Optional parameters:
# @raycast.packageName Safari
# @raycast.icon images/safari.png

# Documentation:
# @raycast.description Move the current Safari tab into its own new window.
# @raycast.author lakerfan0306
# @raycast.authorURL https://github.com/lakerfan0306

tell application "Safari"
  set currentWindow to window 1
  set currentTab to current tab of currentWindow
  set tabURL to URL of currentTab
  set tabTitle to name of currentTab

  -- Only move if there is more than one tab; otherwise the window is already standalone
  if (count of tabs of currentWindow) > 1 then
    close currentTab
    make new document with properties {URL: tabURL}
  end if
end tell

log "Moved tab to new window"
