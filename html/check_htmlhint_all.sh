#!/bin/bash
# ----------------------------------------
# HTML Code Checker (Full Project)
#
# This script checks all HTML files in the
# project for issues using HTMLHint.
# Used in pre-push-check.sh
#
# Usage:
#   ./check_htmlhint_all.sh
# ----------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

HTML_FILES=$(find "$PROJECT_DIR" -name "*.html" -not -path "*/_site/*" -not -path "*/node_modules/*" -not -path "*/.git/*")

if [ -z "$HTML_FILES" ]; then
    echo "No HTML files found"
    exit 0
fi

# shellcheck disable=SC2086
exec "$SCRIPT_DIR/check_htmlhint.sh" $HTML_FILES
