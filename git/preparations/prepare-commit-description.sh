#!/bin/sh
# ------------------------------------------------------------------------------
# Appends list of staged files to commit message body.
# Shows file status (Added, Modified, Deleted, Renamed) for each file.
# Skips merge commits to avoid modifying auto-generated messages.
# ------------------------------------------------------------------------------

COMMIT_MSG_FILE=".git/COMMIT_EDITMSG"

# Skip merge commits
if grep -qE '^Merge' "$COMMIT_MSG_FILE"; then
  exit 0
fi

# Get staged changes
CHANGES=$(git diff --cached --name-status)
[ -z "$CHANGES" ] && exit 0

{
  echo ""
  echo "------------------------------"
  echo "Changed files:"
  echo "$CHANGES" | while read -r STATUS FILE; do
    case "$STATUS" in
      A) echo "Added:    $FILE" ;;
      M) echo "Modified: $FILE" ;;
      D) echo "Deleted:  $FILE" ;;
      R) echo "Renamed:  $FILE" ;;
      *) echo "$STATUS: $FILE" ;;
    esac
  done
} >> "$COMMIT_MSG_FILE"
