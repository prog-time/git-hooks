#!/bin/bash

COMMAND="$1"

# -----------------------------
# Get list of PHP files to check
# -----------------------------
if [ "$COMMAND" = "commit" ]; then
    ALL_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.php$' || true)
elif [ "$COMMAND" = "push" ]; then
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    ALL_FILES=$(git diff --name-only origin/$BRANCH --diff-filter=ACM | grep '\.php$' || true)
else
    echo "Unknown command: $COMMAND"
    exit 1
fi

# Exit if no PHP files found
if [ -z "$ALL_FILES" ]; then
  echo "✅ [Pint] No PHP files to check."
  exit 0
fi

# -----------------------------
# Run Pint in test mode
# -----------------------------
vendor/bin/pint --test $ALL_FILES
RESULT=$?

if [ $RESULT -ne 0 ]; then
  echo "❌ Pint found code style issues. Auto-fixing..."
  vendor/bin/pint $ALL_FILES
  echo "$ALL_FILES" | xargs git add
  echo "✅ [Pint] Code style fixed. Please re-run the commit."
  exit 1
fi

echo "✅ [Pint] All files pass code style."
exit 0
