#!/bin/bash
# ------------------------------------------------------------------------------
# Test: codespell binary missing exits with 1 and install hint
# Expected: exit 1, message about installation
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "codespell_binary_missing"

HOOK_PATH="$(cd "$SCRIPT_DIR/../../../../simple" && pwd)/check_codespell.sh"

create_fixture "app/readme.txt" "This is a tset file."

SAVED_PATH="$PATH"
export PATH="/usr/bin:/bin"

set +e
# shellcheck disable=SC2034
LAST_OUTPUT=$("$HOOK_PATH" "app/readme.txt" 2>&1)
# shellcheck disable=SC2034
LAST_EXIT_CODE=$?
set -e

export PATH="$SAVED_PATH"

assert_exit_code 1
assert_output_contains "codespell is not installed"

test_passed
