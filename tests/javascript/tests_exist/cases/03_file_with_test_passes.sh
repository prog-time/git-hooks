#!/bin/bash
# ------------------------------------------------------------------------------
# Test: TypeScript file with matching test file passes
# Expected: exit 0, message about all files having tests
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "tests_exist_file_with_test"

create_fixture "app/utils.ts" "export const foo = 1;"
create_fixture "tests/app/utils.test.ts" "test('foo', () => {});"

run_hook_at_depth "javascript/check_tests_exist.sh" 2 "app/utils.ts"

assert_exit_code 0
assert_output_contains "All files have tests"

test_passed
