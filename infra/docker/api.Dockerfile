FROM python:3.12-slim
LABEL org.opencontainers.image.source=https://github.com/absolutepraya/smart-invoice-reminder-ai

WORKDIR /app

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

COPY apps/api/pyproject.toml apps/api/uv.lock* ./
RUN uv sync --no-dev --frozen

COPY apps/api/src/ ./src/

EXPOSE 8000
CMD ["uv", "run", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
