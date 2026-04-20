#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Correctly formatted shell script passes shfmt check
# Expected: exit 0, success message
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "shfmt_correctly_formatted"

# Mock shfmt to succeed with no diff output
mkdir -p "$TEST_DIR/bin"
cat > "$TEST_DIR/bin/shfmt" << 'EOF'
#!/bin/bash
exit 0
EOF
chmod +x "$TEST_DIR/bin/shfmt"
export PATH="$TEST_DIR/bin:$PATH"

create_fixture "scripts/clean.sh" "#!/bin/bash
echo hello"

run_hook "shell/check_shfmt.sh" "scripts/clean.sh"

assert_exit_code 0
assert_output_contains "shfmt check passed"

test_passed
