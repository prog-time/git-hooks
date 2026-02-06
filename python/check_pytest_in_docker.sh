#!/bin/bash
# ----------------------------------------
# Run pytest inside Docker container
#
# This script:
#   • checks that the development container is running
#   • executes the full pytest test suite inside the container
#   • sets PYTHONPATH=/app so app modules resolve correctly
#   • converts container paths (/app, /tests) to local paths
#     (app/, tests/) for readable error output
#   • returns proper exit codes (0/1) for CI/CD pipelines
#
# Usage:
#   ./run_tests.sh
# ----------------------------------------

# -----------------------------
# CONFIG
# -----------------------------
CONTAINER_NAME="app_dev"

# Path mapping: container path prefix -> host path prefix (for readable output)
CONTAINER_APP_PATH="/app/"
HOST_APP_PATH="app/"
CONTAINER_TESTS_PATH="/tests/"
HOST_TESTS_PATH="tests/"

# -----------------------------
# FUNCTIONS
# -----------------------------
check_container_running() {
    if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        echo "ERROR: Container '${CONTAINER_NAME}' is not running"
        echo "Start it with: docker-compose -f docker/dev/docker-compose.yml up -d"
        exit 1
    fi
}

# -----------------------------
# MAIN
# -----------------------------
check_container_running

echo "Running full test suite (pytest)..."

# Run tests inside container. PYTHONPATH=/app so "routes" and "database" resolve to app code.
OUTPUT=$(docker exec -e PYTHONPATH=/app "$CONTAINER_NAME" pytest -q "$CONTAINER_TESTS_PATH" 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
    echo "----------------------------------------"
    echo "ERROR: Tests failed!"
    echo "----------------------------------------"
    # Convert container paths back to host paths in output
    echo "$OUTPUT" | sed \
        -e "s|${CONTAINER_APP_PATH}|${HOST_APP_PATH}|g" \
        -e "s|${CONTAINER_TESTS_PATH}|${HOST_TESTS_PATH}|g"
    echo "----------------------------------------"
    exit 1
fi

echo "All tests passed!"
exit 0
