#!/bin/bash
# ------------------------------------------------------------------------------
# Checks all shell scripts in the project for formatting issues using shfmt.
# Scans repository root, excluding .git/, node_modules/, _site/, tasks/.
# Delegates to check_shfmt.sh with the discovered file list.
# Exits 0 if no files found or all pass; exits 1 if any errors found.
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

mapfile -t SH_FILES < <(find "$PROJECT_DIR" -type f -name "*.sh" \
  -not -path "*/.git/*" \
  -not -path "*/node_modules/*" \
  -not -path "*/_site/*" \
  -not -path "*/tasks/*")

if [ ${#SH_FILES[@]} -eq 0 ]; then
  echo "No shell files found"
  exit 0
fi

exec "$SCRIPT_DIR/check_shfmt.sh" "${SH_FILES[@]}"
