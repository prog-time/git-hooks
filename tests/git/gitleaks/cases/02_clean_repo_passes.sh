#!/bin/bash
# ------------------------------------------------------------------------------
# Test: Clean staged changes pass gitleaks scan
# Expected: exit 0, success message
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/test_helper.bash"

setup_test_env "gitleaks_clean_repo"

# Mock gitleaks to succeed
mkdir -p "$TEST_DIR/bin"
cat > "$TEST_DIR/bin/gitleaks" << 'EOF'
#!/bin/bash
exit 0
EOF
chmod +x "$TEST_DIR/bin/gitleaks"
export PATH="$TEST_DIR/bin:$PATH"

run_hook "git/check_gitleaks.sh"

assert_exit_code 0
assert_output_contains "no secrets detected"

test_passed
