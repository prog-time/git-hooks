#!/bin/bash
# ------------------------------------------------------------------------------
# Test: File with style errors fails
# Expected: exit 1, message about check failed
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "flake8_file_with_errors"

mock_flake8 1 "app/bad.py:1:1: E302 expected 2 blank lines"

create_python_fixture "app/bad.py" "BadClass"

run_hook "python/check_flake8.sh" "app/bad.py"

assert_exit_code 1
assert_output_contains "Code style check failed"

test_passed
