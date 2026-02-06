#!/bin/bash
# ----------------------------------------
# Run pytest locally (without Docker)
#
# This script:
#   • executes the full pytest test suite locally
#   • sets PYTHONPATH=./app so app modules resolve correctly
#   • returns proper exit codes (0/1) for CI/CD pipelines
#
# Usage:
#   ./run_tests.sh
# ----------------------------------------

# -----------------------------
# CONFIG
# -----------------------------
PYTHONPATH="./app"
TESTS_PATH="tests/"

# -----------------------------
# MAIN
# -----------------------------
echo "Running full test suite (pytest)..."

# Run tests locally with PYTHONPATH set
OUTPUT=$(PYTHONPATH="$PYTHONPATH" pytest -q "$TESTS_PATH" 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
    echo "----------------------------------------"
    echo "ERROR: Tests failed!"
    echo "----------------------------------------"
    echo "$OUTPUT"
    echo "----------------------------------------"
    exit 1
fi

echo "All tests passed!"
exit 0
