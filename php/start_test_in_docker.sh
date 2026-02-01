#!/bin/bash
# ------------------------------------------------------------------------------
# Runs PHPUnit tests inside Docker container for modified PHP files.
# Accepts list of PHP file paths as arguments.
# Maps each file to its corresponding Unit test class and executes via artisan.
# Excludes non-testable patterns (Controllers, Models, DTOs, etc.).
# Fails if any test fails or required test class is missing.
# ------------------------------------------------------------------------------

set -e

COMPOSE_FILE="/home/project/docker-compose.yml"
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
    "*Rules*"
)

# -----------------------------
# Helpers
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

    echo "Laravel project root not found (composer.json missing)"
    exit 1
}

path_to_classname() {
    local path="$1"
    path="${path%.php}"
    path="${path#app/}"
    echo "${path//\//\\}"
}

should_be_tested() {
    classname="$1"
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        # shellcheck disable=SC2053 # Glob matching is intentional
        if [[ "$classname" == $pattern ]]; then
            return 1
        fi
    done
    return 0
}

get_expected_test_classname() {
    local classname="$1"
    echo "Tests\\Unit\\${classname}Test"
}

find_test_class_path() {
    local test_classname="$1"
    local project_root="$2"

    local test_path="${test_classname//\\//}.php"
    local full_path="$project_root/tests/${test_path#Tests/}"  # убираем префикс "Tests"

    if [[ -f "$full_path" ]]; then
        echo "$full_path"
        return 0
    fi

    return 1
}

run_test_for_class() {
    local test_classname="$1"
    local project_root="$2"

    local test_file
    test_file=$(find_test_class_path "$test_classname" "$project_root")

    if [[ -z "$test_file" ]]; then
        echo "Test file not found for: $test_classname"
        return 1
    fi

    local classname
    classname=$(basename "$test_file" .php)

    echo "Running test: $test_classname"
    echo "File: $classname"

    if docker compose -f "$COMPOSE_FILE" exec -T "$SERVICE_NAME" sh -c "cd $PROJECT_PATH && php artisan test --filter='$classname'"; then
        echo "Test passed: $test_classname"
        return 0
    else
        echo "Test failed: $test_classname"
        return 1
    fi
}


analyze_and_run_tests() {
    local app_file="$1"
    local project_root="$2"

    # Convert file path to class name
    local normalized_classname
    normalized_classname=$(path_to_classname "$app_file")

    # Skip if class matches exclusion patterns
    if ! should_be_tested "$normalized_classname"; then
        echo "Class does not require testing: $normalized_classname"
        echo "---"
        return 0
    fi

    # Get expected test class
    local expected_test
    expected_test=$(get_expected_test_classname "$normalized_classname")

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
# Main function — принимает список файлов
# -----------------------------
main() {
    local files=("$@")
    if [[ ${#files[@]} -eq 0 ]]; then
        echo "[RunTests] No PHP files to test!"
        exit 0
    fi

    local project_root
    project_root=$(find_project_root)
    local has_failures=0

    for app_file in "${files[@]}"; do
        [[ -z "$app_file" ]] && continue
        ! analyze_and_run_tests "$app_file" "$project_root" && has_failures=1
    done

    if [ "$has_failures" -eq 1 ]; then
        echo "❗ One or more tests failed or are missing."
        exit 1
    else
        echo "🎉 All tests for modified classes passed successfully!"
        exit 0
    fi
}

main "$@"
