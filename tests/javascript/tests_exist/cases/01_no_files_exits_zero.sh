#!/bin/bash
# ------------------------------------------------------------------------------
# Test: No files provided and no staged files exits with 0
# Expected: exit 0, message about no staged TypeScript files
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "tests_exist_no_files"

run_hook_at_depth "javascript/check_tests_exist.sh" 2

assert_exit_code 0
assert_output_contains "No staged TypeScript files"

test_passed
