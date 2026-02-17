#!/bin/bash
# ----------------------------------------
# HTML Code Checker
#
# This script checks HTML files for issues
# using HTMLHint. It runs directly on
# the host (no Docker required).
#
# Usage:
#   ./check_html_hint.sh file1.html file2.html ...
# ----------------------------------------

if [ $# -eq 0 ]; then
    echo "No files to check"
    exit 0
fi

HTML_FILES=()
CHECKED_FILES=0
HAS_ERRORS=0

for file in "$@"; do
    # Skip non-HTML files
    if [[ ! "$file" =~ \.html$ ]]; then
        continue
    fi

    # Skip if file doesn't exist
    if [ ! -f "$file" ]; then
        continue
    fi

    HTML_FILES+=("$file")
done

# Check if there are any HTML files to check
if [ ${#HTML_FILES[@]} -eq 0 ]; then
    echo "No HTML files to check"
    exit 0
fi

# Run HTMLHint on each file
for file in "${HTML_FILES[@]}"; do
    CHECKED_FILES=$((CHECKED_FILES + 1))

    OUTPUT=$(npx htmlhint "$file" 2>&1)
    EXIT_CODE=$?

    if [ $EXIT_CODE -ne 0 ]; then
        HAS_ERRORS=1
        echo "HTMLHint errors in: $file"
        echo "$OUTPUT"
        echo ""
    fi
done

# Final result
if [ $HAS_ERRORS -ne 0 ]; then
    echo "----------------------------------------"
    echo "ERROR: HTMLHint check failed!"
    echo "Total files checked: $CHECKED_FILES"
    echo "Fix the errors above before committing."
    exit 1
fi

echo "HTMLHint check passed! ($CHECKED_FILES files checked)"
exit 0
