#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Non-existent file is skipped
# Expected: exit 0, message about no Python files
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "flake8_nonexistent_file"

mock_flake8 0

run_hook "python/check_flake8.sh" "nonexistent.py"

assert_exit_code 0
assert_output_contains "No Python files to check"

test_passed
