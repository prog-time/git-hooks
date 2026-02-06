#!/bin/bash
# ------------------------------------------------------------------------------
# Runs the full vitest test suite.
# No file arguments required — runs `npx vitest run`.
# Exits 1 if tests fail, 0 on success.
# ------------------------------------------------------------------------------

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_ROOT"

echo "Running tests..."
if ! npx vitest run; then
    echo "ERROR: Tests failed"
    exit 1
fi

echo "Tests passed!"

exit 0
