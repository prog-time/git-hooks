#!/bin/bash
# ------------------------------------------------------------------------------
# Checks Python files for style and logic errors using ruff.
# Accepts file paths as arguments; skips non-.py files and missing files.
# Exits 1 with an install hint if ruff is not installed.
# Exits 1 if ruff reports any issues; exits 0 on success.
# ------------------------------------------------------------------------------

if [ $# -eq 0 ]; then
  echo "No files to check"
  exit 0
fi

if ! command -v ruff > /dev/null 2>&1; then
  echo "ERROR: ruff is not installed."
  echo "Install it with: pip install ruff"
  exit 1
fi

PY_FILES=()
CHECKED_FILES=0
HAS_ERRORS=0

for file in "$@"; do
  if [[ ! "$file" =~ \.py$ ]]; then
    continue
  fi

  if [ ! -f "$file" ]; then
    continue
  fi

  PY_FILES+=("$file")
done

if [ ${#PY_FILES[@]} -eq 0 ]; then
  echo "No Python files to check"
  exit 0
fi

for file in "${PY_FILES[@]}"; do
  CHECKED_FILES=$((CHECKED_FILES + 1))

  OUTPUT=$(ruff check "$file" 2>&1)
  EXIT_CODE=$?

  if [ $EXIT_CODE -ne 0 ]; then
    HAS_ERRORS=1
    echo "ruff errors in: $file"
    echo "$OUTPUT"
    echo ""
  fi
done

if [ $HAS_ERRORS -ne 0 ]; then
  echo "----------------------------------------"
  echo "ERROR: ruff check failed!"
  echo "Total files checked: $CHECKED_FILES"
  echo "Fix the errors above before committing."
  exit 1
fi

echo "ruff check passed! ($CHECKED_FILES files checked)"
exit 0
