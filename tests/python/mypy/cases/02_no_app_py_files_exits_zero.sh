#!/bin/bash
# ------------------------------------------------------------------------------
# Test: No app/ .py files among arguments exits with 0
# Expected: exit 0, message about no Python files
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "mypy_no_app_py_files"

mock_mypy 0

create_python_fixture "lib/helper.py" "Helper"

run_hook "python/check_mypy.sh" "lib/helper.py"

assert_exit_code 0
assert_output_contains "No Python files to check"

test_passed
