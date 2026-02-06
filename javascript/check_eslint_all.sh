#!/bin/bash
# ------------------------------------------------------------------------------
# Runs ESLint with --fix on the entire project (app/, components/, lib/, types/).
# No file arguments required — always checks all configured directories.
# Exits 1 if ESLint fails to fix issues, 0 on success.
# ------------------------------------------------------------------------------

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_ROOT"

# Directories to check
LINT_DIRS=("app/" "components/" "lib/" "types/")

echo "=== ESLint (full project) ==="

echo "Fixing ESLint issues..."
if ! npx eslint "${LINT_DIRS[@]}" --fix; then
    echo "ERROR: Failed to fix ESLint issues"
    exit 1
fi
echo "ESLint issues fixed!"

exit 0
