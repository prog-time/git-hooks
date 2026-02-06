#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Duplicate test files violate 1-service-1-test rule
# Expected: exit 1, message about 1 service = 1 test file
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "find_test_duplicate"

create_python_fixture "app/services/order_service.py" "OrderService"
create_python_fixture "tests/services/test_order_service.py" "TestOrderService"
create_python_fixture "tests/services/test_order_service_v2.py" "TestOrderServiceV2"

run_hook "python/find_test.sh" "app/services/order_service.py"

assert_exit_code 1
assert_output_contains "1 service = 1 test file"

test_passed
