#!/bin/bash
# ------------------------------------------------------------------------------
# Runs vitest for changed TypeScript files or from git staged files.
# Receives files as arguments: ./check_tests.sh file1.ts file2.ts
# Exits 1 if tests fail, 0 on success. Skips files matching SKIP_PATTERNS.
# ------------------------------------------------------------------------------

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_ROOT"

# Patterns to skip
SKIP_PATTERNS=("tests/" ".test.ts" ".config.ts" ".config.mjs" "types/" ".d.ts" "layout.tsx" "page.tsx" "loading.tsx" "error.tsx" "globals.css" "providers/" "components/ui/" "prisma/")

should_skip() {
    local file="$1"
    for pattern in "${SKIP_PATTERNS[@]}"; do
        [[ "$file" == *"$pattern"* ]] && return 0
    done
    return 1
}

# Get test path: source.ts -> tests/source.test.ts
get_test_path() {
    local file="$1"
    local base="${file%.ts}"
    base="${base%.tsx}"
    echo "tests/${base}.test.ts"
}

# Get files to check
FILES=()
if [ $# -eq 0 ]; then
    while IFS= read -r line; do
        [[ "$line" == *.ts || "$line" == *.tsx ]] && FILES+=("$line")
    done < <(git diff --cached --name-only --diff-filter=ACM 2>/dev/null || true)
    [ ${#FILES[@]} -eq 0 ] && echo "No staged TypeScript files" && exit 0
else
    for arg in "$@"; do
        [[ "$arg" == *.ts || "$arg" == *.tsx ]] && FILES+=("$arg")
    done
fi

# Collect tests to run
TESTS_TO_RUN=()

for file in "${FILES[@]}"; do
    [ ! -f "$file" ] && continue

    # If it's already a test file, add it directly
    if [[ "$file" == *.test.ts ]]; then
        [ -f "$file" ] && TESTS_TO_RUN+=("$file")
        continue
    fi

    should_skip "$file" && continue

    test_path=$(get_test_path "$file")
    [ -f "$test_path" ] && TESTS_TO_RUN+=("$test_path")
done

# Remove duplicates
mapfile -t TESTS_TO_RUN < <(printf '%s\n' "${TESTS_TO_RUN[@]}" | sort -u)

if [ ${#TESTS_TO_RUN[@]} -eq 0 ]; then
    echo "No tests to run for changed files"
    exit 0
fi

echo "=== Running tests for changed files ==="
echo "Tests: ${TESTS_TO_RUN[*]}"
echo ""

npx vitest run "${TESTS_TO_RUN[@]}"
