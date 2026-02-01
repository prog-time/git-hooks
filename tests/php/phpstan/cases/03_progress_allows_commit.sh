#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Reducing errors allows commit (progress mode)
# Expected: exit 0 when errors decreased from baseline
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "phpstan_progress"

# Create test file
create_php_fixture "app/Service.php" "Service" "App"

# Set baseline: file had 5 errors before
echo '{"app/Service.php": 5}' > .phpstan-error-count.json

# Mock phpstan returning 3 errors (reduced from 5)
mock_phpstan 3

run_hook "php/check_phpstan.sh" "default" "app/Service.php"

assert_exit_code 0
assert_output_contains "OK"
assert_output_contains "was 5, now 3"
assert_baseline_value "app/Service.php" 3

test_passed
