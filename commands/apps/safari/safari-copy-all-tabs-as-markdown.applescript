#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Copy All Tabs as Markdown Links
# @raycast.mode silent

# Optional parameters:
# @raycast.packageName Safari
# @raycast.icon images/safari.png

# Documentation:
# @raycast.description Copy all tabs in the frontmost Safari window to the clipboard as a Markdown list of links.
# @raycast.author lakerfan0306
# @raycast.authorURL https://github.com/lakerfan0306

tell application "Safari"
  tell front window
    set tabCount to count of tabs
    set linkLines to {}

    repeat with i from 1 to tabCount
      set t to tab i
      set pageTitle to name of t
      set pageURL to URL of t
      set end of linkLines to "- [" & pageTitle & "](" & pageURL & ")"
    end repeat
  end tell
end tell

set AppleScript's text item delimiters to linefeed
set markdownList to (linkLines as text)
set the clipboard to markdownList
log "Copied " & (count of linkLines) & " tab(s) as Markdown links"
