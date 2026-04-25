#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Save Safari Tab as Note
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./images/notes.png
# @raycast.packageName Notes

# Documentation:
# @raycast.description Create a new Apple Note containing the current Safari tab's title and URL.
# @raycast.author lakerfan0306
# @raycast.authorURL https://github.com/lakerfan0306

tell application "Safari"
  set pageTitle to name of current tab of window 1
  set pageURL to URL of current tab of window 1
end tell

set noteBody to "<body><h1>" & pageTitle & "</h1><p><a href=\"" & pageURL & "\">" & pageURL & "</a></p></body>"

tell application "Notes"
  make new note at folder "Notes" with properties {name: pageTitle, body: noteBody}
end tell

log "Saved note: " & pageTitle
