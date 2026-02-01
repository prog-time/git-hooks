#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Clean file with no errors passes
# Expected: exit 0, baseline updated with 0 errors
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "phpstan_clean_file"

# Create test file
create_php_fixture "app/Clean.php" "CleanClass" "App"

# Mock phpstan returning 0 errors
mock_phpstan 0

run_hook "php/check_phpstan.sh" "default" "app/Clean.php"

assert_exit_code 0
assert_output_contains "OK"
assert_baseline_value "app/Clean.php" 0

test_passed
