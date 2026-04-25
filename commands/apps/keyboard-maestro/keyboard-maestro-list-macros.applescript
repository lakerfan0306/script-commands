#!/usr/bin/osascript

# Note: Keyboard Maestro is required.
# Install via: https://www.keyboardmaestro.com/

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title List Keyboard Maestro Macros
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.packageName Keyboard Maestro
# @raycast.icon 🎹

# Documentation:
# @raycast.description List all macro names in Keyboard Maestro, grouped by macro group.
# @raycast.author lakerfan0306
# @raycast.authorURL https://github.com/lakerfan0306

tell application "Keyboard Maestro"
  set output to {}
  set allGroups to every macro group

  repeat with g in allGroups
    set groupName to name of g
    set end of output to "=== " & groupName & " ==="
    set groupMacros to every macro of g

    repeat with m in groupMacros
      set end of output to "  " & (name of m)
    end repeat
  end repeat

  set AppleScript's text item delimiters to linefeed
  log (output as text)
end tell
