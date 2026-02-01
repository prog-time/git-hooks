#!/bin/bash
# ------------------------------------------------------------------------------
# Runs all test suites in the tests directory.
# Executes each run.sh found in subdirectories.
# Reports overall pass/fail status.
# ------------------------------------------------------------------------------

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PASSED=0
FAILED=0
FAILED_TESTS=()

echo "========================================"
echo "Running all tests"
echo "========================================"
echo ""

# Find and run all test suites
for suite in $(find "$SCRIPT_DIR" -mindepth 2 -name "run.sh" | sort); do
    suite_name=$(dirname "$suite" | sed "s|$SCRIPT_DIR/||")
    echo "--- Suite: $suite_name ---"

    if "$suite"; then
        ((PASSED++))
    else
        ((FAILED++))
        FAILED_TESTS+=("$suite_name")
    fi
    echo ""
done

# Summary
echo "========================================"
echo "Summary"
echo "========================================"
echo "Passed: $PASSED"
echo "Failed: $FAILED"

if [[ $FAILED -gt 0 ]]; then
    echo ""
    echo "Failed suites:"
    for t in "${FAILED_TESTS[@]}"; do
        echo "  - $t"
    done
    exit 1
fi

echo ""
echo "All tests passed!"
exit 0
