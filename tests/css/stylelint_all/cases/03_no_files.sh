#!/bin/bash
# ------------------------------------------------------------------------------
# Test: No CSS files in project exits with 0
# Expected: exit 0, message about no files found
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "stylelint_all_no_files"

REPO_DIR="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
cp "$REPO_DIR/css/check_stylelint.sh" "$TEST_DIR/check_stylelint.sh"
cp "$REPO_DIR/css/check_stylelint_all.sh" "$TEST_DIR/check_stylelint_all.sh"
sed -i '' "s|PROJECT_DIR=.*|PROJECT_DIR=\"$TEST_DIR\"|" "$TEST_DIR/check_stylelint_all.sh"
chmod +x "$TEST_DIR/check_stylelint.sh" "$TEST_DIR/check_stylelint_all.sh"

set +e
# shellcheck disable=SC2034
LAST_OUTPUT=$("$TEST_DIR/check_stylelint_all.sh" 2>&1)
# shellcheck disable=SC2034
LAST_EXIT_CODE=$?
set -e

assert_exit_code 0
assert_output_contains "No CSS/SCSS/Less files found"

test_passed
