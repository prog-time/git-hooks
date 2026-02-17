#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Non-HTML files are ignored
# Expected: exit 0, message about no HTML files
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "htmlhint_non_html_ignored"

create_fixture "app/style.css" "body { color: red; }"

run_hook "html/check_htmlhint.sh" "app/style.css"

assert_exit_code 0
assert_output_contains "No HTML files to check"

test_passed
