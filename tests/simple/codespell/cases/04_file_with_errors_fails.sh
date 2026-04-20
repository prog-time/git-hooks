#!/bin/bash
# ------------------------------------------------------------------------------
# Test: File with spelling errors fails
# Expected: exit 1, error message about spelling check
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "codespell_file_with_errors"

# Mock codespell to fail with spelling errors
mkdir -p "$TEST_DIR/bin"
cat > "$TEST_DIR/bin/codespell" << 'EOF'
#!/bin/bash
echo "app/bad.txt:1: tset ==> test"
exit 1
EOF
chmod +x "$TEST_DIR/bin/codespell"
export PATH="$TEST_DIR/bin:$PATH"

create_fixture "app/bad.txt" "This is a tset file."

run_hook "simple/check_codespell.sh" "app/bad.txt"

assert_exit_code 1
assert_output_contains "ERROR: Spelling check failed"

test_passed
