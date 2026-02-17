#!/bin/bash
# ------------------------------------------------------------------------------
# Test: SCSS and Less files are also checked
# Expected: exit 0, success message with file count
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "stylelint_scss_files"

mock_npx 0 "All good"
# shellcheck disable=SC2016
create_fixture "app/style.scss" '$color: red;'
create_fixture "app/theme.less" "@color: red;"

run_hook "css/check_stylelint.sh" "app/style.scss" "app/theme.less"

assert_exit_code 0
assert_output_contains "2 files checked"

test_passed
