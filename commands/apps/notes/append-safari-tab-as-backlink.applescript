#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Append Safari Tab as Backlink to Note
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./images/notes.png
# @raycast.argument1 { "type": "text", "placeholder": "Note Name" }
# @raycast.packageName Notes

# Documentation:
# @raycast.description Append the current Safari tab's title and URL as a backlink to an existing Apple Note.
# @raycast.author lakerfan0306
# @raycast.authorURL https://github.com/lakerfan0306

on run argv
  tell application "Safari"
    set pageTitle to name of current tab of window 1
    set pageURL to URL of current tab of window 1
  end tell

  set noteName to item 1 of argv
  set backlink to "<p><a href=\"" & pageURL & "\">" & pageTitle & "</a></p>"

  tell application "Notes"
    if exists note noteName then
      set existingBody to body of note noteName
      set body of note noteName to existingBody & backlink
      log "Appended backlink to: " & noteName
    else
      log "Note \"" & noteName & "\" was not found"
    end if
  end tell
end run
