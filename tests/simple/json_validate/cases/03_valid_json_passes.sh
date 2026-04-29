#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Valid JSON file passes validation
# Expected: exit 0, success message
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "json_validate_valid_json"

create_fixture "app/config.json" '{"name": "test", "version": "1.0.0"}'

run_hook "simple/check_json_validate.sh" "app/config.json"

assert_exit_code 0
assert_output_contains "JSON validation passed"

test_passed
