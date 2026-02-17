#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Markdownlint all fails when tool exits 1
# Expected: exit 1, error message
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "markdownlint_all_fails"

mock_markdownlint 1 "MD013 Line length"
create_fixture "docs/README.md" "# Hello World"

REPO_DIR="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
cp "$REPO_DIR/markdown/check_markdownlint.sh" "$TEST_DIR/check_markdownlint.sh"
cp "$REPO_DIR/markdown/check_markdownlint_all.sh" "$TEST_DIR/check_markdownlint_all.sh"
sed -i.bak "s|PROJECT_DIR=.*|PROJECT_DIR=\"$TEST_DIR\"|" "$TEST_DIR/check_markdownlint_all.sh" && rm -f "$TEST_DIR/check_markdownlint_all.sh.bak"
chmod +x "$TEST_DIR/check_markdownlint.sh" "$TEST_DIR/check_markdownlint_all.sh"

set +e
# shellcheck disable=SC2034
LAST_OUTPUT=$("$TEST_DIR/check_markdownlint_all.sh" 2>&1)
# shellcheck disable=SC2034
LAST_EXIT_CODE=$?
set -e

assert_exit_code 1
assert_output_contains "ERROR"

test_passed
