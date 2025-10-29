#!/bin/sh

# Добавляем список файлов в тело коммита

COMMIT_MSG_FILE=".git/COMMIT_EDITMSG"

# Не модифицируем merge commit
if grep -qE '^Merge' "$COMMIT_MSG_FILE"; then
  exit 0
fi

# Получаем staged изменения
CHANGES=$(git diff --cached --name-status)
[ -z "$CHANGES" ] && exit 0

{
  echo ""
  echo "------------------------------"
  echo "Изменённые файлы:"
  echo "$CHANGES" | while read -r STATUS FILE; do
    case "$STATUS" in
      A) echo "Добавлен:   $FILE" ;;
      M) echo "Изменён:    $FILE" ;;
      D) echo "Удалён:     $FILE" ;;
      R) echo "Переименован: $FILE" ;;
      *) echo "$STATUS: $FILE" ;;
    esac
  done
} >> "$COMMIT_MSG_FILE"
