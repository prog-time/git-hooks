#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Stylelint all passes when npx exits 0
# Expected: exit 0, success message
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "stylelint_all_passes"

mock_npx 0 "All good"
create_fixture "app/style.css" "body { color: red; }"

# Copy both scripts and patch PROJECT_DIR to point to TEST_DIR
REPO_DIR="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
cp "$REPO_DIR/css/check_stylelint.sh" "$TEST_DIR/check_stylelint.sh"
cp "$REPO_DIR/css/check_stylelint_all.sh" "$TEST_DIR/check_stylelint_all.sh"
sed -i.bak "s|PROJECT_DIR=.*|PROJECT_DIR=\"$TEST_DIR\"|" "$TEST_DIR/check_stylelint_all.sh" && rm -f "$TEST_DIR/check_stylelint_all.sh.bak"
chmod +x "$TEST_DIR/check_stylelint.sh" "$TEST_DIR/check_stylelint_all.sh"

set +e
# shellcheck disable=SC2034
LAST_OUTPUT=$("$TEST_DIR/check_stylelint_all.sh" 2>&1)
# shellcheck disable=SC2034
LAST_EXIT_CODE=$?
set -e

assert_exit_code 0
assert_output_contains "Stylelint check passed"

test_passed
