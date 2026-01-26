#!/bin/bash

STRICTNESS="$1"
shift 1

FILES=("$@")
BASELINE_FILE=".phpstan-error-count.json"
LOCK_FILE=".phpstan-error-count.lock"
BLOCK_COMMIT=0
BASELINE_UPDATED=0

lock_baseline() {
    local timeout=30
    local elapsed=0
    while [ -f "$LOCK_FILE" ] && [ $elapsed -lt $timeout ]; do
        sleep 0.1
        elapsed=$((elapsed + 1))
    done

    if [ $elapsed -ge $timeout ]; then
        echo "ERROR: Could not acquire lock after ${timeout}s"
        exit 1
    fi

    touch "$LOCK_FILE"
}

unlock_baseline() {
    rm -f "$LOCK_FILE"
}

trap unlock_baseline EXIT

# Init baseline
if [ ! -f "$BASELINE_FILE" ] || [ ! -s "$BASELINE_FILE" ]; then
    echo '{}' > "$BASELINE_FILE"
fi

if ! jq empty "$BASELINE_FILE" 2>/dev/null; then
    echo '{}' > "$BASELINE_FILE"
fi

if [ ${#FILES[@]} -eq 0 ]; then
    echo "[PHPStan] No PHP files to check."
    exit 0
fi

for FILE in "${FILES[@]}"; do
    if [ ! -f "$FILE" ]; then
        continue
    fi

    echo "Checking: $FILE"

    ERR_NEW=$(vendor/bin/phpstan analyse --error-format=raw --no-progress "$FILE" 2>/dev/null | grep -c '^')

    lock_baseline
    ERR_OLD=$(jq -r --arg file "$FILE" '.[$file] // empty' "$BASELINE_FILE" 2>/dev/null)
    unlock_baseline

    IS_NEW_FILE=0
    if [ -z "$ERR_OLD" ]; then
        IS_NEW_FILE=1
        ERR_OLD=$ERR_NEW
    fi

    if [ "$STRICTNESS" = "strict" ]; then
        TARGET=0
    else
        # Для следующего коммита требуем хотя бы на 1 ошибку меньше
        TARGET=$((ERR_OLD - 1))
        [ "$TARGET" -lt 0 ] && TARGET=0
    fi

    SHOULD_UPDATE=0

    if [ "$IS_NEW_FILE" -eq 1 ] && [ "$ERR_NEW" -gt 0 ]; then
        echo "  New file: $ERR_NEW errors found"
        vendor/bin/phpstan analyse --no-progress --error-format=table "$FILE"
        echo "  → Baseline set to $ERR_NEW errors. Fix at least 1 error before next commit."
        SHOULD_UPDATE=1
        BLOCK_COMMIT=1
    elif [ "$ERR_NEW" -le "$TARGET" ]; then
        echo "  ✓ Progress: $ERR_OLD → $ERR_NEW errors"
        SHOULD_UPDATE=1
    else
        if [ "$ERR_NEW" -eq "$ERR_OLD" ]; then
            echo "  ✗ No progress: still $ERR_NEW errors (need ≤ $TARGET)"
        else
            echo "  ✗ Errors increased: $ERR_OLD → $ERR_NEW (need ≤ $TARGET)"
        fi
        vendor/bin/phpstan analyse --no-progress --error-format=table "$FILE"
        BLOCK_COMMIT=1
        # НЕ обновляем baseline
    fi

    if [ "$SHOULD_UPDATE" -eq 1 ]; then
        lock_baseline

        if jq --arg file "$FILE" --argjson errors "$ERR_NEW" \
            '.[$file] = $errors' "$BASELINE_FILE" > "$BASELINE_FILE.tmp" 2>/dev/null; then
            mv "$BASELINE_FILE.tmp" "$BASELINE_FILE"
            BASELINE_UPDATED=1
        else
            rm -f "$BASELINE_FILE.tmp"
        fi

        unlock_baseline
    fi

    echo ""
done

if [ "$BASELINE_UPDATED" -eq 1 ]; then
    git add "$BASELINE_FILE" 2>/dev/null
fi

if [ "$BLOCK_COMMIT" -eq 1 ]; then
    echo "Commit blocked. Reduce error count to proceed!"
    exit 1
fi

echo "[PHPStan] All checks passed!"
exit 0
