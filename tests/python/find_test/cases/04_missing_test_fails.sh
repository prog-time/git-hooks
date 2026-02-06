#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Service file without matching test fails
# Expected: exit 1, message about missing tests
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "find_test_missing_test"

create_python_fixture "app/services/payment_service.py" "PaymentService"

run_hook "python/find_test.sh" "app/services/payment_service.py"

assert_exit_code 1
assert_output_contains "Missing tests"

test_passed
