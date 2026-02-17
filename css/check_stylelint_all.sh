#!/bin/bash
# ----------------------------------------
# CSS Code Style Checker (Full Project)
#
# This script checks all CSS/SCSS/Less files
# in the project for style issues using Stylelint.
# Used in pre-push-check.sh
#
# Usage:
#   ./check_stylelint_all.sh
# ----------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

STYLE_FILES=$(find "$PROJECT_DIR" -type f \( -name "*.css" -o -name "*.scss" -o -name "*.less" \) -not -path "*/_site/*" -not -path "*/node_modules/*" -not -path "*/.git/*")

if [ -z "$STYLE_FILES" ]; then
    echo "No CSS/SCSS/Less files found"
    exit 0
fi

# shellcheck disable=SC2086
exec "$SCRIPT_DIR/check_stylelint.sh" $STYLE_FILES
