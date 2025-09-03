# PKI Parser Project

## Описание проекта

Проект состоит из трех основных компонентов:

1. **Flutter приложение** (`parser_app/`) - мобильное/веб приложение для просмотра каталога товаров
2. **Django API** (`prototype/`) - REST API для работы с данными и аутентификацией
3. **Python парсер** (`Parse/`) - скрипт для обработки Excel файлов с каталогом товаров

## Архитектура

```
┌─────────────────┐    HTTP/JWT    ┌─────────────────┐
│                 │ ◄─────────────► │                 │
│  Flutter App    │                │   Django API    │
│  (Mobile/Web)   │                │   (Backend)     │
│                 │                │                 │
└─────────────────┘                └─────────────────┘
                                             │
                                             │ reads
                                             ▼
                                   ┌─────────────────┐
                                   │                 │
                                   │  Excel Parser   │
                                   │   (Parse/)      │
                                   │                 │
                                   └─────────────────┘
```

## Компоненты

### 1. Flutter приложение (`parser_app/`)

**Описание**: Мобильное/веб приложение для каталога товаров PKI_UL

**Основные функции**:
- Аутентификация пользователей (JWT токены)
- Просмотр каталога товаров по категориям
- Поиск товаров
- Корзина покупок
- Профиль пользователя

**Технологии**:
- Flutter 3.8+
- HTTP клиент для API запросов
- Secure Storage для токенов
- Lottie анимации

**API endpoints используемые приложением**:
- `POST /api/token/` - получение JWT токенов
- `POST /api/token/refresh/` - обновление токенов
- `GET /api/me/` - информация о пользователе
- `GET /api/get_goods/` - список товаров
- `GET /api/search/` - поиск товаров

### 2. Django API (`prototype/`)

**Описание**: REST API для работы с данными каталога и аутентификацией

**Основные функции**:
- JWT аутентификация (SimpleJWT)
- CRUD операции с товарами
- Поиск по каталогу
- Кэширование данных
- CORS поддержка для Flutter приложения

**Технологии**:
- Django 5.2
- Django REST Framework
- SimpleJWT для аутентификации
- SQLite база данных
- CORS headers

**API endpoints**:
- `POST /api/token/` - получение JWT токенов
- `POST /api/token/refresh/` - обновление access токена
- `GET /api/me/` - информация о текущем пользователе
- `POST /api/logout/` - выход из системы
- `GET /api/get_goods/` - получение списка товаров (с аутентификацией)
- `GET /api/search/` - поиск товаров
- `POST /api/register/` - регистрация пользователя
- `POST /api/write_cache/` - запись кэша

### 3. Python парсер (`Parse/`)

**Описание**: Локальный скрипт для обработки Excel файлов с каталогом товаров

**Основные функции**:
- Чтение Excel файла `output.xlsx`
- Парсинг структуры каталога (категории → товары → цены)
- Очистка дубликатов и форматирование данных
- Выведение структурированных данных

**Технологии**:
- Python + pandas
- Обработка Excel файлов

**Примечание**: Парсер запускается локально, не контейнеризован

## Быстрый запуск

### Требования
- Python 3.8+
- Flutter 3.8+
- Docker & Docker Compose (для контейнеризации)

### Запуск через Docker Compose

```bash
# Скопировать и настроить переменные окружения
cp .env.template .env

# Запустить все сервисы
./start.sh
# или
docker-compose up -d

# Приложения будут доступны:
# - Информационная страница: http://localhost:8080
# - Django API: http://localhost:8000
# - Для Flutter приложения: запустите локально (см. инструкции ниже)
```

### Локальный запуск

#### Django API
```bash
cd prototype/prototype
pip install django djangorestframework djangorestframework-simplejwt django-cors-headers
python manage.py migrate
python manage.py runserver 8000
```

#### Flutter приложение
```bash
cd parser_app
flutter pub get
flutter run -d web-server --web-port 8080
# или для мобильной разработки:
flutter run
```

#### Python парсер
```bash
cd Parse
pip install pandas openpyxl
python main.py
```

## Переменные окружения

Смотрите `.env.template` для полного списка переменных окружения.

## Структура проекта

```
parser/
├── parser_app/          # Flutter приложение
│   ├── lib/            # Исходный код Dart
│   ├── android/        # Android специфичные файлы
│   ├── ios/           # iOS специфичные файлы
│   ├── web/           # Web специфичные файлы
│   └── pubspec.yaml   # Зависимости Flutter
├── prototype/          # Django API
│   └── prototype/
│       ├── parser/    # Django приложение
│       ├── prototype/ # Настройки проекта
│       └── manage.py  # Django CLI
├── Parse/             # Python парсер
│   ├── main.py       # Основной скрипт парсера
│   ├── output.xlsx   # Исходный Excel файл
│   └── doc.docx      # Документация (?)
├── docker-compose.yml # Docker Compose конфигурация
├── .env.template     # Шаблон переменных окружения
└── README.md         # Этот файл
```

## Безопасность

- JWT токены для аутентификации (15 мин access, 7 дней refresh)
- CORS настроен для работы с Flutter приложением
- Secure Storage для хранения токенов в Flutter
- **ВНИМАНИЕ**: В коде есть захардкоженные значения (SECRET_KEY), которые нужно вынести в переменные окружения для продакшена

## Известные проблемы

1. SECRET_KEY в Django захардкожен в коде
2. DEBUG=True в продакшене
3. ALLOWED_HOSTS пустой
4. Отсутствует requirements.txt для Python зависимостей
5. База данных SQLite (для продакшена рекомендуется PostgreSQL)

## Разработка

Проект содержит стандартную архитектуру Flutter + Django REST API. Для разработки рекомендуется:

1. Использовать виртуальное окружение Python для Django
2. Настроить hot reload в Flutter для быстрой разработки
3. Использовать Django admin для управления данными
4. Настроить CORS правильно для безопасности

## Автор

Проект создан для работы с каталогом товаров PKI_UL.