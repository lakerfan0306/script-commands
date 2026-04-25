#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Add To-Do from Safari Tab
# @raycast.mode silent

# Optional parameters:
# @raycast.packageName Things
# @raycast.icon images/things.png
# @raycast.argument1 { "type": "text", "placeholder": "When (e.g. \"today\")", "optional": true }

# Documentation:
# @raycast.description Create a Things 3 to-do using the current Safari tab title as the task name and the URL as the note. Optionally schedule it with a "when" value such as "today".
# @raycast.author lakerfan0306
# @raycast.authorURL https://github.com/lakerfan0306

on run argv
  tell application "Safari"
    set pageTitle to name of current tab of window 1
    set pageURL to URL of current tab of window 1
  end tell

  set whenArg to ""
  if (count of argv) > 0 then set whenArg to item 1 of argv

  set encodedTitle to do shell script "python3 -c \"import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))\" " & quoted form of pageTitle
  set encodedURL to do shell script "python3 -c \"import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))\" " & quoted form of pageURL
  set encodedWhen to do shell script "python3 -c \"import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))\" " & quoted form of whenArg

  set thingsURL to "things:///add?title=" & encodedTitle & "&notes=" & encodedURL
  if whenArg is not "" then set thingsURL to thingsURL & "&when=" & encodedWhen

  open location thingsURL
  log "Added to Things: " & pageTitle
end run
