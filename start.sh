#!/bin/bash

# PKI Parser Project - Скрипт быстрого запуска
# ============================================

set -e

echo "🚀 PKI Parser Project - Быстрый запуск"
echo "===================================="

# Проверяем наличие .env файла
if [ ! -f .env ]; then
    echo "📋 Создаю .env файл из шаблона..."
    cp .env.template .env
    echo "✅ Файл .env создан! Отредактируйте его при необходимости."
fi

# Проверяем наличие Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker не установлен! Установите Docker для продолжения."
    exit 1
fi

# Проверяем наличие Docker Compose
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose не установлен! Установите Docker Compose для продолжения."
    exit 1
fi

echo "🔧 Настройка переменных окружения..."
source .env 2>/dev/null || true

# Выбираем команду docker-compose
COMPOSE_CMD="docker-compose"
if docker compose version &> /dev/null; then
    COMPOSE_CMD="docker compose"
fi

echo "🔨 Собираю Docker образы..."
$COMPOSE_CMD build

echo "🏃‍♂️ Запускаю сервисы..."
$COMPOSE_CMD up -d backend frontend

echo "⏳ Ожидаю готовности сервисов..."
sleep 10

# Проверяем статус сервисов
echo "📊 Проверка статуса сервисов:"
$COMPOSE_CMD ps

echo ""
echo "✅ Приложение запущено!"
echo ""
echo "📋 Доступные сервисы:"
echo "  📄 Инфо страница: http://localhost:${DOCKER_FLUTTER_PORT:-8080}"
echo "  🔌 Django API:    http://localhost:${DOCKER_DJANGO_PORT:-8000}"
echo "  📚 Django Admin:  http://localhost:${DOCKER_DJANGO_PORT:-8000}/admin/"
echo ""
echo "🛠️  Полезные команды:"
echo "  Остановить:      $COMPOSE_CMD down"
echo "  Просмотр логов:  $COMPOSE_CMD logs -f"
echo "  Перезапуск:      $COMPOSE_CMD restart"
echo "  Локальный парсер: cd Parse && python main.py"
echo ""
echo ""
echo "🎉 Готово! Откройте http://localhost:${DOCKER_FLUTTER_PORT:-8080} в браузере"
echo ""
echo "📱 Для запуска настоящего Flutter приложения:"
echo "  Локально: cd parser_app && flutter run -d web-server --release --web-hostname 127.0.0.1 --web-port 5500 --dart-define=FLUTTER_WEB_RENDERER=canvaskit"
echo "  Затем откройте: http://localhost:5500"
echo ""
echo "🐳 Для Docker сборки Flutter (если Flutter установлен):"
echo "  1. flutter build web --release --web-renderer canvaskit"
echo "  2. docker cp parser_app/build/web/. pki_frontend:/usr/share/nginx/html/"
echo "  3. docker-compose restart frontend"