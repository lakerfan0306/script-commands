#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title List All Open Tabs
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.packageName Safari
# @raycast.icon images/safari.png

# Documentation:
# @raycast.description List the title and URL of every open tab across all Safari windows.
# @raycast.author lakerfan0306
# @raycast.authorURL https://github.com/lakerfan0306

tell application "Safari"
  set windowCount to count of windows
  set output to {}

  repeat with w from 1 to windowCount
    set win to window w
    set tabCount to count of tabs of win
    set end of output to "=== Window " & w & " (" & tabCount & " tab(s)) ==="

    repeat with t from 1 to tabCount
      set currentTab to tab t of win
      set pageTitle to name of currentTab
      set pageURL to URL of currentTab
      set end of output to pageTitle & linefeed & pageURL
    end repeat
  end repeat

  set AppleScript's text item delimiters to (linefeed & linefeed)
  log (output as text)
end tell
