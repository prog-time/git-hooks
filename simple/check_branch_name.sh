#!/bin/bash

# Получаем имя текущей ветки
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

# Регулярное выражение для проверки
REGEX="^(feature|bugfix|hotfix|release)\/[a-zA-Z0-9]+_[a-zA-Z0-9_-]+$"

if [[ $BRANCH_NAME =~ $REGEX ]]; then
    echo "Имя ветки '$BRANCH_NAME' соответствует требуемой структуре."
    exit 0
else
    echo "Ошибка: имя ветки '$BRANCH_NAME' не соответствует структуре {тип работы}/{номер задачи}_{краткое описание}."
    echo "Пример правильного имени: feature/dev-2212_order_service"
    exit 1
fi
