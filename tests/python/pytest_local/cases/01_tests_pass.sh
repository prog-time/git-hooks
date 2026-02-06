#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Tests pass (pytest exit 0)
# Expected: exit 0, message about all tests passed
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "pytest_local_pass"

mock_pytest_cmd 0 "3 passed in 0.12s"

mkdir -p "tests"

run_hook "python/check_pytest.sh"

assert_exit_code 0
assert_output_contains "All tests passed"

test_passed
