# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Core Development Philosophy

### 1. Leave It Better Than You Found It
When working on any feature, if you encounter code that could be improved and the refactoring is small (< 100 lines), **do it now**. This maintains high development velocity. For larger refactorings, create a backlog issue.

### 2. YAGNI (You Ain't Gonna Need It)
Solve today's problem with the simplest solution that works. Avoid premature abstraction and overengineering. Keep code flexible for future changes but don't build features "just in case". When abstraction becomes necessary, create a ticket to plan it properly.

### 3. Move Fast, Break Things (Pre-Launch)
We haven't launched yet and will remain lean. Don't worry about backwards compatibility unless explicitly requested. Make bold changes that improve the codebase without fear of breaking existing users.

### 4. Complexity Over Time Estimates
We don't believe in time estimates - they're never accurate. Instead, estimate task complexity:
- **Small (S)**: < 100 lines, clear solution
- **Medium (M)**: 100-500 lines, some exploration needed
- **Large (L)**: 500+ lines, requires design/planning
- **Extra Large (XL)**: Major architectural changes

### 5. Package Managers
- **Frontend**: Always use `pnpm` — never npm/npx
- **Backend**: Always use `uv` — never pip/pip3 directly

## Critical Development Practices (MUST FOLLOW)

- **ALWAYS read the code thoroughly and dig deeper** - Don't trust surface-level assumptions. When fixing bugs, trace through the entire flow to understand the complete picture
- **NEVER use `any` type in TypeScript** - Always infer or define proper types
- **NEVER use untyped Python** - Always use type hints for function signatures, return types, and complex variables
- **PREFER editing/refactoring existing files over creating new ones** - Check if functionality already exists before creating new files
- **PREFER integration tests over unit tests** - Integration tests catch real-world issues and validate the entire flow
- **When user says "I'm not convinced", dig deeper** - This means the initial solution might be superficial
- **Keep error handling simple** - We're pre-launch. Use simple error messages, no error codes, no translations
- **ALWAYS use test/mock/dummy markers in test data** - All mock API keys, tokens, and secrets MUST include `test`, `mock`, `dummy`, `example`, or `placeholder` in the value itself
  - Valid: `sk_test_4eC39HqLyjWDarjtT657`, `example_api_key_12345`, `MOCK_SECRET_KEY_abc123`
  - Invalid: `sk_live_4eC39HqLyjWDarjtT657`, `real-looking-api-key-12345`

## Git Operations Policy (CRITICAL)

**NEVER perform git operations automatically. ALWAYS wait for explicit user instruction.**

- **NEVER commit automatically** - Only create commits when the user explicitly asks you to commit
- **NEVER push automatically** - Only push when the user explicitly asks you to push
- **NEVER create PRs automatically** - Only create PRs when the user explicitly asks
- **ALWAYS ask for confirmation** - When user requests git operations, confirm what you're about to do

**Valid user requests that warrant git operations:**
- "commit this" / "create a commit" / "commit these changes"
- "push to remote" / "push the changes"
- "create a PR"

**DO NOT commit/push for:**
- Completing a feature (wait for user to say "commit this")
- Fixing bugs (wait for user instruction)
- "Leave it better than you found it" refactoring (only commit if user explicitly requests it)
- End of conversation (never auto-commit as a cleanup action)

## Project Overview

**Smart Invoice Reminder AI** is an AI-powered system that automates invoice collection reminders. It monitors payment status, assesses client risk levels using ML, and sends personalized reminders with appropriate tone — polite (SOPAN), firm (TEGAS), or warning (PERINGATAN) — based on each client's payment behavior.

### Key Features
- **ML Risk Scoring Pipeline** - Trained ML model runs inside the Celery Worker to predict payment likelihood using payment history (days_late), logs probability scores with model versioning for drift detection
- **Smart Reminder Generator** - Generates contextual reminders adapted to risk level (LOW→SOPAN, MEDIUM→TEGAS, HIGH→PERINGATAN) via EMAIL/WHATSAPP/SMS
- **Payment Tracking** - Records payments with late-day calculation as key ML training feature
- **Automated Workflow** - Celery-based scheduled checks and reminder dispatch with duplicate-send prevention
- **AR Dashboard** - Real-time visibility into receivables and risk levels

## Monorepo Structure

```
apps/
  web/          # React + Vite SPA (TanStack Router/Query, Tailwind)
  api/          # FastAPI backend (Pydantic, Celery, Supabase)
infra/          # Docker, Nginx, Compose configs
supabase/       # Migrations, seed data, config
.github/        # CI/CD workflows
docs/           # Design documents and plans
```

- **apps/web/** - Frontend dashboard (see `apps/web/CLAUDE.md`)
- **apps/api/** - Backend API + workers (see `apps/api/CLAUDE.md`)
- **infra/** - Production Docker Compose + dev infra (Redis, Supabase)
- **supabase/** - Database schema, migrations, seed data

## Essential Commands

### Development
```bash
# Install dependencies
make install

# Start all services (Redis + Supabase via Docker, API + Web natively)
make dev

# Start individual services
make dev-web        # Frontend only (port 3000)
make dev-api        # Backend only (port 8000)
make dev-infra      # Docker infra only (Redis, Supabase)
make dev-worker     # Celery worker + beat scheduler
```

### Code Quality
```bash
# Lint all code
make lint           # Runs biome (web) + ruff + mypy (api)

# Lint individually
make lint-web       # Biome check + tsc --noEmit
make lint-api       # Ruff check + format check + mypy

# Format all code
make format         # Auto-fix formatting
make format-web     # Biome format (web)
make format-api     # Ruff format (api)

# Dead code detection
cd apps/web && pnpm knip
```

### Testing
```bash
make test           # Run all tests
make test-web       # Frontend tests (vitest)
make test-api       # Backend tests (pytest)
```

### Database
```bash
make db-migrate     # Run Supabase migrations
make db-seed        # Reset and seed local database
```

### Service URLs (Local Dev)
| Service | URL |
|---|---|
| Web | http://localhost:3000 |
| API | http://localhost:8000 |
| API Docs | http://localhost:8000/docs |
| Supabase Studio | http://localhost:54323 |

## Architecture Patterns

### Frontend: Route → Query → Page → Component
- **Routes** (`src/routes/`) are thin — just point to page components
- **Queries** (`src/queries/`) hold all TanStack Query hooks, one file per domain
- **Pages** (`src/pages/`) are the actual page content
- **Components** (`src/components/`) are reusable UI pieces
- **Lib** (`src/lib/`) is shared utilities used across the app

### Backend: Router → Service → DB
- **Routers** (`routers/`) handle HTTP concerns (validation, auth, status codes)
- **Services** (`services/`) hold business logic (risk scoring, reminder generation, payment tracking)
- **DB** (`db/`) isolates all Supabase/SQL interaction
- **Workers** (`workers/`) are Celery tasks that run independently

### Background Jobs
- **Celery Beat** triggers scheduled tasks (daily overdue invoice check)
- **Celery Workers** execute tasks (risk scoring, reminder generation, email sending)
- **Redis** serves as the message broker

## Development Workflow

### Branch Naming
Format: `<name>/<type>/<short-description>` (e.g. `abhip/feat/automate-email-sending`, `abhip/fix/risk-scoring-crash`)

### Planning & Implementation
1. **For substantial changes (500+ lines)**: Create brief design document in `docs/plans/`
2. **Question assumptions**: "What's the fastest way to test this hypothesis?"
3. **Study existing patterns** before creating new ones
4. **Rapid validation**: "Can we implement 20% to get 80% value?"

### Code Quality Checklist
- [ ] TypeScript compiles without errors (`cd apps/web && pnpm typecheck`)
- [ ] Python type checks pass (`cd apps/api && uv run mypy src/`)
- [ ] All tests pass locally (`make test`)
- [ ] Biome linting passes (`cd apps/web && pnpm lint`)
- [ ] Ruff linting passes (`cd apps/api && uv run ruff check .`)
- [ ] No dead code detected (`cd apps/web && pnpm knip`)
- [ ] Follow existing patterns in codebase

## Frontend Practices (TypeScript/React)

- **Biome** for linting and formatting (NOT ESLint)
- **TanStack Query** for all API calls — never use raw `fetch` or `axios` in components
- **TanStack Router** for routing — file-based routes in `src/routes/`
- **Tailwind CSS** for styling — no CSS modules or styled-components
- Use `import type` for type-only imports
- Single quotes, no semicolons (Biome enforced)
- Path alias `@/*` maps to `src/*`

## Backend Practices (Python/FastAPI)

- **Ruff** for linting and formatting
- **mypy** for static type checking (strict mode)
- **Pydantic** for all request/response models — never use raw dicts for API boundaries
- **async/await** for all route handlers and service methods
- All functions must have **type hints** for parameters and return types
- Use `httpx` for external API calls (async-native)
- Double quotes for strings (Ruff enforced)
- Line length: 100 characters

### FastAPI Conventions
```python
# Router: thin handler, delegates to service
@router.get("/invoices/overdue")
async def list_overdue(db: Client = Depends(get_db)) -> list[InvoiceResponse]:
    service = InvoiceService(db)
    return await service.list_overdue()

# Service: business logic, no HTTP concerns
class InvoiceService:
    async def list_overdue(self) -> list[dict]:
        return await get_overdue_invoices(self.db)

# DB: pure data access
async def get_overdue_invoices(db: Client) -> list[dict]:
    return db.table("invoices").select("*").eq("status", "OVERDUE").execute().data
```

### Celery Task Conventions
```python
@celery_app.task(bind=True, max_retries=3)
def send_reminder(self, invoice_id: str, risk_level: str) -> None:
    try:
        # task logic
        pass
    except Exception as exc:
        self.retry(exc=exc, countdown=60)
```

## Problem-Solving Approach

### When Debugging Issues
1. **Read the entire flow** - Don't stop at the surface level
2. **Question initial assumptions** - If user says "I'm not convinced", your first solution was likely superficial
3. **Verify fixes at the right layer** - Frontend bug? Check if it's actually a backend issue first

### When Writing Code
1. **Check for existing implementations first** - Don't create duplicate functionality
2. **Type safety is non-negotiable** - TypeScript: no `any`. Python: type hints everywhere
3. **Test at the right level** - Integration tests for features, unit tests for pure logic

## Common Pitfalls to Avoid

### General
1. **NEVER auto-commit/push/create PRs** - Only perform git operations when explicitly requested
2. **Don't create new files unnecessarily** - Extend existing implementations
3. **Don't commit dead code** - Run knip (web) and ruff (api) to detect unused code
4. **Don't trust surface-level code reading** - Always trace the complete flow

### Frontend
5. **Never use `any` type** - Always find and use the proper type
6. **Don't use raw fetch/axios in components** - Use TanStack Query hooks in `src/queries/`
7. **Don't run lint from apps/web/** - Use `pnpm lint` which runs Biome
8. **Don't manually manage server state** - TanStack Query handles caching, refetching, and stale data

### Backend
9. **Never skip type hints** - All functions must have typed parameters and return types
10. **Don't put business logic in routers** - Routers are thin, services hold logic
11. **Don't access DB directly from services** - Always use the `db/queries/` layer
12. **Don't create Supabase clients manually** - Use the `get_db` dependency
13. **Don't use synchronous code in async handlers** - Use `async/await` throughout

### Infrastructure
14. **Don't modify docker-compose.dev.yml for prod settings** - Dev and prod are separate files
15. **Don't hardcode secrets** - Use `.env` files and `config.py` settings

## Dead Code Detection

### Frontend (Knip)
```bash
cd apps/web && pnpm knip       # Check for dead code
```
Configure exceptions in `apps/web/knip.config.ts`.

### Backend (Ruff)
Ruff automatically checks for:
- `F401` - Unused imports
- `F841` - Unused variables

These run as part of `make lint-api`.

## Pre-commit Hooks

Husky runs these checks before every commit:
1. **Biome check** (web) - Lint + format
2. **Ruff check** (api) - Lint + format
3. **tsc --noEmit** (web) - Type check
4. **mypy src/** (api) - Type check
5. **Knip** (web) - Dead code detection

Pre-push runs tests and type checks for both apps.

## Quick Reference

### File Naming
- Use `kebab-case` for all files (e.g., `invoice-detail.tsx`, `risk_service.py`)
- Python: `snake_case` for modules and files
- TypeScript: `kebab-case` for files, `PascalCase` for components

### Environment Setup
```bash
# Prerequisites
node >= 22, pnpm >= 9, python >= 3.12, uv, docker, supabase CLI

# First time
make install

# Daily
make dev              # Start everything
```

## Remember

Focus and momentum are crucial. Every line of code should either:
1. Directly improve user experience
2. Enhance development velocity
3. Reduce technical risk

**"Perfect is the enemy of shipped."** - Ship fast, iterate based on feedback.
