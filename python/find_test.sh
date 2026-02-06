#!/bin/bash
# ------------------------------------------------------------------
# Checks test files for services in app/services.
# Rules:
#   - Only checks files in app/services/**/*.py
#   - Each service must have exactly one test file
#   - Test file mirrors the path relative to app/:
#     app/services/.../x.py -> tests/services/.../test_x.py
# Usage:
#   ./check_service_tests.sh <file1.py> <file2.py> ...
# ------------------------------------------------------------------

get_test_path() {
    local file="$1"

    # Skip files already under tests/
    if [[ "$file" == tests/* ]]; then
        echo ""
        return
    fi

    # Ensure it's a service file
    if [[ ! "$file" =~ ^app/services/.*\.py$ ]]; then
        echo ""
        return
    fi

    # Skip __init__.py
    local filename
    filename=$(basename "$file")
    if [[ "$filename" == "__init__.py" ]]; then
        echo ""
        return
    fi

    local relative="${file#app/}"
    local dir
    dir=$(dirname "$relative")
    local test_filename="test_${filename}"
    local test_path="tests/${dir}/${test_filename}"

    echo "$test_path"
}

if [ $# -eq 0 ]; then
    echo "No files to check"
    exit 0
fi

MISSING_TESTS=()
DUPLICATE_TESTS=()
CHECKED_FILES=0

for file in "$@"; do
    # Skip non-Python files
    if [[ ! "$file" =~ \.py$ ]]; then
        continue
    fi

    test_path=$(get_test_path "$file")

    if [ -z "$test_path" ]; then
        continue
    fi

    CHECKED_FILES=$((CHECKED_FILES + 1))

    # Check that the expected test exists
    if [ ! -f "$test_path" ]; then
        MISSING_TESTS+=("$file -> $test_path")
    fi

    # Check duplicates: by "1 service = 1 test file" rule only test_<service>.py is allowed
    # Any other test_<service>* .py in the same dir is considered a duplicate.
    service_filename=$(basename "$file")
    service_stem="${service_filename%.py}"
    test_dir=$(dirname "$test_path")
    expected_test="$test_path"

    shopt -s nullglob
    candidates=("${test_dir}/test_${service_stem}"*.py)
    shopt -u nullglob

    duplicates=()
    for candidate in "${candidates[@]}"; do
        if [ "$candidate" != "$expected_test" ]; then
            duplicates+=("$candidate")
        fi
    done

    if [ ${#duplicates[@]} -gt 0 ]; then
        DUPLICATE_TESTS+=("$file -> extra tests found: ${duplicates[*]}")
    fi
done

# Report results
if [ ${#MISSING_TESTS[@]} -gt 0 ]; then
    echo "ERROR: Missing tests for the following services:"
    for missing in "${MISSING_TESTS[@]}"; do
        echo "  - $missing"
    done
    echo "Total files checked: $CHECKED_FILES"
    echo "Missing tests: ${#MISSING_TESTS[@]}"
    exit 1
fi

if [ ${#DUPLICATE_TESTS[@]} -gt 0 ]; then
    echo "ERROR: '1 service = 1 test file' rule violated (duplicates found):"
    for dup in "${DUPLICATE_TESTS[@]}"; do
        echo "  - $dup"
    done
    echo "Total files checked: $CHECKED_FILES"
    echo "Duplicate groups: ${#DUPLICATE_TESTS[@]}"
    exit 1
fi

if [ $CHECKED_FILES -eq 0 ]; then
    echo "No service files to check (skipping)."
else
    echo "All checks passed! ($CHECKED_FILES files checked)"
fi

exit 0
