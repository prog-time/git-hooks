#!/bin/bash
# ------------------------------------------------------------------------------
# Test: gitleaks binary missing in _all variant exits with 0 and warning
# Expected: exit 0, warning message about gitleaks not installed
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "gitleaks_all_binary_missing"

HOOK_PATH="$(cd "$SCRIPT_DIR/../../../../git" && pwd)/check_gitleaks_all.sh"

SAVED_PATH="$PATH"
export PATH="/usr/bin:/bin"

set +e
# shellcheck disable=SC2034
LAST_OUTPUT=$("$HOOK_PATH" 2>&1)
# shellcheck disable=SC2034
LAST_EXIT_CODE=$?
set -e

export PATH="$SAVED_PATH"

assert_exit_code 0
assert_output_contains "WARNING: gitleaks is not installed"

test_passed
