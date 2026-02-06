#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Clean file passes flake8 check
# Expected: exit 0, message about check passed
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "flake8_clean_file"

mock_flake8 0

create_python_fixture "app/clean.py" "CleanClass"

run_hook "python/check_flake8.sh" "app/clean.py"

assert_exit_code 0
assert_output_contains "Code style check passed"

test_passed
