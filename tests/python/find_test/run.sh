#!/bin/bash
# ------------------------------------------------------------------------------
# Runs all find_test hook test cases.
# Executes each case script in the cases/ directory.
# ------------------------------------------------------------------------------

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PASSED=0
FAILED=0

for case_file in "$SCRIPT_DIR"/cases/*.sh; do
    [[ -f "$case_file" ]] || continue

    if "$case_file"; then
        ((PASSED++)) || true
    else
        ((FAILED++)) || true
    fi
done

echo ""
echo "Find test tests: $PASSED passed, $FAILED failed"

[[ $FAILED -eq 0 ]]
