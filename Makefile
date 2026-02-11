.PHONY: dev dev-web dev-api dev-infra dev-worker build test test-web test-api lint lint-web lint-api db-migrate db-seed setup

# ── Development ──────────────────────────────────────────────

dev: dev-infra dev-api dev-web ## Start all services for local dev

dev-web: ## Start frontend dev server
	cd apps/web && pnpm dev

dev-api: ## Start backend dev server
	cd apps/api && uv run uvicorn app.main:app --reload --port 8000

dev-infra: ## Start Docker infra (Redis + Supabase)
	docker compose -f infra/docker-compose.dev.yml up -d
	@echo "Starting Supabase..."
	cd supabase && supabase start

dev-worker: ## Start Celery worker + beat
	cd apps/api && uv run celery -A app.workers.celery_app worker --beat --loglevel=info

# ── Build ────────────────────────────────────────────────────

build: ## Build all apps
	cd apps/web && pnpm build
	cd apps/api && uv sync

# ── Test ─────────────────────────────────────────────────────

test: test-web test-api ## Run all tests

test-web: ## Run frontend tests
	cd apps/web && pnpm test

test-api: ## Run backend tests
	cd apps/api && uv run pytest

# ── Lint ─────────────────────────────────────────────────────

lint: lint-web lint-api ## Lint all code

lint-web: ## Lint frontend
	cd apps/web && pnpm lint && pnpm typecheck

lint-api: ## Lint backend
	cd apps/api && uv run ruff check . && uv run mypy src/

# ── Database ─────────────────────────────────────────────────

db-migrate: ## Run Supabase migrations
	cd supabase && supabase db push

db-seed: ## Seed local database
	cd supabase && supabase db reset

# ── Setup ────────────────────────────────────────────────────

setup: ## First-time project setup
	@echo "Setting up Smart Invoice Reminder AI..."
	cd apps/web && pnpm install
	cd apps/api && uv sync
	@echo "Done! Run 'make dev' to start developing."

# ── Help ─────────────────────────────────────────────────────

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
