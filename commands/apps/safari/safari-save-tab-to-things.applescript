#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Save Tab to Things
# @raycast.mode silent

# Optional parameters:
# @raycast.packageName Safari
# @raycast.icon images/safari.png

# Documentation:
# @raycast.description Create a Things to-do from the current Safari tab. The page title becomes the task title and the URL is added as a note.
# @raycast.author lakerfan0306
# @raycast.authorURL https://github.com/lakerfan0306

tell application "Safari"
  set pageTitle to name of current tab of window 1
  set pageURL to URL of current tab of window 1
end tell

set encodedTitle to do shell script "python3 -c \"import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))\" " & quoted form of pageTitle
set encodedURL to do shell script "python3 -c \"import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))\" " & quoted form of pageURL

open location "things:///add?title=" & encodedTitle & "&notes=" & encodedURL

log "Saved to Things: " & pageTitle
