#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Test failure exits with 1
# Expected: exit 1, error message
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "vitest_failure_exits_one"

mock_npx 1 "Test failed"

run_hook_at_depth "javascript/check_vitest.sh" 2

assert_exit_code 1
assert_output_contains "ERROR"

test_passed
