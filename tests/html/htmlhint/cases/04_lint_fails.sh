#!/bin/bash
# ------------------------------------------------------------------------------
# Test: HTMLHint fails when npx exits 1
# Expected: exit 1, error message
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "htmlhint_fails"

mock_npx 1 "Tag not paired"
create_fixture "app/index.html" "<html><body>"

run_hook "html/check_htmlhint.sh" "app/index.html"

assert_exit_code 1
assert_output_contains "ERROR: HTMLHint check failed"

test_passed
