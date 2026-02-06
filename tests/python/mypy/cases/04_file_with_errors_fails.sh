#!/bin/bash
# ------------------------------------------------------------------------------
# Test: File with type errors fails
# Expected: exit 1, message about analysis failed
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "mypy_file_with_errors"

mock_mypy 1 "app/bad.py:1: error: Incompatible return type"

create_python_fixture "app/bad.py" "BadClass"

run_hook "python/check_mypy.sh" "app/bad.py"

assert_exit_code 1
assert_output_contains "Static analysis failed"

test_passed
