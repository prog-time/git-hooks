#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Clean file passes mypy check
# Expected: exit 0, message about analysis passed
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "mypy_clean_file"

mock_mypy 0 "Success: no issues found"

create_python_fixture "app/clean.py" "CleanClass"

run_hook "python/check_mypy.sh" "app/clean.py"

assert_exit_code 0
assert_output_contains "Static analysis passed"

test_passed
