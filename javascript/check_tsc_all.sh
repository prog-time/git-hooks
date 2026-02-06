#!/bin/bash
# ------------------------------------------------------------------------------
# Runs TypeScript type checking on the entire project using tsconfig.check.json.
# No file arguments required — checks all files configured in tsconfig.
# Exits 1 if type check fails, 0 on success.
# ------------------------------------------------------------------------------

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_ROOT"

# TypeScript config
TS_CONFIG="tsconfig.check.json"

echo "=== TypeScript ==="
echo "Running type check..."
if ! npx tsc --project "$TS_CONFIG"; then
    echo "ERROR: TypeScript check failed"
    exit 1
fi
echo "TypeScript check passed!"

exit 0
