#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Copy Tab as Markdown Link
# @raycast.mode silent

# Optional parameters:
# @raycast.packageName Safari
# @raycast.icon images/safari.png

# Documentation:
# @raycast.description Copy the current Safari tab's title and URL to the clipboard as a Markdown link: [Title](URL).
# @raycast.author lakerfan0306
# @raycast.authorURL https://github.com/lakerfan0306

tell application "Safari"
  set currentTab to current tab of window 1
  set pageTitle to name of currentTab
  set pageURL to URL of currentTab
end tell

set markdownLink to "[" & pageTitle & "](" & pageURL & ")"
set the clipboard to markdownLink
log "Copied: " & markdownLink
