#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Colima Status
# @raycast.mode fullOutput
# @raycast.packageName Docker

# Optional parameters:
# @raycast.icon 🐳

# Documentation:
# @raycast.description Report whether Colima is installed and running on Apple Silicon, show the active Docker context and engine reachability, and suggest exact fix commands when something is wrong.
# @raycast.author lakerfan0306
# @raycast.authorURL https://github.com/lakerfan0306

PATH="/opt/homebrew/bin:$PATH"

echo "=== Colima / Docker Status (Apple Silicon) ==="
echo ""

# --- Colima ---
if ! command -v colima &> /dev/null; then
  echo "❌ Colima not installed"
  echo "   Install: brew install colima docker"
  exit 1
fi

COLIMA_VERSION=$(colima version 2>/dev/null | head -1)
echo "Colima:  $COLIMA_VERSION"
echo "Binary:  $(command -v colima)"
echo ""

COLIMA_STATUS=$(colima status 2>&1)
if echo "$COLIMA_STATUS" | grep -q "running"; then
  echo "✅ Colima is running"
  echo "$COLIMA_STATUS" | grep -E "runtime|arch|cpu|memory|disk" | sed 's/^/   /'
else
  echo "⚠️  Colima is not running"
  echo "   Start (macOS 13+ Ventura): colima start --arch aarch64 --vm-type vz --vz-rosetta"
  echo "   Start (macOS 12 or older): colima start --arch aarch64 --vm-type qemu"
fi
echo ""

# --- Docker CLI ---
if ! command -v docker &> /dev/null; then
  echo "❌ Docker CLI not found"
  echo "   Install: brew install docker"
  exit 1
fi

echo "Docker CLI: $(docker --version 2>/dev/null)"
echo ""

# --- Docker context ---
DOCKER_CONTEXT=$(docker context show 2>/dev/null)
echo "Docker context: $DOCKER_CONTEXT"
echo ""

# --- Engine reachability ---
if docker info &> /dev/null; then
  SERVER_VERSION=$(docker info --format '{{.ServerVersion}}' 2>/dev/null)
  echo "✅ Docker engine reachable (server $SERVER_VERSION)"
else
  echo "❌ Docker engine not reachable"
  echo "   Fix (macOS 13+): colima start --arch aarch64 --vm-type vz --vz-rosetta"
  echo "   Fix (macOS 12-): colima start --arch aarch64 --vm-type qemu"
  echo "   Or:              docker context use colima"
fi
