#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Files matching skip patterns are skipped
# Expected: exit 0, file listed as skipped
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "tests_exist_skip_patterns"

create_fixture "app/next.config.ts" "export default {};"

run_hook_at_depth "javascript/check_tests_exist.sh" 2 "app/next.config.ts"

assert_exit_code 0
assert_output_contains "Skipped"

test_passed
