#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Stylelint passes when npx exits 0
# Expected: exit 0, success message
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "stylelint_passes"

mock_npx 0 "All good"
create_fixture "app/style.css" "body { color: red; }"

run_hook "css/check_stylelint.sh" "app/style.css"

assert_exit_code 0
assert_output_contains "Stylelint check passed"

test_passed
