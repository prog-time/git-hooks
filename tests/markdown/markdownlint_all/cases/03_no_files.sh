#!/bin/bash
# ------------------------------------------------------------------------------
# Test: No Markdown files in project exits with 0
# Expected: exit 0, message about no files found
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "markdownlint_all_no_files"

REPO_DIR="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
cp "$REPO_DIR/markdown/check_markdownlint.sh" "$TEST_DIR/check_markdownlint.sh"
cp "$REPO_DIR/markdown/check_markdownlint_all.sh" "$TEST_DIR/check_markdownlint_all.sh"
sed -i.bak "s|PROJECT_DIR=.*|PROJECT_DIR=\"$TEST_DIR\"|" "$TEST_DIR/check_markdownlint_all.sh" && rm -f "$TEST_DIR/check_markdownlint_all.sh.bak"
chmod +x "$TEST_DIR/check_markdownlint.sh" "$TEST_DIR/check_markdownlint_all.sh"

set +e
# shellcheck disable=SC2034
LAST_OUTPUT=$("$TEST_DIR/check_markdownlint_all.sh" 2>&1)
# shellcheck disable=SC2034
LAST_EXIT_CODE=$?
set -e

assert_exit_code 0
assert_output_contains "No Markdown files found"

test_passed
