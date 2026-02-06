#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Non-TypeScript files are ignored
# Expected: exit 0, message about no staged TypeScript files
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "tests_exist_non_ts_ignored"

create_fixture "app/utils.js" "export const foo = 1;"

run_hook_at_depth "javascript/check_tests_exist.sh" 2 "app/utils.js"

assert_exit_code 0
assert_output_contains "All files have tests"

test_passed
