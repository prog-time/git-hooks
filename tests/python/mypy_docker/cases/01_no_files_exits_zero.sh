#!/bin/bash
# ------------------------------------------------------------------------------
# Test: No files provided exits with 0
# Expected: exit 0, message about no files
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "mypy_docker_no_files"

mock_docker_running 0

run_hook "python/check_mypy_in_docker.sh"

assert_exit_code 0
assert_output_contains "No files to check"

test_passed
