#!/bin/bash
# ------------------------------------------------------------------------------
# Test: ESLint fails when npx exits 1
# Expected: exit 1, error message
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "eslint_all_fails"

mock_npx 1 "Lint errors found"

run_hook_at_depth "javascript/check_eslint_all.sh" 2

assert_exit_code 1
assert_output_contains "ERROR"

test_passed
