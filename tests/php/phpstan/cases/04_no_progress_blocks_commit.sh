#!/bin/bash
# ------------------------------------------------------------------------------
# Test: No progress blocks commit
# Expected: exit 1 when errors not reduced enough
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "phpstan_no_progress"

# Create test file
create_php_fixture "app/Service.php" "Service" "App"

# Set baseline: file had 5 errors before
echo '{"app/Service.php": 5}' > .phpstan-error-count.json

# Mock phpstan returning 5 errors (same as before - no progress)
mock_phpstan 5

run_hook "php/check_phpstan.sh" "default" "app/Service.php"

assert_exit_code 1
assert_output_contains "Too many errors"

test_passed
