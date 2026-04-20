#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Invalid JSON file fails validation
# Expected: exit 1, error message about JSON validation
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "json_validate_invalid_json"

create_fixture "app/bad.json" '{invalid json: missing quotes}'

run_hook "simple/check_json_validate.sh" "app/bad.json"

assert_exit_code 1
assert_output_contains "ERROR: JSON validation failed"

test_passed
