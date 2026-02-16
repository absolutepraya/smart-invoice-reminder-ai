# apps/api — FastAPI Backend

> **Auto-update this file.** This CLAUDE.md should always reflect the current state of the codebase. When you add or change something significant in `apps/api/` — new directories, patterns, dependencies, or conventions — update this file to stay accurate.

Python FastAPI backend for the Smart Invoice Reminder AI system.

## Tech Stack

- **FastAPI** — async web framework
- **Pydantic** — request/response validation
- **Supabase** — database (Postgres) via Python client
- **Celery + Redis** — background job processing and scheduling
- **httpx** — async HTTP client (for external API calls)
- **Ruff** — linting + formatting
- **mypy** — static type checking (strict mode)
- **pytest** — testing

## Commands

```bash
uv run uvicorn app.main:app --reload --port 8000   # Dev server
uv run ruff check .                                  # Lint
uv run ruff format .                                 # Format
uv run ruff check --fix .                            # Auto-fix lint
uv run mypy src/                                     # Type check
uv run pytest                                        # Tests
uv run celery -A app.workers.celery_app worker --beat --loglevel=info  # Worker + scheduler
```

## Architecture

```
src/app/
  main.py           → FastAPI app entry, middleware, router registration
  config.py         → Pydantic Settings (env vars)
  dependencies.py   → Shared FastAPI dependencies (get_db, etc.)
  routers/          → HTTP handlers (thin — delegate to services)
  services/         → Business logic (risk scoring, reminders, payments)
  models/           → Pydantic schemas (request/response)
  db/
    client.py       → Supabase client initialization
    queries/        → Raw database queries (one file per domain)
  workers/
    celery_app.py   → Celery config, Redis broker, Beat schedule
    check_overdue.py → Scheduled task: scan overdue invoices
    send_reminder.py → Task: generate and send reminder
tests/
  routers/
  services/
  workers/
```

### Request Flow

```
HTTP Request → Router → Service → DB Queries → Supabase
                          ↓
                    Pydantic Model (response)
```

### Background Job Flow

```
Celery Beat (cron) → check_overdue task → queries overdue invoices
                          ↓
                    dispatches send_reminder per invoice
                          ↓
                    generates message (risk-based) → sends email
```

### Key Patterns

- **Routers are thin** — handle HTTP concerns only (validation, auth, status codes). Delegate all logic to services.
- **Services hold business logic** — risk calculation, reminder generation, payment recording. No HTTP or DB specifics.
- **DB queries are isolated** — all Supabase interaction lives in `db/queries/`. Services never call Supabase directly.
- **Workers are independent** — Celery tasks run in separate processes. They use services and DB layer like routers do.

## Conventions

### Type Hints (MANDATORY)

Every function must have typed parameters and return type:

```python
async def calculate_risk(self, client_id: str) -> RiskLevel:
    ...

async def get_overdue_invoices(db: Client) -> list[dict]:
    ...
```

### Router Pattern

```python
from fastapi import APIRouter, Depends
from supabase import Client

from app.dependencies import get_db
from app.models.invoice import InvoiceResponse
from app.services.invoice_service import InvoiceService

router = APIRouter()

@router.get("/overdue")
async def list_overdue(db: Client = Depends(get_db)) -> list[InvoiceResponse]:
    service = InvoiceService(db)
    return await service.list_overdue()
```

### Service Pattern

```python
from supabase import Client
from app.db.queries.invoices import get_overdue_invoices

class InvoiceService:
    def __init__(self, db: Client) -> None:
        self.db = db

    async def list_overdue(self) -> list[dict]:
        return await get_overdue_invoices(self.db)
```

### Pydantic Models

```python
from pydantic import BaseModel

class InvoiceResponse(BaseModel):
    id: str
    client_id: str
    amount: float
    status: str
    risk_level: str
```

### Celery Tasks

```python
from app.workers.celery_app import celery_app

@celery_app.task(bind=True, max_retries=3)
def send_reminder(self, invoice_id: str, risk_level: str) -> None:
    try:
        # task logic
        pass
    except Exception as exc:
        self.retry(exc=exc, countdown=60)
```

### Formatting
- Double quotes for strings (Ruff enforced)
- Line length: 100 characters
- Imports sorted by Ruff (isort rules)

## Common Pitfalls

- **Never skip type hints** — all functions need typed params and return types
- **Never put business logic in routers** — routers are thin, services hold logic
- **Never call Supabase directly from services** — use `db/queries/` layer
- **Never create Supabase clients manually** — use `get_db` dependency
- **Never use synchronous code in async handlers** — use `async/await` throughout
- **Never use `print()` for logging** — use Python's `logging` module
- **Don't hardcode config values** — use `config.py` (reads from env vars)
- **Don't mix worker logic with API logic** — workers use services, not routers

## Environment Variables

Defined in `config.py` via Pydantic Settings:

| Variable | Description | Default |
|---|---|---|
| `SUPABASE_URL` | Supabase instance URL | (required) |
| `SUPABASE_KEY` | Supabase anon/service key | (required) |
| `REDIS_URL` | Redis broker URL | `redis://localhost:6379/0` |
| `CORS_ORIGINS` | Allowed CORS origins | `["http://localhost:3000"]` |
