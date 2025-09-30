#!/bin/bash

echo "=== Остановка всех контейнеров ==="
docker-compose down

echo "=== Сборка контейнеров ==="
docker-compose build

echo "=== Запуск контейнеров в фоне ==="
docker-compose up -d

# Пауза для запуска сервисов
echo "=== Ждем 5 секунд для старта сервисов ==="
sleep 5

echo "=== Проверка состояния контейнеров ==="
# Получаем статус всех контейнеров
STATUS=$(docker-compose ps --services --filter "status=running")

if [ -z "$STATUS" ]; then
  echo "Ошибка: ни один контейнер не запущен!"
  exit 1
else
  echo "Запущенные контейнеры:"
  docker-compose ps
fi

# Дополнительно можно проверять HEALTHCHECK каждого контейнера
echo "=== Проверка состояния HEALTH ==="
docker ps --filter "health=unhealthy" --format "table {{.Names}}\t{{.Status}}"

echo "=== Скрипт завершен ==="

exit 0
