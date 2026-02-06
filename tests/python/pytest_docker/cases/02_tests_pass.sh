#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Tests pass in Docker
# Expected: exit 0, message about all tests passed
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "pytest_docker_pass"

mock_docker_running 0 "3 passed in 0.12s"

run_hook "python/check_pytest_in_docker.sh"

assert_exit_code 0
assert_output_contains "All tests passed"

test_passed
