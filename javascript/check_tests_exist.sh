#!/bin/bash
# ------------------------------------------------------------------------------
# Checks that each staged TypeScript source file has a corresponding test file.
# Receives files as arguments or reads from git staged files if none provided.
# Exits 1 if any source file is missing its tests/...test.ts counterpart.
# ------------------------------------------------------------------------------

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_ROOT"

# Patterns to skip (no tests required)
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

echo "=== Test Coverage Check ==="
echo ""

missing=()
found=()
skipped=()

for file in "${FILES[@]}"; do
    [ ! -f "$file" ] && continue
    should_skip "$file" && { skipped+=("$file"); continue; }

    test_path=$(get_test_path "$file")

    if [ -f "$test_path" ]; then
        found+=("$file")
    else
        missing+=("$file → $test_path")
    fi
done

[ ${#found[@]} -gt 0 ] && echo -e "Has tests:" && printf '  %s\n' "${found[@]}" && echo ""
[ ${#skipped[@]} -gt 0 ] && echo -e "Skipped:" && printf '  %s\n' "${skipped[@]}" && echo ""

if [ ${#missing[@]} -gt 0 ]; then
    echo -e "Missing tests:"
    printf '  %s\n' "${missing[@]}"
    echo ""
    echo -e "ERROR: ${#missing[@]} file(s) missing tests"
    exit 1
fi

echo -e "All files have tests!"
