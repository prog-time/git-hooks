#!/bin/bash
# ------------------------------------------------------------------------------
# Test: ruff binary missing exits with 1 and install hint
# Expected: exit 1, message about installation
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "ruff_binary_missing"

HOOK_PATH="$(cd "$SCRIPT_DIR/../../../../python" && pwd)/check_ruff.sh"

create_python_fixture "app/module.py" "MyModule"

SAVED_PATH="$PATH"
export PATH="/usr/bin:/bin"

set +e
# shellcheck disable=SC2034
LAST_OUTPUT=$("$HOOK_PATH" "app/module.py" 2>&1)
# shellcheck disable=SC2034
LAST_EXIT_CODE=$?
set -e

export PATH="$SAVED_PATH"

assert_exit_code 1
assert_output_contains "ruff is not installed"

test_passed
