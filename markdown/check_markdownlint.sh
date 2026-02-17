#!/bin/bash
# ----------------------------------------
# Markdown Code Style Checker
#
# This script checks Markdown files for
# style issues using markdownlint. It runs
# directly on the host (no Docker required).
#
# Usage:
#   ./check_markdownlint.sh file1.md file2.md ...
# ----------------------------------------

if [ $# -eq 0 ]; then
    echo "No files to check"
    exit 0
fi

MD_FILES=()
CHECKED_FILES=0
HAS_ERRORS=0

for file in "$@"; do
    # Skip non-Markdown files
    if [[ ! "$file" =~ \.md$ ]]; then
        continue
    fi

    # Skip if file doesn't exist
    if [ ! -f "$file" ]; then
        continue
    fi

    MD_FILES+=("$file")
done

# Check if there are any Markdown files to check
if [ ${#MD_FILES[@]} -eq 0 ]; then
    echo "No Markdown files to check"
    exit 0
fi

# Run markdownlint on each file
for file in "${MD_FILES[@]}"; do
    CHECKED_FILES=$((CHECKED_FILES + 1))

    OUTPUT=$(markdownlint "$file" 2>&1)
    EXIT_CODE=$?

    if [ $EXIT_CODE -ne 0 ]; then
        HAS_ERRORS=1
        echo "Markdownlint errors in: $file"
        echo "$OUTPUT"
        echo ""
    fi
done

# Final result
if [ $HAS_ERRORS -ne 0 ]; then
    echo "----------------------------------------"
    echo "ERROR: Markdownlint check failed!"
    echo "Total files checked: $CHECKED_FILES"
    echo "Fix the errors above before committing."
    exit 1
fi

echo "Markdownlint check passed! ($CHECKED_FILES files checked)"
exit 0
