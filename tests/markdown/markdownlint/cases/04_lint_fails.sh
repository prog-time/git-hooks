#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Markdownlint fails when tool exits 1
# Expected: exit 1, error message
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "markdownlint_fails"

mock_markdownlint 1 "MD013 Line length"
create_fixture "docs/README.md" "# Hello World"

run_hook "markdown/check_markdownlint.sh" "docs/README.md"

assert_exit_code 1
assert_output_contains "ERROR: Markdownlint check failed"

test_passed
