#!/bin/bash

set -e

ALL_FILE_ARRAY=()
while IFS= read -r line; do
    ALL_FILE_ARRAY+=("$line")
done < <(git diff --cached --name-only --diff-filter=ACM || true)

NEW_FILE_ARRAY=()
while IFS= read -r line; do
    NEW_FILE_ARRAY+=("$line")
done < <(git diff --cached --name-only --diff-filter=A || true)

#echo "ALL_FILE_ARRAY по индексам:"
#for i in "${!ALL_FILE_ARRAY[@]}"; do
#    echo "[$i] = '${ALL_FILE_ARRAY[$i]}'"
#done

echo "Checking shell scripts with ShellCheck..."
bash scripts/check_shellcheck.sh "${ALL_FILE_ARRAY[@]}"
echo "----------"

