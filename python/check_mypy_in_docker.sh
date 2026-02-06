#!/bin/bash

# ------------------------------------------------------------
# Runs mypy static analysis for changed Python files inside
# the running Docker container. Accepts file paths as args,
# filters only app/*.py, maps them to container paths, and
# executes mypy via docker exec.
# ------------------------------------------------------------

CONTAINER_NAME="app_dev"
HOST_APP_PATH="app/"
CONTAINER_APP_PATH="/app/"

check_container_running() {
    if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        echo "ERROR: Container '${CONTAINER_NAME}' is not running"
        echo "Start it with: docker-compose -f docker/dev/docker-compose.yml up -d"
        exit 1
    fi
}

to_container_path() {
    local file="$1"
    echo "$file" | sed "s|^${HOST_APP_PATH}|${CONTAINER_APP_PATH}|"
}

if [ $# -eq 0 ]; then
    echo "No files to check"
    exit 0
fi

check_container_running

PY_FILES=()

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

if [ ${#PY_FILES[@]} -eq 0 ]; then
    echo "No Python files to check"
    exit 0
fi

CONTAINER_FILES=()
for file in "${PY_FILES[@]}"; do
    CONTAINER_FILES+=("$(to_container_path "$file")")
done

OUTPUT=$(docker exec "$CONTAINER_NAME" mypy \
    --pretty \
    --show-error-codes \
    --ignore-missing-imports \
    --follow-imports=skip \
    "${CONTAINER_FILES[@]}" 2>&1)

EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
    echo "----------------------------------------"
    echo "ERROR: Static analysis failed!"
    echo "----------------------------------------"
    echo "$OUTPUT" | sed "s|${CONTAINER_APP_PATH}|${HOST_APP_PATH}|g"
    echo "----------------------------------------"
    echo "Total files checked: ${#PY_FILES[@]}"
    exit 1
fi

echo "Static analysis passed! (${#PY_FILES[@]} files checked)"
exit 0
