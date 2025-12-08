#!/bin/bash

set -e

COMPOSE_FILE="../docker-compose.yml"
SERVICE_NAME="app"
PROJECT_PATH="/var/www"

# -----------------------------
# CONFIG — list of exclusion patterns
# -----------------------------
EXCLUDE_PATTERNS=(
    "*Test" "*Search" "*Controller*" "*Console*" "*Jobs*"
    "*Models*" "*Resources*" "*Requests*" "*DTO*" "*Dtos*"
    "*Kernel*" "*Middleware*" "*config*" "*ValueObject*"
    "*Enum*" "*Exception*" "*Migration*" "*Seeder*"
    "*MockDto*" "*api*" "*Providers*" "*Abstract*"
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# -----------------------------
# Output helper functions
# -----------------------------
info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

# -----------------------------
# Find the project root (where composer.json is located)
# -----------------------------
find_project_root() {
    local current_dir="$PWD"

    while [[ "$current_dir" != "/" ]]; do
        if [[ -f "$current_dir/composer.json" ]]; then
            echo "$current_dir"
            return 0
        fi
        current_dir=$(dirname "$current_dir")
    done

    error "Laravel project root not found (composer.json missing)"
    exit 1
}

# -----------------------------
# Convert file path to PHP class name
# -----------------------------
path_to_classname() {
    local path="$1"

    # Remove .php extension
    path="${path%.php}"

    # Remove 'app/' prefix if exists
    path="${path#app/}"

    # Replace / with \
    local classname="${path//\//\\}"
    echo "$classname"
}

# -----------------------------
# Check if a class should be tested
# -----------------------------
should_be_tested() {
    local classname="$1"

    # Skip classes matching exclusion patterns
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        if [[ "$classname" == $pattern ]]; then
            return 1
        fi
    done

    return 0
}

# -----------------------------
# Get expected test class name
# -----------------------------
get_expected_test_classname() {
    local classname="$1"
    echo "Tests\\Unit\\${classname}Test"
}

# -----------------------------
# Extract class name from a PHP file
# -----------------------------
extract_classname_from_file() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        return 1
    fi

    local namespace=""
    local classname=""

    # Extract namespace
    namespace=$(grep -m1 "^namespace " "$file" | sed 's/namespace \(.*\);/\1/' | tr -d ' ')

    # Extract class name
    classname=$(grep -m1 "^class " "$file" | sed 's/class \([a-zA-Z0-9_]*\).*/\1/')

    if [[ -n "$namespace" && -n "$classname" ]]; then
        echo "${namespace}\\${classname}"
    fi
}

# -----------------------------
# Find test file path for a given test class
# -----------------------------
find_test_class_path() {
    local test_classname="$1"
    local project_root="$2"

    # Convert class name to file path
    local test_path="${test_classname//\\//}.php"

    echo $test_path

    local full_path="$project_root/tests/${test_path#*Tests/}"

    if [[ -f "$full_path" ]]; then
        return 0
    fi
    return 1
}

# -----------------------------
# Run test for a specific class via Docker Compose
# -----------------------------
run_test_for_class() {
    local test_classname="$1"
    local project_root="$2"

    local test_file=$(find_test_class_path "$test_classname" "$project_root")

    if [[ -z "$test_file" ]]; then
        error "Test file not found for: $test_classname"
        return 1
    fi

    local classname=$(basename "$test_file" .php)

    info "Running test: $test_classname"
    info "File: $classname"

    # Run via Docker Compose
    docker compose -f "$COMPOSE_FILE" exec -T "$SERVICE_NAME" sh -c "cd $PROJECT_PATH && php artisan test --filter='$classname'"

    if [[ $? -eq 0 ]]; then
        success "Test passed: $test_classname"
        return 0
    else
        error "Test failed: $test_classname"
        return 1
    fi
}

# -----------------------------
# Analyze file and run the corresponding test
# -----------------------------
analyze_and_run_tests() {
    local app_file="$1"
    local project_root="$2"

    # Convert file path to class name
    local normalized_classname=$(path_to_classname "$app_file")

    # Skip if class matches exclusion patterns
    if ! should_be_tested "$normalized_classname"; then
        warning "Class does not require testing: $normalized_classname"
        echo "---"
        return 0
    fi

    # Get expected test class
    local expected_test=$(get_expected_test_classname "$normalized_classname")

    # Run the test
    if run_test_for_class "$expected_test" "$project_root"; then
        echo "---"
        return 0
    else
        echo "---"
        return 1
    fi
}

# -----------------------------
# Main function
# -----------------------------
main() {
    local COMMAND="$1"

    if [ "$COMMAND" = "commit" ]; then
        ALL_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.php$' || true)
    elif [ "$COMMAND" = "push" ]; then
        BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [ -z "$BRANCH" ] || [ "$BRANCH" = "HEAD" ]; then
            error "Unable to determine current branch"
            exit 1
        fi
        # Check if origin/branch exists
        if ! git ls-remote --exit-code origin "$BRANCH" >/dev/null 2>&1; then
            warning "origin/$BRANCH does not exist — testing staged files"
            ALL_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.php$' || true)
        else
            ALL_FILES=$(git diff --name-only origin/"$BRANCH" --diff-filter=ACM | grep '\.php$' || true)
        fi
    else
        error "Unknown command: $COMMAND (expected 'commit' or 'push')"
        exit 1
    fi

    if [ -z "$ALL_FILES" ]; then
        success "[RunTests] No PHP files to test!"
        exit 0
    fi

    local project_root=$(find_project_root)
    local has_failures=0

    while IFS= read -r app_file; do
        if [[ -z "$app_file" ]]; then
            continue
        fi

        if ! analyze_and_run_tests "$app_file" "$project_root"; then
            has_failures=1
        fi
    done <<< "$ALL_FILES"

    if [ "$has_failures" -eq 1 ]; then
        error "❗ One or more tests failed or are missing."
        exit 1
    else
        success "🎉 All tests for modified classes passed successfully!"
        exit 0
    fi
}

main "$@"
