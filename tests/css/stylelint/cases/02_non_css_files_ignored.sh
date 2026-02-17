#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Non-CSS files are ignored
# Expected: exit 0, message about no CSS files
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "stylelint_non_css_ignored"

create_fixture "app/index.js" "const x = 1;"

run_hook "css/check_stylelint.sh" "app/index.js"

assert_exit_code 0
assert_output_contains "No CSS/SCSS/Less files to check"

test_passed
