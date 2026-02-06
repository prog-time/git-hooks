#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Container not running exits with 1
# Expected: exit 1, message about container not running
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "flake8_docker_container_stopped"

mock_docker_stopped

create_python_fixture "app/service.py" "Service"

run_hook "python/check_flake8_in_docker.sh" "app/service.py"

assert_exit_code 1
assert_output_contains "Container 'app_dev' is not running"

test_passed
