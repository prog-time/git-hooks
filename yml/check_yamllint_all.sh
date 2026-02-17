#!/bin/bash
# ----------------------------------------
# YAML Code Style Checker (Full Project)
#
# This script checks all YAML files
# in the project for style issues using yamllint.
# Used in pre-push-check.sh
#
# Usage:
#   ./check_yamllint_all.sh
# ----------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

YAML_FILES=$(find "$PROJECT_DIR" -type f \( -name "*.yml" -o -name "*.yaml" \) -not -path "*/_site/*" -not -path "*/node_modules/*" -not -path "*/.git/*")

if [ -z "$YAML_FILES" ]; then
    echo "No YAML files found"
    exit 0
fi

# shellcheck disable=SC2086
exec "$SCRIPT_DIR/check_yamllint.sh" $YAML_FILES
