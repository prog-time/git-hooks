#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Non-YAML files are ignored
# Expected: exit 0, message about no YAML files
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "yamllint_non_yaml_ignored"

create_fixture "app/index.html" "<html></html>"

run_hook "yml/check_yamllint.sh" "app/index.html"

assert_exit_code 0
assert_output_contains "No YAML files to check"

test_passed
