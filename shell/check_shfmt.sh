#!/bin/bash
# ------------------------------------------------------------------------------
# Checks shell scripts for formatting issues using shfmt.
# Accepts file paths as arguments; skips non-.sh files and missing files.
# Exits 1 with an install hint if shfmt is not installed.
# Exits 1 and shows a diff if any script is not properly formatted.
# ------------------------------------------------------------------------------

if [ $# -eq 0 ]; then
  echo "No files to check"
  exit 0
fi

if ! command -v shfmt > /dev/null 2>&1; then
  echo "ERROR: shfmt is not installed."
  echo "Install it with: go install mvdan.cc/sh/v3/cmd/shfmt@latest"
  echo "Or: brew install shfmt"
  exit 1
fi

SH_FILES=()
CHECKED_FILES=0
HAS_ERRORS=0

for file in "$@"; do
  if [[ ! "$file" =~ \.sh$ ]]; then
    continue
  fi

  if [ ! -f "$file" ]; then
    continue
  fi

  SH_FILES+=("$file")
done

if [ ${#SH_FILES[@]} -eq 0 ]; then
  echo "No shell files to check"
  exit 0
fi

for file in "${SH_FILES[@]}"; do
  CHECKED_FILES=$((CHECKED_FILES + 1))

  OUTPUT=$(shfmt -d -i 2 -ci "$file" 2>&1)
  EXIT_CODE=$?

  if [ $EXIT_CODE -ne 0 ] || [ -n "$OUTPUT" ]; then
    HAS_ERRORS=1
    echo "shfmt formatting issues in: $file"
    echo "$OUTPUT"
    echo ""
  fi
done

if [ $HAS_ERRORS -ne 0 ]; then
  echo "----------------------------------------"
  echo "ERROR: shfmt check failed!"
  echo "Total files checked: $CHECKED_FILES"
  echo "Run 'shfmt -w -i 2 -ci <file>' to auto-fix."
  exit 1
fi

echo "shfmt check passed! ($CHECKED_FILES files checked)"
exit 0
