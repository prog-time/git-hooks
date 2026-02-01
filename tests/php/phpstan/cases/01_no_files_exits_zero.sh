#!/bin/bash
# ------------------------------------------------------------------------------
# Test: No files provided exits with 0
# Expected: exit 0, message about no files
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "phpstan_no_files"

mock_phpstan 0

run_hook "php/check_phpstan.sh" "default"

assert_exit_code 0
assert_output_contains "No PHP files to check"

test_passed
