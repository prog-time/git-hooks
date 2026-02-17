#!/bin/bash
# ------------------------------------------------------------------------------
# Test: yamllint passes when tool exits 0
# Expected: exit 0, success message
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "yamllint_passes"

mock_yamllint 0 "All good"
create_fixture "config/app.yml" "key: value"

run_hook "yml/check_yamllint.sh" "config/app.yml"

assert_exit_code 0
assert_output_contains "yamllint check passed"

test_passed
