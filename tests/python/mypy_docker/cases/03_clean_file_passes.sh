#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Clean file passes in Docker
# Expected: exit 0, message about analysis passed
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "mypy_docker_clean_file"

mock_docker_running 0 "Success: no issues found"

create_python_fixture "app/clean.py" "CleanClass"

run_hook "python/check_mypy_in_docker.sh" "app/clean.py"

assert_exit_code 0
assert_output_contains "Static analysis passed"

test_passed
