#!/bin/bash
# ------------------------------------------------------------------------------
# Test: HTMLHint passes when npx exits 0
# Expected: exit 0, success message
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "htmlhint_passes"

mock_npx 0 "All good"
create_fixture "app/index.html" "<html><body></body></html>"

run_hook "html/check_htmlhint.sh" "app/index.html"

assert_exit_code 0
assert_output_contains "HTMLHint check passed"

test_passed
