#!/bin/bash
# ------------------------------------------------------------------------------
# Test: ESLint passes when npx exits 0
# Expected: exit 0, message about issues fixed
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "eslint_all_passes"

mock_npx 0 "All good"

run_hook_at_depth "javascript/check_eslint_all.sh" 2

assert_exit_code 0
assert_output_contains "ESLint issues fixed"

test_passed
