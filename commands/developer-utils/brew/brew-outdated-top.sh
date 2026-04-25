#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Brew Outdated Top
# @raycast.mode fullOutput
# @raycast.packageName Brew

# Optional parameters:
# @raycast.icon 🍺
# @raycast.argument1 { "type": "text", "placeholder": "Max results (default: 20)", "optional": true }

# Documentation:
# @raycast.description Show a high-signal list of outdated Homebrew formulae and casks with current and latest version numbers. Optionally limit results to top N. Apple Silicon: expects brew at /opt/homebrew/bin/brew.
# @raycast.author lakerfan0306
# @raycast.authorURL https://github.com/lakerfan0306

PATH="/opt/homebrew/bin:$PATH"

LIMIT="${1:-20}"

# Validate numeric input
if ! echo "$LIMIT" | grep -qE '^[0-9]+$'; then
  echo "❌ Invalid argument: '$LIMIT' — expected a positive integer"
  exit 1
fi

if ! command -v brew &> /dev/null; then
  echo "❌ Homebrew not found"
  echo "   Install: https://brew.sh (Apple Silicon path: /opt/homebrew)"
  exit 1
fi

echo "=== Outdated Homebrew Packages (top $LIMIT) ==="
echo ""

# Formulae
FORMULAE=$(brew outdated --formula --verbose 2>/dev/null | head -"$LIMIT")
if [ -n "$FORMULAE" ]; then
  echo "📦 Formulae:"
  echo "$FORMULAE" | while IFS= read -r line; do
    echo "  $line"
  done
else
  echo "✅ All formulae up to date"
fi

echo ""

# Casks
CASKS=$(brew outdated --cask --verbose 2>/dev/null | head -"$LIMIT")
if [ -n "$CASKS" ]; then
  echo "🖥️  Casks:"
  echo "$CASKS" | while IFS= read -r line; do
    echo "  $line"
  done
else
  echo "✅ All casks up to date"
fi

echo ""
echo "Run 'brew upgrade' to update all, or 'brew upgrade <name>' for a specific package."
