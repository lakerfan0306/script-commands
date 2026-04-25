#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Warp Env Doctor
# @raycast.mode fullOutput
# @raycast.packageName System

# Optional parameters:
# @raycast.icon 🩺

# Documentation:
# @raycast.description Detect PATH ordering issues (especially /opt/homebrew/bin), duplicate PATH entries, missing common dev binaries, and print shell init file hints. Tailored for Warp terminal on macOS Apple Silicon.
# @raycast.author lakerfan0306
# @raycast.authorURL https://github.com/lakerfan0306

echo "=== Warp Env Doctor ==="
echo ""

ISSUES=0

# --- PATH entries ---
IFS=':' read -ra PATH_ENTRIES <<< "$PATH"

echo "── PATH entries (${#PATH_ENTRIES[@]} total) ──"
for entry in "${PATH_ENTRIES[@]}"; do
  echo "  $entry"
done
echo ""

# --- /opt/homebrew/bin ordering ---
HOMEBREW_BIN="/opt/homebrew/bin"
FIRST_BIN="${PATH_ENTRIES[0]}"
if [[ "$PATH" != *"$HOMEBREW_BIN"* ]]; then
  echo "❌ $HOMEBREW_BIN is not in PATH"
  echo "   Fix: add to ~/.zshrc — export PATH=\"$HOMEBREW_BIN:\$PATH\""
  ISSUES=$((ISSUES + 1))
elif [[ "$FIRST_BIN" != "$HOMEBREW_BIN" ]]; then
  echo "⚠️  $HOMEBREW_BIN is in PATH but not first (found at position)"
  # Find position
  for i in "${!PATH_ENTRIES[@]}"; do
    if [[ "${PATH_ENTRIES[$i]}" == "$HOMEBREW_BIN" ]]; then
      echo "   Position: $((i + 1)) of ${#PATH_ENTRIES[@]}"
    fi
  done
  echo "   Tip: move 'export PATH=\"$HOMEBREW_BIN:\$PATH\"' to the top of ~/.zshrc"
  ISSUES=$((ISSUES + 1))
else
  echo "✅ $HOMEBREW_BIN is first in PATH"
fi
echo ""

# --- Duplicate PATH entries ---
DUPLICATES=$(printf '%s\n' "${PATH_ENTRIES[@]}" | sort | uniq -d)
if [ -n "$DUPLICATES" ]; then
  echo "⚠️  Duplicate PATH entries detected:"
  echo "$DUPLICATES" | while IFS= read -r dup; do
    echo "  - $dup"
  done
  echo "   Tip: check ~/.zshrc, ~/.zprofile, and /etc/paths for repeated entries"
  ISSUES=$((ISSUES + 1))
else
  echo "✅ No duplicate PATH entries"
fi
echo ""

# --- Common dev binaries ---
echo "── Dev Binary Checks ──"
BINS=(git node npm brew python3 docker colima jq curl)
for bin in "${BINS[@]}"; do
  if command -v "$bin" &> /dev/null; then
    printf "  ✅ %-10s %s\n" "$bin" "$(command -v "$bin")"
  else
    printf "  ❌ %-10s not found" "$bin"
    case "$bin" in
      git)      echo " — Install Xcode CLT: xcode-select --install" ;;
      node|npm) echo " — Install: brew install node" ;;
      brew)     echo " — Install: https://brew.sh" ;;
      python3)  echo " — Install: brew install python or brew install pyenv" ;;
      docker)   echo " — Install: brew install docker" ;;
      colima)   echo " — Install: brew install colima" ;;
      jq)       echo " — Install: brew install jq" ;;
      curl)     echo " — Should be built-in; check /usr/bin/curl" ;;
      *)        echo "" ;;
    esac
    ISSUES=$((ISSUES + 1))
  fi
done
echo ""

# --- Shell init file hints ---
echo "── Shell Init Files ──"
INIT_FILES=("$HOME/.zshrc" "$HOME/.zprofile" "$HOME/.profile")
for f in "${INIT_FILES[@]}"; do
  if [ -f "$f" ]; then
    LINE_COUNT=$(wc -l < "$f" | tr -d ' ')
    echo "  📄 $f ($LINE_COUNT lines)"
    # Check if homebrew path is set in this file
    if grep -q "opt/homebrew" "$f" 2>/dev/null; then
      echo "     └─ contains /opt/homebrew reference ✅"
    fi
  else
    echo "  ℹ️  $f not found"
  fi
done
echo ""

# --- Summary ---
if [ "$ISSUES" -eq 0 ]; then
  echo "✅ No issues detected — environment looks healthy"
else
  echo "⚠️  $ISSUES issue(s) found — review the hints above"
  exit 1
fi
