#!/bin/bash

# Note: Set currentDirectoryPath to your local git repository.

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title PR Branch Cleanup
# @raycast.mode fullOutput
# @raycast.packageName Git

# Optional parameters:
# @raycast.icon 🧹
# @raycast.currentDirectoryPath ~
# @raycast.argument1 { "type": "text", "placeholder": "Type 'apply' to delete branches", "optional": true }

# Documentation:
# @raycast.description Dry-run stale local merged-branch cleanup by default. Pass 'apply' as argument to actually delete the merged local branches. Always safe against main, master, develop, and the current branch.
# @raycast.author lakerfan0306
# @raycast.authorURL https://github.com/lakerfan0306

APPLY_MODE="$1"

# Verify we are inside a git repository
if ! git rev-parse --git-dir &> /dev/null; then
  echo "❌ Not inside a git repository"
  echo "   Set currentDirectoryPath to your project in Raycast settings"
  exit 1
fi

# Fetch to get up-to-date remote tracking info (quiet, non-destructive)
git fetch --prune --quiet 2>/dev/null

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
DEFAULT_BRANCHES="main master develop"

# Collect merged branches, excluding protected and current branches
MERGED_BRANCHES=$(git branch --merged 2>/dev/null | sed 's/^[* ]*//' | grep -vE '^(main|master|develop)$' | grep -Fxv "$CURRENT_BRANCH")

if [ -z "$MERGED_BRANCHES" ]; then
  echo "✅ No stale merged branches found"
  exit 0
fi

BRANCH_COUNT=$(echo "$MERGED_BRANCHES" | wc -l | tr -d ' ')

if [ "$APPLY_MODE" = "apply" ]; then
  echo "🗑️  Deleting $BRANCH_COUNT merged local branch(es):"
  echo ""
  echo "$MERGED_BRANCHES" | while IFS= read -r branch; do
    git branch -d "$branch" 2>&1 | sed "s/^/  /"
  done
  echo ""
  echo "Done. Run 'git fetch --prune' to also clean up remote-tracking refs."
else
  echo "🔍 Dry-run — $BRANCH_COUNT merged local branch(es) would be deleted:"
  echo ""
  echo "$MERGED_BRANCHES" | while IFS= read -r branch; do
    LAST_COMMIT=$(git log -1 --format="%ar | %s" "$branch" 2>/dev/null)
    echo "  - $branch  ($LAST_COMMIT)"
  done
  echo ""
  echo "Current branch: $CURRENT_BRANCH (protected)"
  echo "Protected:      main, master, develop"
  echo ""
  echo "To delete these branches, run this command again with 'apply' as the argument."
fi
