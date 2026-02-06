#!/bin/bash
# ------------------------------------------------------------------------------
# Runs Prettier --write on all TypeScript files in the project.
# No file arguments required — uses glob patterns for app/, components/, lib/, etc.
# Exits 1 if Prettier fails, 0 on success.
# ------------------------------------------------------------------------------

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_ROOT"

echo "Fixing code style issues..."
if ! npx prettier --write "app/**/*.{ts,tsx}" "components/**/*.{ts,tsx}" "lib/**/*.ts" "services/**/*.ts" "types/**/*.ts"; then
    echo "ERROR: Failed to fix code style"
    exit 1
fi
echo "Code style fixed!"

exit 0
