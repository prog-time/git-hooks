#!/bin/bash
# ------------------------------------------------------------------------------
# Validates all JSON files in the project for syntax correctness.
# Scans repository root, excluding .git/, node_modules/, _site/, tasks/.
# Delegates to check_json_validate.sh with the discovered file list.
# Exits 0 if no files found or all pass; exits 1 if any errors found.
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

mapfile -t JSON_FILES < <(find "$PROJECT_DIR" -type f -name "*.json" \
  -not -path "*/.git/*" \
  -not -path "*/node_modules/*" \
  -not -path "*/_site/*" \
  -not -path "*/tasks/*")

if [ ${#JSON_FILES[@]} -eq 0 ]; then
  echo "No JSON files found"
  exit 0
fi

exec "$SCRIPT_DIR/check_json_validate.sh" "${JSON_FILES[@]}"
