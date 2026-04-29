#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Clean Python file with no ruff errors passes
# Expected: exit 0, success message
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "ruff_clean_file"

mkdir -p "$TEST_DIR/bin"
cat > "$TEST_DIR/bin/ruff" << 'EOF'
#!/bin/bash
exit 0
EOF
chmod +x "$TEST_DIR/bin/ruff"
export PATH="$TEST_DIR/bin:$PATH"

create_python_fixture "app/clean.py" "CleanClass"

run_hook "python/check_ruff.sh" "app/clean.py"

assert_exit_code 0
assert_output_contains "ruff check passed"

test_passed
