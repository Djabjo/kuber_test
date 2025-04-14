# Используем мульти-архитектурный базовый образ
FROM --platform=$BUILDPLATFORM python:3.9-slim as builder

WORKDIR /app
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Устанавливаем зависимости для сборки (только для ARM)
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Финальный образ для запуска
FROM python:3.9-slim

WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY . .

ENV PATH="/root/.local/bin:$PATH" \
    VERSION=1.2.0

CMD ["python", "Bot.py"]