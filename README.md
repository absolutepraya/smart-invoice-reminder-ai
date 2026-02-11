# Smart Invoice Reminder AI

AI-powered invoice collection automation with risk-based scoring and personalized reminders.

## Tech Stack

- **Frontend:** React + Vite, TanStack Router & Query, Tailwind CSS
- **Backend:** Python FastAPI
- **Database:** Supabase (Postgres)
- **Background Jobs:** Celery + Redis
- **AI:** NL2SQL model (external inference server)

## Quick Start

```bash
# Prerequisites: node, pnpm, uv, docker, supabase CLI

# First-time setup
chmod +x scripts/*.sh
./scripts/setup.sh

# Start development
make dev
```

| Service | URL |
|---|---|
| Web | http://localhost:3000 |
| API | http://localhost:8000 |
| API Docs | http://localhost:8000/docs |
| Supabase Studio | http://localhost:54323 |

## Commands

```bash
make dev            # Start all services
make dev-web        # Frontend only
make dev-api        # Backend only
make dev-infra      # Docker infra only
make dev-worker     # Celery worker + beat
make test           # Run all tests
make lint           # Lint all code
make db-migrate     # Run migrations
make db-seed        # Reset & seed database
make help           # Show all commands
```

## Project Structure

```
apps/
  web/              # React SPA (pnpm)
  api/              # FastAPI backend (uv)
supabase/           # Migrations & seed data
infra/              # Docker, Nginx, Compose
.github/workflows/  # CI/CD pipelines
scripts/            # Dev helper scripts
docs/               # Design documents
```
