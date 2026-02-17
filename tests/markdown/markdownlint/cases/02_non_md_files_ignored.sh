#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Non-Markdown files are ignored
# Expected: exit 0, message about no Markdown files
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "markdownlint_non_md_ignored"

create_fixture "app/index.html" "<html></html>"

run_hook "markdown/check_markdownlint.sh" "app/index.html"

assert_exit_code 0
assert_output_contains "No Markdown files to check"

test_passed
