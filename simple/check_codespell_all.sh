#!/bin/bash
# ------------------------------------------------------------------------------
# Checks all files in the project for spelling mistakes using codespell.
# Scans repository root, excluding .git/, node_modules/, _site/, tasks/.
# Delegates to check_codespell.sh with the discovered file list.
# Exits 0 if no files found or all pass; exits 1 if any errors found.
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

mapfile -t FILES < <(find "$PROJECT_DIR" -type f \
  -not -path "*/.git/*" \
  -not -path "*/node_modules/*" \
  -not -path "*/_site/*" \
  -not -path "*/tasks/*")

if [ ${#FILES[@]} -eq 0 ]; then
  echo "No files found"
  exit 0
fi

exec "$SCRIPT_DIR/check_codespell.sh" "${FILES[@]}"
