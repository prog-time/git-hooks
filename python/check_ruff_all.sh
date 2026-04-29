#!/bin/bash
# ------------------------------------------------------------------------------
# Checks all Python files in the project for style and logic errors using ruff.
# Scans repository root, excluding .git/, node_modules/, _site/, tasks/.
# Delegates to check_ruff.sh with the discovered file list.
# Exits 0 if no files found or all pass; exits 1 if any errors found.
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

mapfile -t PY_FILES < <(find "$PROJECT_DIR" -type f -name "*.py" \
  -not -path "*/.git/*" \
  -not -path "*/node_modules/*" \
  -not -path "*/_site/*" \
  -not -path "*/tasks/*")

if [ ${#PY_FILES[@]} -eq 0 ]; then
  echo "No Python files found"
  exit 0
fi

exec "$SCRIPT_DIR/check_ruff.sh" "${PY_FILES[@]}"
