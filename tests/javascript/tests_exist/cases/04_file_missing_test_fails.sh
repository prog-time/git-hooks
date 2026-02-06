#!/bin/bash
# ------------------------------------------------------------------------------
# Test: TypeScript file without matching test file fails
# Expected: exit 1, message about missing tests
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "tests_exist_missing_test"

create_fixture "app/utils.ts" "export const foo = 1;"

run_hook_at_depth "javascript/check_tests_exist.sh" 2 "app/utils.ts"

assert_exit_code 1
assert_output_contains "Missing tests"

test_passed
