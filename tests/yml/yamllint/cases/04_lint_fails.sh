#!/bin/bash
# ------------------------------------------------------------------------------
# Test: yamllint fails when tool exits 1
# Expected: exit 1, error message
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "yamllint_fails"

mock_yamllint 1 "syntax error"
create_fixture "config/app.yml" "key: value"

run_hook "yml/check_yamllint.sh" "config/app.yml"

assert_exit_code 1
assert_output_contains "ERROR: yamllint check failed"

test_passed
