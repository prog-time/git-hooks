#!/bin/bash
# ----------------------------------------
# CSS Code Style Checker
#
# This script checks CSS/SCSS/Less files for
# style issues using Stylelint. It runs directly
# on the host (no Docker required).
#
# Usage:
#   ./check_stylelint.sh file1.css file2.scss ...
# ----------------------------------------

if [ $# -eq 0 ]; then
    echo "No files to check"
    exit 0
fi

STYLE_FILES=()
CHECKED_FILES=0
HAS_ERRORS=0

for file in "$@"; do
    # Skip non-style files
    if [[ ! "$file" =~ \.(css|scss|less)$ ]]; then
        continue
    fi

    # Skip if file doesn't exist
    if [ ! -f "$file" ]; then
        continue
    fi

    STYLE_FILES+=("$file")
done

# Check if there are any style files to check
if [ ${#STYLE_FILES[@]} -eq 0 ]; then
    echo "No CSS/SCSS/Less files to check"
    exit 0
fi

# Run Stylelint on each file
for file in "${STYLE_FILES[@]}"; do
    CHECKED_FILES=$((CHECKED_FILES + 1))

    OUTPUT=$(npx stylelint "$file" 2>&1)
    EXIT_CODE=$?

    if [ $EXIT_CODE -ne 0 ]; then
        HAS_ERRORS=1
        echo "Stylelint errors in: $file"
        echo "$OUTPUT"
        echo ""
    fi
done

# Final result
if [ $HAS_ERRORS -ne 0 ]; then
    echo "----------------------------------------"
    echo "ERROR: Stylelint check failed!"
    echo "Total files checked: $CHECKED_FILES"
    echo "Fix the errors above before committing."
    exit 1
fi

echo "Stylelint check passed! ($CHECKED_FILES files checked)"
exit 0
