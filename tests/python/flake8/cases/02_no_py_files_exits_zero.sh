#!/bin/bash
# ------------------------------------------------------------------------------
# Test: No .py files among arguments exits with 0
# Expected: exit 0, message about no Python files
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "flake8_no_py_files"

mock_flake8 0

create_fixture "readme.md" "# Readme"

run_hook "python/check_flake8.sh" "readme.md"

assert_exit_code 0
assert_output_contains "No Python files to check"

test_passed
