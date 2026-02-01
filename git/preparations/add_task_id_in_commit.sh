#!/bin/sh
# ------------------------------------------------------------------------------
# Prepends task ID to commit message based on branch name.
# Extracts task ID from branch using configurable TASK_ID_PATTERN.
# Skips if task ID already present in commit message.
# Example: branch "feature/dev-2212_order" -> commit "dev-2212 | <message>"
# ------------------------------------------------------------------------------

# -----------------------------------------
# Configuration
# -----------------------------------------
TASK_ID_PATTERN="dev-[0-9]+"
COMMIT_MSG_FILE=".git/COMMIT_EDITMSG"
# -----------------------------------------

BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

if echo "$BRANCH_NAME" | grep -qE "$TASK_ID_PATTERN"; then
  TASK_ID=$(echo "$BRANCH_NAME" | grep -oE "$TASK_ID_PATTERN")

  if ! grep -q "$TASK_ID" "$COMMIT_MSG_FILE"; then
    sed -i.bak "1s/^/$TASK_ID | /" "$COMMIT_MSG_FILE"
    rm -f "$COMMIT_MSG_FILE.bak"
  fi
fi
