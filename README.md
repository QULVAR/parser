# Амерта

Приложение на **Flutter** и сервер на **Django** (REST API).
Всё запускается через **Docker**, чтобы не ставить вручную кучу зависимостей.

## Что внутри
- **parser_app/** — фронт (Flutter). Там же админка.
- **prototype/** — сервер (Django). Отдаёт API.
- **docker/** — файлы для сборки контейнеров и настройки nginx.
- **docker-compose.yml** — общий запуск всего проекта одной командой.

## Как запустить

Перед запуском через Docker желательно собрать web‑версию. Если Flutter не трогали — можно пропустить этот шаг:

```bash
cd parser_app
flutter pub get
flutter build web --release
cd ..
```

Поднимаем докер:
```bash
docker compose up -d --build
```

Если до этого уже был build, то достаточно:
```bash
docker compose up -d
```

Посмотреть логи (если что-то не стартует):
```bash
docker compose logs -f
```

Остановить проект:
```bash
docker compose down
```

- Приложение (Web): http://localhost/
- API (сервер): http://localhost/api/

## Что осталось доделать (планы)
- Навести порядок в файлах Flutter‑проекта
- Чуть лучше подогнать интерфейс под разные размеры экранов
