#!/bin/bash
# ------------------------------------------------------------------------------
# Validates JSON files for syntax correctness using python3 -m json.tool.
# Accepts file paths as arguments; skips non-.json files and missing files.
# Exits 1 if any file contains invalid JSON; exits 0 if all pass.
# ------------------------------------------------------------------------------

if [ $# -eq 0 ]; then
  echo "No files to check"
  exit 0
fi

JSON_FILES=()
CHECKED_FILES=0
HAS_ERRORS=0

for file in "$@"; do
  if [[ ! "$file" =~ \.json$ ]]; then
    continue
  fi

  if [ ! -f "$file" ]; then
    continue
  fi

  JSON_FILES+=("$file")
done

if [ ${#JSON_FILES[@]} -eq 0 ]; then
  echo "No JSON files to check"
  exit 0
fi

for file in "${JSON_FILES[@]}"; do
  CHECKED_FILES=$((CHECKED_FILES + 1))

  if ! python3 -m json.tool "$file" > /dev/null 2>&1; then
    HAS_ERRORS=1
    echo "JSON parse error in: $file"
    python3 -m json.tool "$file" 2>&1 || true
    echo ""
  fi
done

if [ $HAS_ERRORS -ne 0 ]; then
  echo "----------------------------------------"
  echo "ERROR: JSON validation failed!"
  echo "Total files checked: $CHECKED_FILES"
  echo "Fix the errors above before committing."
  exit 1
fi

echo "JSON validation passed! ($CHECKED_FILES files checked)"
exit 0
