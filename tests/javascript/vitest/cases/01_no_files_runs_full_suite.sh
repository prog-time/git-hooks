#!/bin/bash
# ------------------------------------------------------------------------------
# Test: No files runs full test suite
# Expected: exit 0, message about full suite
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "vitest_no_files_full_suite"

mock_npx 0 "Tests passed"

run_hook_at_depth "javascript/check_vitest.sh" 2

assert_exit_code 0
assert_output_contains "full suite"

test_passed
