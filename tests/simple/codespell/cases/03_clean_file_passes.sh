#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Clean file with no spelling errors passes
# Expected: exit 0, success message
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "codespell_clean_file"

# Mock codespell to succeed
mkdir -p "$TEST_DIR/bin"
cat > "$TEST_DIR/bin/codespell" << 'EOF'
#!/bin/bash
exit 0
EOF
chmod +x "$TEST_DIR/bin/codespell"
export PATH="$TEST_DIR/bin:$PATH"

create_fixture "app/clean.txt" "This is a clean file with correct spelling."

run_hook "simple/check_codespell.sh" "app/clean.txt"

assert_exit_code 0
assert_output_contains "Spelling check passed"

test_passed
