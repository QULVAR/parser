FROM nginx:alpine
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
# сюда положим собранный Flutter Web
COPY parser_app/build/web /usr/share/nginx/html