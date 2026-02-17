#!/bin/bash
# ------------------------------------------------------------------------------
# Test: yamllint all passes when tool exits 0
# Expected: exit 0, success message
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "yamllint_all_passes"

mock_yamllint 0 "All good"
create_fixture "config/app.yml" "key: value"

REPO_DIR="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
cp "$REPO_DIR/yml/check_yamllint.sh" "$TEST_DIR/check_yamllint.sh"
cp "$REPO_DIR/yml/check_yamllint_all.sh" "$TEST_DIR/check_yamllint_all.sh"
sed -i '' "s|PROJECT_DIR=.*|PROJECT_DIR=\"$TEST_DIR\"|" "$TEST_DIR/check_yamllint_all.sh"
chmod +x "$TEST_DIR/check_yamllint.sh" "$TEST_DIR/check_yamllint_all.sh"

set +e
# shellcheck disable=SC2034
LAST_OUTPUT=$("$TEST_DIR/check_yamllint_all.sh" 2>&1)
# shellcheck disable=SC2034
LAST_EXIT_CODE=$?
set -e

assert_exit_code 0
assert_output_contains "yamllint check passed"

test_passed
