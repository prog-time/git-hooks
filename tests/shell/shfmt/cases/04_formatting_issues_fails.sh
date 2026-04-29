#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Shell script with formatting issues fails shfmt check
# Expected: exit 1, error message about shfmt check and diff output
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "shfmt_formatting_issues"

# Mock shfmt to fail with a diff
mkdir -p "$TEST_DIR/bin"
cat > "$TEST_DIR/bin/shfmt" << 'EOF'
#!/bin/bash
echo "--- scripts/bad.sh"
echo "+++ scripts/bad.sh"
echo "@@ -1,3 +1,3 @@"
echo "-    echo hello"
echo "+  echo hello"
exit 1
EOF
chmod +x "$TEST_DIR/bin/shfmt"
export PATH="$TEST_DIR/bin:$PATH"

create_fixture "scripts/bad.sh" "#!/bin/bash
    echo hello"

run_hook "shell/check_shfmt.sh" "scripts/bad.sh"

assert_exit_code 1
assert_output_contains "ERROR: shfmt check failed"

test_passed
