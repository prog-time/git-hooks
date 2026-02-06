#!/bin/bash
# ------------------------------------------------------------------------------
# Runs Prettier --write on staged TypeScript files.
# Receives files to check as arguments: ./check_prettier.sh file1.ts file2.ts
# Exits 1 if Prettier fails, 0 on success. Skips if no .ts files provided.
# ------------------------------------------------------------------------------

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_ROOT"

# Parse arguments
FILES=()

# Filter only .ts files
RELEVANT_FILES=()
for file in "${FILES[@]}"; do
    if [[ "$file" == *.ts ]]; then
        if [ -f "$file" ]; then
            RELEVANT_FILES+=("$file")
        fi
    fi
done

# Skip if no relevant files
if [ ${#RELEVANT_FILES[@]} -eq 0 ]; then
    echo "=== Code Style Check ==="
    echo "No TypeScript files to check, skipping..."
    exit 0
fi

echo "=== Code Style Check (${#RELEVANT_FILES[@]} files) ==="

echo "Fixing code style issues..."
if ! npx prettier --write "${RELEVANT_FILES[@]}"; then
    echo "ERROR: Failed to fix code style"
    exit 1
fi
echo "Code style fixed!"

exit 0
