# ---------- Stage 1: build ----------
FROM instrumentisto/flutter AS build
# ^ стабильный официальный SDK. Можно заменить на :stable

WORKDIR /app

#  && flutter precache --web --web-renderer=canvaskit

# Кэш зависимостей
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Исходники и сборка
COPY . .

CMD [ "flutter", "run", "-d", "web-server",   "--release",   "--web-hostname", "0.0.0.0",   "--web-port", "5500",   "--dart-define=FLUTTER_WEB_RENDERER=canvaskit" ]

# ---------- Stage 2: static server ----------
# FROM nginx:alpine
# # добавить MIME для .wasm, не затирая стандартный файл
# RUN echo "    application/wasm wasm;" >> /etc/nginx/mime.types
# COPY nginx.conf /etc/nginx/conf.d/default.conf
# COPY --from=build /app/build/web /usr/share/nginx/html
# EXPOSE 8080
# CMD ["nginx","-g","daemon off;"]
