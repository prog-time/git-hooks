#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Service file with matching test passes
# Expected: exit 0, message about all checks passed
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "find_test_service_with_test"

create_python_fixture "app/services/user_service.py" "UserService"
create_python_fixture "tests/services/test_user_service.py" "TestUserService"

run_hook "python/find_test.sh" "app/services/user_service.py"

assert_exit_code 0
assert_output_contains "All checks passed"

test_passed
