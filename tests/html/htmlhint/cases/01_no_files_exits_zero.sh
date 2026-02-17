#!/bin/bash
# ------------------------------------------------------------------------------
# Test: No files provided exits with 0
# Expected: exit 0, message about no files
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "htmlhint_no_files"

run_hook "html/check_htmlhint.sh"

assert_exit_code 0
assert_output_contains "No files to check"

test_passed
