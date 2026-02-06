#!/bin/bash
# ----------------------------------------
# Python Code Style Checker
#
# This script checks Python files for style
# issues using flake8. It runs directly on
# the host (no Docker required).
#
# Usage:
#   ./check_style.sh file1.py file2.py ...
# ----------------------------------------

# -----------------------------
# CONFIG
# -----------------------------
CONTAINER_NAME="app_dev"

# Path mapping: host path prefix -> container path prefix
HOST_APP_PATH="app/"
CONTAINER_APP_PATH="/app/"

# -----------------------------
# FUNCTIONS
# -----------------------------
check_container_running() {
    if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        echo "ERROR: Container '$CONTAINER_NAME' is not running"
        echo "Start it with: docker-compose -f docker/dev/docker-compose.yml up -d"
        exit 1
    fi
}

# Convert host path to container path
to_container_path() {
    local file="$1"
    # Replace app/ with /app/
    echo "$file" | sed "s|^${HOST_APP_PATH}|${CONTAINER_APP_PATH}|"
}

# -----------------------------
# MAIN
# -----------------------------
if [ $# -eq 0 ]; then
    echo "No files to check"
    exit 0
fi

check_container_running

PY_FILES=()
CHECKED_FILES=0
HAS_ERRORS=0

# Collect only .py files from app/ directory
for file in "$@"; do
    # Skip non-Python files
    if [[ ! "$file" =~ \.py$ ]]; then
        continue
    fi

    # Skip files not in app/ directory (not mounted in container)
    if [[ ! "$file" =~ ^app/ ]]; then
        continue
    fi

    # Skip if file doesn't exist
    if [ ! -f "$file" ]; then
        continue
    fi

    PY_FILES+=("$file")
done

# Check if there are any Python files to check
if [ ${#PY_FILES[@]} -eq 0 ]; then
    echo "No Python files to check"
    exit 0
fi

# Run linter on each file via docker exec
for file in "${PY_FILES[@]}"; do
    CHECKED_FILES=$((CHECKED_FILES + 1))

    container_path=$(to_container_path "$file")

    # Run linter inside container
    OUTPUT=$(docker exec "$CONTAINER_NAME" flake8 --max-line-length=120 "$container_path" 2>&1)
    EXIT_CODE=$?

    if [ $EXIT_CODE -ne 0 ]; then
        HAS_ERRORS=1
        echo "Style errors in: $file"
        # Convert container paths back to host paths in output
        echo "$OUTPUT" | sed "s|${CONTAINER_APP_PATH}|${HOST_APP_PATH}|g"
        echo ""
    fi
done

# Final result
if [ $HAS_ERRORS -ne 0 ]; then
    echo "----------------------------------------"
    echo "ERROR: Code style check failed!"
    echo "Total files checked: $CHECKED_FILES"
    echo "Fix the errors above before committing."
    exit 1
fi

echo "Code style check passed! ($CHECKED_FILES files checked)"
exit 0
