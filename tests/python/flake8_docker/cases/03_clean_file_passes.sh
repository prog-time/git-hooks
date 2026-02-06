#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Clean file passes in Docker
# Expected: exit 0, message about check passed
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "flake8_docker_clean_file"

mock_docker_running 0

create_python_fixture "app/clean.py" "CleanClass"

run_hook "python/check_flake8_in_docker.sh" "app/clean.py"

assert_exit_code 0
assert_output_contains "Code style check passed"

test_passed
