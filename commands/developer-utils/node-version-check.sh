#!/bin/bash

# Note: Set currentDirectoryPath to your project directory to auto-detect .nvmrc and package.json.

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Node Version Check
# @raycast.mode fullOutput
# @raycast.packageName Developer Utils

# Optional parameters:
# @raycast.icon 🟢
# @raycast.currentDirectoryPath ~

# Documentation:
# @raycast.description Detect the current Node version and compare it against .nvmrc and/or package.json engines in the current directory. Surfaces mismatch warnings. Compatible with Node 24.
# @raycast.author lakerfan0306
# @raycast.authorURL https://github.com/lakerfan0306

# Prefer Homebrew Node on Apple Silicon
PATH="/opt/homebrew/bin:$PATH"

if ! command -v node &> /dev/null; then
  echo "❌ node not found"
  echo "   Install: brew install node"
  exit 1
fi

CURRENT_VERSION=$(node --version 2>/dev/null)
echo "Node version: $CURRENT_VERSION"
echo "Path:         $(command -v node)"
echo ""

FOUND_CONSTRAINT=false
MISMATCH=false

# Check .nvmrc
if [ -f ".nvmrc" ]; then
  FOUND_CONSTRAINT=true
  NVMRC_VERSION=$(cat .nvmrc | tr -d '[:space:]')
  echo ".nvmrc:       $NVMRC_VERSION"

  # Strip leading 'v' for comparison
  CURRENT_NUM="${CURRENT_VERSION#v}"
  NVMRC_NUM="${NVMRC_VERSION#v}"

  # Compare major versions
  CURRENT_MAJOR=$(echo "$CURRENT_NUM" | cut -d. -f1)
  NVMRC_MAJOR=$(echo "$NVMRC_NUM" | cut -d. -f1)

  if [ "$CURRENT_MAJOR" != "$NVMRC_MAJOR" ]; then
    echo "⚠️  Mismatch: running $CURRENT_VERSION but .nvmrc wants $NVMRC_VERSION"
    MISMATCH=true
  else
    echo "✅ .nvmrc matches"
  fi
  echo ""
fi

# Check package.json engines field
if [ -f "package.json" ]; then
  ENGINES_FIELD=$(grep -o '"node"[[:space:]]*:[[:space:]]*"[^"]*"' package.json | head -1 | sed 's/.*"node"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
  if [ -n "$ENGINES_FIELD" ]; then
    FOUND_CONSTRAINT=true
    echo "package.json engines.node: $ENGINES_FIELD"
    # Note: only checks that current major >= minimum required major.
    # Complex upper-bound ranges (e.g. ">=18 <20") are not fully evaluated.
    MIN_MAJOR=$(echo "$ENGINES_FIELD" | grep -oE '[0-9]+' | head -1)
    CURRENT_MAJOR="${CURRENT_VERSION#v}"
    CURRENT_MAJOR=$(echo "$CURRENT_MAJOR" | cut -d. -f1)
    if [ -n "$MIN_MAJOR" ] && [ "$CURRENT_MAJOR" -lt "$MIN_MAJOR" ] 2>/dev/null; then
      echo "⚠️  Mismatch: running Node $CURRENT_MAJOR but engines requires $ENGINES_FIELD"
      MISMATCH=true
    else
      echo "✅ package.json engines satisfied"
    fi
    echo ""
  fi
fi

if [ "$FOUND_CONSTRAINT" = false ]; then
  echo "ℹ️  No .nvmrc or package.json engines constraint found in $(pwd)"
fi

if [ "$MISMATCH" = true ]; then
  echo "Tip: use 'nvm use' or 'fnm use' to switch versions"
  exit 1
fi
