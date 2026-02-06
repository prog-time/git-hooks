#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Tests fail (pytest exit 1)
# Expected: exit 1, message about tests failed
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "pytest_local_fail"

mock_pytest_cmd 1 "1 failed, 2 passed in 0.15s"

mkdir -p "tests"

run_hook "python/check_pytest.sh"

assert_exit_code 1
assert_output_contains "Tests failed"

test_passed
