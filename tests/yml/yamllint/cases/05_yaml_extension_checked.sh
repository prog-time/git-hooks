#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Both .yml and .yaml extensions are checked
# Expected: exit 0, success message with 2 files
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "yamllint_yaml_extension"

mock_yamllint 0 "All good"
create_fixture "config/app.yml" "key: value"
create_fixture "config/docker.yaml" "service: app"

run_hook "yml/check_yamllint.sh" "config/app.yml" "config/docker.yaml"

assert_exit_code 0
assert_output_contains "2 files checked"

test_passed
