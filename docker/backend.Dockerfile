FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /repo
COPY . /repo

WORKDIR /repo/prototype/prototype

RUN pip install --no-cache-dir -r requirements.txt

CMD ["sh", "-c", "python manage.py migrate && gunicorn prototype.wsgi:application --bind 0.0.0.0:8000"]