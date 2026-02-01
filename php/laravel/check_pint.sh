#!/bin/bash
# ------------------------------------------------------------------------------
# Runs Laravel Pint code style checker on PHP files.
# Accepts list of file paths as arguments, filters only .php files.
# Auto-fixes style issues and stages corrected files for commit.
# Always exits with 0 (non-blocking hook).
# ------------------------------------------------------------------------------

if [ $# -eq 0 ]; then
    echo "[Pint] No PHP files to check."
    exit 0
fi

FILES=()
for f in "$@"; do
    [[ "$f" == *.php ]] && FILES+=("$f")
done

if [ ${#FILES[@]} -eq 0 ]; then
    echo "[Pint] No PHP files to check."
    exit 0
fi

# -----------------------------
# Run Pint in test mode
# -----------------------------
vendor/bin/pint --test "${FILES[@]}"
RESULT=$?

if [ $RESULT -ne 0 ]; then
    echo "Pint found code style issues. Auto-fixing..."
    vendor/bin/pint "${FILES[@]}"
    git add "${FILES[@]}"
    echo "[Pint] Code style fixed automatically."
else
    echo "[Pint] All files pass code style."
fi

exit 0
