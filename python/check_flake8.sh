#!/bin/bash
# ----------------------------------------
# Python Code Style Checker
#
# This script checks Python files for style
# issues using flake8. It runs directly on
# the host (no Docker required).
#
# Usage:
#   ./check_style.sh file1.py file2.py ...
# ----------------------------------------

if [ $# -eq 0 ]; then
    echo "No files to check"
    exit 0
fi

PY_FILES=()
CHECKED_FILES=0
HAS_ERRORS=0

for file in "$@"; do
    # Skip non-Python files
    if [[ ! "$file" =~ \.py$ ]]; then
        continue
    fi

    # Skip if file doesn't exist
    if [ ! -f "$file" ]; then
        continue
    fi

    PY_FILES+=("$file")
done

# Check if there are any Python files to check
if [ ${#PY_FILES[@]} -eq 0 ]; then
    echo "No Python files to check"
    exit 0
fi

# Run flake8 linter on each file
for file in "${PY_FILES[@]}"; do
    CHECKED_FILES=$((CHECKED_FILES + 1))

    OUTPUT=$(flake8 --max-line-length=120 "$file" 2>&1)
    EXIT_CODE=$?

    if [ $EXIT_CODE -ne 0 ]; then
        HAS_ERRORS=1
        echo "Style errors in: $file"
        echo "$OUTPUT"
        echo ""
    fi
done

# Final result
if [ $HAS_ERRORS -ne 0 ]; then
    echo "----------------------------------------"
    echo "ERROR: Code style check failed!"
    echo "Total files checked: $CHECKED_FILES"
    echo "Fix the errors above before committing."
    exit 1
fi

echo "Code style check passed! ($CHECKED_FILES files checked)"
exit 0
