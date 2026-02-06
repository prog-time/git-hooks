#!/bin/bash
# ------------------------------------------------------------------------------
# Runs vitest for specified files or the full suite. Supports --watch and --coverage.
# Receives files as arguments: ./check_vitest.sh file1.ts [--watch] [--coverage]
# Exits 1 if tests fail, 0 on success. Runs full suite when no files provided.
# ------------------------------------------------------------------------------

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_ROOT"

# Parse arguments
WATCH=false
COVERAGE=false
FILES=()

for arg in "$@"; do
    case $arg in
        --watch)
            WATCH=true
            ;;
        --coverage)
            COVERAGE=true
            ;;
        *)
            FILES+=("$arg")
            ;;
    esac
done

# Filter only test files or source files that have tests
RELEVANT_FILES=()
for file in "${FILES[@]}"; do
    if [[ "$file" == *.ts ]]; then
        if [ -f "$file" ]; then
            RELEVANT_FILES+=("$file")
        fi
    fi
done

# Determine test command
if [ ${#RELEVANT_FILES[@]} -eq 0 ]; then
    echo "=== Tests (full suite) ==="

    if [ "$WATCH" = true ]; then
        echo "Running tests in watch mode..."
        npx vitest
    elif [ "$COVERAGE" = true ]; then
        echo "Running tests with coverage..."
        if ! npx vitest run --coverage; then
            echo "ERROR: Tests failed"
            exit 1
        fi
        echo "Tests passed with coverage!"
    else
        echo "Running tests..."
        if ! npx vitest run; then
            echo "ERROR: Tests failed"
            exit 1
        fi
        echo "Tests passed!"
    fi
else
    echo "=== Tests (related to ${#RELEVANT_FILES[@]} changed files) ==="

    if [ "$WATCH" = true ]; then
        echo "Running related tests in watch mode..."
        npx vitest --related "${RELEVANT_FILES[@]}"
    elif [ "$COVERAGE" = true ]; then
        echo "Running related tests with coverage..."
        if ! npx vitest run --related "${RELEVANT_FILES[@]}" --coverage; then
            echo "ERROR: Tests failed"
            exit 1
        fi
        echo "Tests passed with coverage!"
    else
        echo "Running related tests..."
        if ! npx vitest run --related "${RELEVANT_FILES[@]}"; then
            echo "ERROR: Tests failed"
            exit 1
        fi
        echo "Tests passed!"
    fi
fi

exit 0
