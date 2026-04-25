#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Python Venv Health
# @raycast.mode fullOutput
# @raycast.packageName Developer Utils

# Optional parameters:
# @raycast.icon 🐍
# @raycast.currentDirectoryPath ~

# Documentation:
# @raycast.description Report Python path and version, pyenv version if present, virtual environment activation state, and recommend the creation command when a venv is missing. Prefers pyenv and venv workflows.
# @raycast.author lakerfan0306
# @raycast.authorURL https://github.com/lakerfan0306

# Include common install paths for Apple Silicon
PATH="/opt/homebrew/bin:$HOME/.pyenv/shims:$HOME/.pyenv/bin:$PATH"

echo "=== Python Environment Health ==="
echo ""

# --- Active Python ---
if command -v python3 &> /dev/null; then
  PYTHON_PATH=$(command -v python3)
  PYTHON_VERSION=$(python3 --version 2>&1)
  echo "Python:  $PYTHON_VERSION"
  echo "Path:    $PYTHON_PATH"
else
  echo "❌ python3 not found"
  echo "   Install: brew install python or brew install pyenv && pyenv install 3.x"
fi
echo ""

# --- pyenv ---
if command -v pyenv &> /dev/null; then
  PYENV_VERSION=$(pyenv version 2>/dev/null)
  PYENV_ROOT=$(pyenv root 2>/dev/null)
  echo "pyenv:   $PYENV_VERSION"
  echo "Root:    $PYENV_ROOT"
  if [ -f ".python-version" ]; then
    LOCAL_VERSION=$(cat .python-version | tr -d '[:space:]')
    echo ".python-version: $LOCAL_VERSION"
  fi
else
  echo "ℹ️  pyenv not installed"
  echo "   Install: brew install pyenv"
fi
echo ""

# --- Virtual Environment ---
if [ -n "$VIRTUAL_ENV" ]; then
  VENV_PYTHON_VERSION=$(python3 --version 2>&1)
  echo "✅ venv active: $VIRTUAL_ENV"
  echo "   Python:  $VENV_PYTHON_VERSION"
else
  echo "⚠️  No virtual environment is active"
  # Check for common venv directories in CWD
  for dir in .venv venv env; do
    if [ -d "$dir" ] && [ -f "$dir/bin/activate" ]; then
      echo "   Found: ./$dir — activate with: source ./$dir/bin/activate"
      exit 0
    fi
  done
  echo ""
  echo "   No venv found in current directory."
  echo "   Create: python3 -m venv .venv"
  echo "   Activate: source .venv/bin/activate"
fi
