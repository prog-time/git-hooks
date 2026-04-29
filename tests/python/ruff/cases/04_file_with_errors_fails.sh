#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Python file with ruff errors fails
# Expected: exit 1, error message about ruff check
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "ruff_file_with_errors"

mkdir -p "$TEST_DIR/bin"
cat > "$TEST_DIR/bin/ruff" << 'EOF'
#!/bin/bash
echo "app/bad.py:1:1: E302 expected 2 blank lines"
exit 1
EOF
chmod +x "$TEST_DIR/bin/ruff"
export PATH="$TEST_DIR/bin:$PATH"

create_python_fixture "app/bad.py" "BadClass"

run_hook "python/check_ruff.sh" "app/bad.py"

assert_exit_code 1
assert_output_contains "ERROR: ruff check failed"

test_passed
