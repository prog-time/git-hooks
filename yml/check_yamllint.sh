#!/bin/bash
# ----------------------------------------
# YAML Code Style Checker
#
# This script checks YAML files for
# style issues using yamllint. It runs
# directly on the host (no Docker required).
#
# Usage:
#   ./check_yamllint.sh file1.yml file2.yaml ...
# ----------------------------------------

if [ $# -eq 0 ]; then
    echo "No files to check"
    exit 0
fi

YAML_FILES=()
CHECKED_FILES=0
HAS_ERRORS=0

for file in "$@"; do
    # Skip non-YAML files
    if [[ ! "$file" =~ \.(yml|yaml)$ ]]; then
        continue
    fi

    # Skip if file doesn't exist
    if [ ! -f "$file" ]; then
        continue
    fi

    YAML_FILES+=("$file")
done

# Check if there are any YAML files to check
if [ ${#YAML_FILES[@]} -eq 0 ]; then
    echo "No YAML files to check"
    exit 0
fi

# Run yamllint on each file
for file in "${YAML_FILES[@]}"; do
    CHECKED_FILES=$((CHECKED_FILES + 1))

    OUTPUT=$(yamllint "$file" 2>&1)
    EXIT_CODE=$?

    if [ $EXIT_CODE -ne 0 ]; then
        HAS_ERRORS=1
        echo "yamllint errors in: $file"
        echo "$OUTPUT"
        echo ""
    fi
done

# Final result
if [ $HAS_ERRORS -ne 0 ]; then
    echo "----------------------------------------"
    echo "ERROR: yamllint check failed!"
    echo "Total files checked: $CHECKED_FILES"
    echo "Fix the errors above before committing."
    exit 1
fi

echo "yamllint check passed! ($CHECKED_FILES files checked)"
exit 0
