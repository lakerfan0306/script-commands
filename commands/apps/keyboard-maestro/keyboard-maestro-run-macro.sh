#!/bin/bash

# Note: Keyboard Maestro is required.
# Install via: https://www.keyboardmaestro.com/

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Run Keyboard Maestro Macro
# @raycast.mode silent

# Optional parameters:
# @raycast.packageName Keyboard Maestro
# @raycast.icon 🎹
# @raycast.argument1 { "type": "text", "placeholder": "Macro Name or UUID" }

# Documentation:
# @raycast.description Trigger a Keyboard Maestro macro by its name or UUID.
# @raycast.author lakerfan0306
# @raycast.authorURL https://github.com/lakerfan0306

macro_name="$1"

if [ -z "$macro_name" ]; then
  echo "Please provide a macro name or UUID"
  exit 1
fi

if ! osascript -e "tell application \"Keyboard Maestro Engine\" to do script \"$macro_name\"" 2>/dev/null; then
  echo "Failed to run macro: $macro_name"
  exit 1
fi

echo "Ran macro: $macro_name"
