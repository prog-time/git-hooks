#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Passing .ts files runs related tests
# Expected: exit 0, message about related files
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "vitest_ts_files_related"

mock_npx 0 "Tests passed"

create_fixture "app/utils.ts" "export const foo = 1;"

run_hook_at_depth "javascript/check_vitest.sh" 2 "app/utils.ts"

assert_exit_code 0
assert_output_contains "related"

test_passed
