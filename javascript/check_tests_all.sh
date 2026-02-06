#!/bin/bash
# ------------------------------------------------------------------------------
# Runs the full vitest test suite for the project.
# No file arguments required — runs all tests via `npx vitest run`.
# Exits 1 if tests fail, 0 on success.
# ------------------------------------------------------------------------------

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_ROOT"

echo "=== Running tests ==="
echo ""

npx vitest run
