#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Ports in Use
# @raycast.mode fullOutput
# @raycast.packageName Developer Utils

# Optional parameters:
# @raycast.icon 🔌
# @raycast.argument1 { "type": "text", "placeholder": "Port number (optional)", "optional": true }

# Documentation:
# @raycast.description Show listening TCP ports, process names, and PIDs. Optionally filter by a specific port number.
# @raycast.author lakerfan0306
# @raycast.authorURL https://github.com/lakerfan0306

PORT_FILTER="$1"

print_header() {
  printf "%-8s %-25s %s\n" "PID" "ADDRESS:PORT" "PROCESS"
  printf "%-8s %-25s %s\n" "-------" "------------------------" "-------"
}

if [ -n "$PORT_FILTER" ]; then
  result=$(lsof -iTCP:"$PORT_FILTER" -sTCP:LISTEN -nP 2>/dev/null | tail -n +2)
  if [ -z "$result" ]; then
    echo "No process listening on port $PORT_FILTER"
    exit 0
  fi
  print_header
  echo "$result" | awk '{printf "%-8s %-25s %s\n", $2, $9, $1}'
else
  result=$(lsof -iTCP -sTCP:LISTEN -nP 2>/dev/null | tail -n +2)
  if [ -z "$result" ]; then
    echo "No listening TCP ports found"
    exit 0
  fi
  print_header
  # Sort by port number — extract the last colon-delimited segment to handle
  # both IPv4 (127.0.0.1:3000) and IPv6 (::1:3000) addresses robustly.
  echo "$result" | awk '{
    n = split($9, parts, ":")
    port = parts[n] + 0
    printf "%-8s %-25s %-20s %d\n", $2, $9, $1, port
  }' | sort -k4 -n | awk '{printf "%-8s %-25s %s\n", $1, $2, $3}'
fi
