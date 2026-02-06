#!/bin/bash

# ------------------------------------------------------------
# Runs mypy static analysis for changed Python files locally.
# Accepts file paths as args and checks only app/*.py files.
# ------------------------------------------------------------

if [ $# -eq 0 ]; then
    echo "No files to check"
    exit 0
fi

PY_FILES=()

for file in "$@"; do
    # Skip non-Python files
    if [[ ! "$file" =~ \.py$ ]]; then
        continue
    fi

    # Only files inside app/
    if [[ ! "$file" =~ ^app/ ]]; then
        continue
    fi

    # Skip if file doesn't exist
    if [ ! -f "$file" ]; then
        continue
    fi

    PY_FILES+=("$file")
done

if [ ${#PY_FILES[@]} -eq 0 ]; then
    echo "No Python files to check"
    exit 0
fi

OUTPUT=$(mypy \
    --pretty \
    --show-error-codes \
    --ignore-missing-imports \
    --follow-imports=skip \
    "${PY_FILES[@]}" 2>&1)

EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
    echo "----------------------------------------"
    echo "ERROR: Static analysis failed!"
    echo "----------------------------------------"
    echo "$OUTPUT"
    echo "----------------------------------------"
    echo "Total files checked: ${#PY_FILES[@]}"
    exit 1
fi

echo "Static analysis passed! (${#PY_FILES[@]} files checked)"
exit 0
