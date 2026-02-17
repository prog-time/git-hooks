#!/bin/bash
# ----------------------------------------
# Markdown Code Style Checker (Full Project)
#
# This script checks all Markdown files in the
# project for style issues using markdownlint.
# Used in pre-push-check.sh
#
# Usage:
#   ./check_markdownlint_all.sh
# ----------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

MD_FILES=$(find "$PROJECT_DIR" -name "*.md" -not -path "*/_site/*" -not -path "*/node_modules/*" -not -path "*/.git/*")

if [ -z "$MD_FILES" ]; then
    echo "No Markdown files found"
    exit 0
fi

# shellcheck disable=SC2086
exec "$SCRIPT_DIR/check_markdownlint.sh" $MD_FILES
