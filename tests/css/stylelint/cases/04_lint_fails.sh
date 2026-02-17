#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Stylelint fails when npx exits 1
# Expected: exit 1, error message
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "stylelint_fails"

mock_npx 1 "Unexpected property"
create_fixture "app/style.css" "body { colour: red; }"

run_hook "css/check_stylelint.sh" "app/style.css"

assert_exit_code 1
assert_output_contains "ERROR: Stylelint check failed"

test_passed
