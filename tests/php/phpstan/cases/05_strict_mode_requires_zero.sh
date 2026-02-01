#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Strict mode requires zero errors
# Expected: exit 1 when any errors exist in strict mode
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "phpstan_strict"

# Create test file
create_php_fixture "app/Service.php" "Service" "App"

# Mock phpstan returning 1 error
mock_phpstan 1

run_hook "php/check_phpstan.sh" "strict" "app/Service.php"

assert_exit_code 1
assert_output_contains "Too many errors"

test_passed
