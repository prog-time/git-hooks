#!/bin/bash
# ------------------------------------------------------------------------------
# Checks files for spelling mistakes using codespell.
# Accepts file paths as arguments; skips files that don't exist.
# Exits 1 if any spelling errors are found; exits 0 on success.
# Exits 1 with an install hint if codespell is not installed.
# ------------------------------------------------------------------------------

if [ $# -eq 0 ]; then
  echo "No files to check"
  exit 0
fi

if ! command -v codespell > /dev/null 2>&1; then
  echo "ERROR: codespell is not installed."
  echo "Install it with: pip install codespell"
  exit 1
fi

FILES=()

for file in "$@"; do
  if [ ! -f "$file" ]; then
    continue
  fi
  FILES+=("$file")
done

if [ ${#FILES[@]} -eq 0 ]; then
  echo "No files to check"
  exit 0
fi

OUTPUT=$(codespell "${FILES[@]}" 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
  echo "ERROR: Spelling check failed!"
  echo "$OUTPUT"
  echo "Fix the spelling errors above before committing."
  exit 1
fi

echo "Spelling check passed! (${#FILES[@]} files checked)"
exit 0
