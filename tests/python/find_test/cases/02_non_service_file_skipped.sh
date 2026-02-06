#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Non-service file is skipped
# Expected: exit 0, message about no service files
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "find_test_non_service"

create_python_fixture "app/models/user.py" "User"

run_hook "python/find_test.sh" "app/models/user.py"

assert_exit_code 0
assert_output_contains "No service files to check"

test_passed
