#!/bin/bash
# ------------------------------------------------------------------------------
# Common test helper functions for hook testing.
# Provides environment setup, mocking, assertions, and cleanup.
# Source this file at the beginning of each test case.
# ------------------------------------------------------------------------------

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Test state
TEST_DIR=""
TEST_NAME=""
LAST_EXIT_CODE=0
LAST_OUTPUT=""

# -----------------------------------------
# Setup / Cleanup
# -----------------------------------------

setup_test_env() {
    TEST_NAME="${1:-$(basename "$0" .sh)}"
    TEST_DIR=$(mktemp -d)

    # Create basic structure
    mkdir -p "$TEST_DIR"/{vendor/bin,app,.git}

    # Initialize git repo
    git -C "$TEST_DIR" init -q
    git -C "$TEST_DIR" config user.email "test@test.com"
    git -C "$TEST_DIR" config user.name "Test"

    # Create composer.json
    echo '{"name": "test/test"}' > "$TEST_DIR/composer.json"

    cd "$TEST_DIR"

    echo -e "${YELLOW}[TEST]${NC} $TEST_NAME"
}

cleanup_test_env() {
    if [[ -n "$TEST_DIR" && -d "$TEST_DIR" ]]; then
        rm -rf "$TEST_DIR"
    fi
}

# Auto cleanup on exit
trap cleanup_test_env EXIT

# -----------------------------------------
# Fixtures
# -----------------------------------------

create_fixture() {
    local path="$1"
    local content="$2"

    mkdir -p "$(dirname "$path")"
    echo "$content" > "$path"
}

create_php_fixture() {
    local path="$1"
    local class_name="$2"
    local namespace="${3:-App}"

    mkdir -p "$(dirname "$path")"
    cat > "$path" << EOF
<?php

namespace $namespace;

class $class_name
{
}
EOF
}

# -----------------------------------------
# Mocks
# -----------------------------------------

mock_phpstan() {
    local error_count="$1"
    local error_output="${2:-}"

    cat > "$TEST_DIR/vendor/bin/phpstan" << EOF
#!/bin/bash
if [[ "\$*" == *"--error-format=raw"* ]]; then
    count=$error_count
    if [[ \$count -gt 0 ]]; then
        for i in \$(seq 1 \$count); do
            echo "Error \$i"
        done
    fi
elif [[ "\$*" == *"--error-format=table"* ]]; then
    echo "$error_output"
fi
exit 0
EOF
    chmod +x "$TEST_DIR/vendor/bin/phpstan"
}

mock_pint() {
    local has_errors="$1"  # 0 = no errors, 1 = has errors

    cat > "$TEST_DIR/vendor/bin/pint" << EOF
#!/bin/bash
if [[ "\$*" == *"--test"* ]]; then
    exit $has_errors
else
    exit 0
fi
EOF
    chmod +x "$TEST_DIR/vendor/bin/pint"
}

mock_flake8() {
    local exit_code="$1"
    local output="${2:-}"

    mkdir -p "$TEST_DIR/bin"
    cat > "$TEST_DIR/bin/flake8" << EOF
#!/bin/bash
echo "$output"
exit $exit_code
EOF
    chmod +x "$TEST_DIR/bin/flake8"
    export PATH="$TEST_DIR/bin:$PATH"
}

mock_mypy() {
    local exit_code="$1"
    local output="${2:-}"

    mkdir -p "$TEST_DIR/bin"
    cat > "$TEST_DIR/bin/mypy" << EOF
#!/bin/bash
echo "$output"
exit $exit_code
EOF
    chmod +x "$TEST_DIR/bin/mypy"
    export PATH="$TEST_DIR/bin:$PATH"
}

mock_pytest_cmd() {
    local exit_code="$1"
    local output="${2:-}"

    mkdir -p "$TEST_DIR/bin"
    cat > "$TEST_DIR/bin/pytest" << EOF
#!/bin/bash
echo "$output"
exit $exit_code
EOF
    chmod +x "$TEST_DIR/bin/pytest"
    export PATH="$TEST_DIR/bin:$PATH"
}

mock_docker_running() {
    local exec_exit_code="${1:-0}"
    local exec_output="${2:-}"

    mkdir -p "$TEST_DIR/bin"
    cat > "$TEST_DIR/bin/docker" << EOF
#!/bin/bash
if [[ "\$1" == "ps" ]]; then
    echo "app_dev"
elif [[ "\$1" == "exec" ]]; then
    echo "$exec_output"
    exit $exec_exit_code
fi
exit 0
EOF
    chmod +x "$TEST_DIR/bin/docker"
    export PATH="$TEST_DIR/bin:$PATH"
}

mock_docker_stopped() {
    mkdir -p "$TEST_DIR/bin"
    cat > "$TEST_DIR/bin/docker" << 'EOF'
#!/bin/bash
if [[ "$1" == "ps" ]]; then
    echo ""
fi
exit 0
EOF
    chmod +x "$TEST_DIR/bin/docker"
    export PATH="$TEST_DIR/bin:$PATH"
}

create_python_fixture() {
    local path="$1"
    local class_name="${2:-MyClass}"

    mkdir -p "$(dirname "$path")"
    cat > "$path" << EOF
class $class_name:
    pass
EOF
}

mock_git_branch() {
    local branch_name="$1"

    git -C "$TEST_DIR" checkout -q -b "$branch_name" 2>/dev/null || \
    git -C "$TEST_DIR" checkout -q "$branch_name" 2>/dev/null || true
}

mock_npx() {
    local exit_code="$1"
    local output="${2:-}"

    mkdir -p "$TEST_DIR/bin"
    cat > "$TEST_DIR/bin/npx" << EOF
#!/bin/bash
echo "$output"
exit $exit_code
EOF
    chmod +x "$TEST_DIR/bin/npx"
    export PATH="$TEST_DIR/bin:$PATH"
}

mock_markdownlint() {
    local exit_code="$1"
    local output="${2:-}"

    mkdir -p "$TEST_DIR/bin"
    cat > "$TEST_DIR/bin/markdownlint" << EOF
#!/bin/bash
echo "$output"
exit $exit_code
EOF
    chmod +x "$TEST_DIR/bin/markdownlint"
    export PATH="$TEST_DIR/bin:$PATH"
}

mock_yamllint() {
    local exit_code="$1"
    local output="${2:-}"

    mkdir -p "$TEST_DIR/bin"
    cat > "$TEST_DIR/bin/yamllint" << EOF
#!/bin/bash
echo "$output"
exit $exit_code
EOF
    chmod +x "$TEST_DIR/bin/yamllint"
    export PATH="$TEST_DIR/bin:$PATH"
}

mock_docker_compose() {
    mkdir -p "$TEST_DIR/bin"
    cat > "$TEST_DIR/bin/docker" << 'EOF'
#!/bin/bash
# Mock docker - just pass through to local command or return success
if [[ "$1" == "compose" ]]; then
    shift 2  # skip "compose exec"
    shift 2  # skip "-T service"
    eval "$@"
else
    exit 0
fi
EOF
    chmod +x "$TEST_DIR/bin/docker"
    export PATH="$TEST_DIR/bin:$PATH"
}

# -----------------------------------------
# Hook Runner
# -----------------------------------------

run_hook() {
    local hook_path="$1"
    shift
    local args=("$@")

    # Get absolute path to hook
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
    local full_hook_path="$script_dir/$hook_path"

    if [[ ! -f "$full_hook_path" ]]; then
        echo -e "${RED}[ERROR]${NC} Hook not found: $full_hook_path"
        return 1
    fi

    # Run hook and capture output
    set +e
    LAST_OUTPUT=$("$full_hook_path" "${args[@]}" 2>&1)
    LAST_EXIT_CODE=$?
    set -e
}

run_hook_at_depth() {
    local hook_path="$1"
    local depth="$2"
    shift 2
    local args=("$@")

    # Get absolute path to hook
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
    local full_hook_path="$script_dir/$hook_path"

    if [[ ! -f "$full_hook_path" ]]; then
        echo -e "${RED}[ERROR]${NC} Hook not found: $full_hook_path"
        return 1
    fi

    # Build nested directory path inside TEST_DIR
    local nested_dir="$TEST_DIR"
    for ((i = 0; i < depth; i++)); do
        nested_dir="$nested_dir/level_$i"
    done
    mkdir -p "$nested_dir"

    # Copy hook script into nested directory
    cp "$full_hook_path" "$nested_dir/hook.sh"
    chmod +x "$nested_dir/hook.sh"

    # Run hook and capture output
    set +e
    LAST_OUTPUT=$("$nested_dir/hook.sh" "${args[@]}" 2>&1)
    LAST_EXIT_CODE=$?
    set -e
}

# -----------------------------------------
# Assertions
# -----------------------------------------

assert_exit_code() {
    local expected="$1"

    if [[ "$LAST_EXIT_CODE" -eq "$expected" ]]; then
        echo -e "  ${GREEN}✓${NC} Exit code is $expected"
        return 0
    else
        echo -e "  ${RED}✗${NC} Expected exit code $expected, got $LAST_EXIT_CODE"
        echo -e "  ${RED}Output:${NC} $LAST_OUTPUT"
        exit 1
    fi
}

assert_output_contains() {
    local expected="$1"

    if [[ "$LAST_OUTPUT" == *"$expected"* ]]; then
        echo -e "  ${GREEN}✓${NC} Output contains: $expected"
        return 0
    else
        echo -e "  ${RED}✗${NC} Output should contain: $expected"
        echo -e "  ${RED}Actual:${NC} $LAST_OUTPUT"
        exit 1
    fi
}

assert_output_not_contains() {
    local unexpected="$1"

    if [[ "$LAST_OUTPUT" != *"$unexpected"* ]]; then
        echo -e "  ${GREEN}✓${NC} Output does not contain: $unexpected"
        return 0
    else
        echo -e "  ${RED}✗${NC} Output should not contain: $unexpected"
        echo -e "  ${RED}Actual:${NC} $LAST_OUTPUT"
        exit 1
    fi
}

assert_file_exists() {
    local path="$1"

    if [[ -f "$path" ]]; then
        echo -e "  ${GREEN}✓${NC} File exists: $path"
        return 0
    else
        echo -e "  ${RED}✗${NC} File should exist: $path"
        exit 1
    fi
}

assert_file_contains() {
    local path="$1"
    local expected="$2"

    if [[ -f "$path" ]] && grep -q "$expected" "$path"; then
        echo -e "  ${GREEN}✓${NC} File $path contains: $expected"
        return 0
    else
        echo -e "  ${RED}✗${NC} File $path should contain: $expected"
        exit 1
    fi
}

assert_baseline_value() {
    local file="$1"
    local expected_count="$2"
    local baseline_file=".phpstan-error-count.json"

    if [[ ! -f "$baseline_file" ]]; then
        echo -e "  ${RED}✗${NC} Baseline file not found"
        exit 1
    fi

    local actual
    actual=$(jq -r --arg f "$file" '.[$f] // empty' "$baseline_file")

    if [[ "$actual" == "$expected_count" ]]; then
        echo -e "  ${GREEN}✓${NC} Baseline[$file] = $expected_count"
        return 0
    else
        echo -e "  ${RED}✗${NC} Baseline[$file] expected $expected_count, got $actual"
        exit 1
    fi
}

# -----------------------------------------
# Test Result
# -----------------------------------------

test_passed() {
    echo -e "${GREEN}[PASS]${NC} $TEST_NAME"
}

test_failed() {
    local message="$1"
    echo -e "${RED}[FAIL]${NC} $TEST_NAME: $message"
    exit 1
}
