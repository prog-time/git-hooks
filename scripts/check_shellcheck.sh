#!/bin/bash
# ------------------------------------------------------------------------------
# Runs ShellCheck locally on shell scripts provided as arguments.
# Reports warnings and errors using ShellCheck severity level "warning".
# Fails if any script contains issues.
# ------------------------------------------------------------------------------

set -e

EXCLUDED_RULES=("SC2053")
EXCLUDE_STRING=""
if [[ ${#EXCLUDED_RULES[@]} -gt 0 ]]; then
    EXCLUDE_STRING=$(IFS=,; echo "${EXCLUDED_RULES[*]}")
fi

ERROR_FOUND=0

check_file() {
    local FILE="$1"

    if [[ ! -f "$FILE" ]]; then
        echo "File $FILE not found. Skipping."
        return
    fi

    if [[ "${FILE##*.}" != "sh" ]]; then
        return
    fi

    echo "Checking $FILE..."

    if [[ -n "$EXCLUDE_STRING" ]]; then
        shellcheck --severity=warning --exclude="$EXCLUDE_STRING" "$FILE" || ERROR_FOUND=1
    else
        shellcheck --severity=warning "$FILE" || ERROR_FOUND=1
    fi
}

# Если файлов нет, просто выйти
if [[ $# -eq 0 ]]; then
    echo "No files to check."
    exit 0
fi

for FILE in "$@"; do
    check_file "$FILE"
done

if [[ $ERROR_FOUND -eq 0 ]]; then
    echo -e "\nAll shell scripts passed ShellCheck!"
else
    echo -e "\nShellCheck found issues!"
fi

exit $ERROR_FOUND
