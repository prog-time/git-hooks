#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Markdownlint passes when tool exits 0
# Expected: exit 0, success message
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "markdownlint_passes"

mock_markdownlint 0 "All good"
create_fixture "docs/README.md" "# Hello World"

run_hook "markdown/check_markdownlint.sh" "docs/README.md"

assert_exit_code 0
assert_output_contains "Markdownlint check passed"

test_passed
