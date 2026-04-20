#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Non-JSON files are ignored
# Expected: exit 0, message about no JSON files
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "json_validate_non_json_ignored"

create_fixture "app/config.yml" "key: value"

run_hook "simple/check_json_validate.sh" "app/config.yml"

assert_exit_code 0
assert_output_contains "No JSON files to check"

test_passed
