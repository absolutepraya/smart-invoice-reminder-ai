# Smart Invoice Reminder AI

AI-powered invoice collection automation with risk-based scoring and personalized reminders.

## Table of Contents

- [What Is This?](#what-is-this)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [IDE Setup](#ide-setup)
- [Getting Started](#getting-started)
- [Common Commands](#common-commands)
- [Project Structure](#project-structure)
- [AI-First Development](#ai-first-development)
- [How Git Hooks Work](#how-git-hooks-work)
- [Development Workflow](#development-workflow)
- [Troubleshooting](#troubleshooting)

## What Is This?

A system that automatically reminds clients to pay their invoices. It:
1. Checks which invoices are overdue (daily)
2. Scores each client's payment risk using ML — predicts likelihood of late payment and categorizes as LOW/MEDIUM/HIGH
3. Generates and sends personalized reminders with tone adapted to risk level — polite (SOPAN), firm (TEGAS), or warning (PERINGATAN) — via email, WhatsApp, or SMS
4. Provides a dashboard for the finance team to monitor everything

## Tech Stack

| Tool | What it does | Why we chose it |
|---|---|---|
| **React + Vite** | Frontend UI | Fast dev server, simple SPA — no SSR overhead for a dashboard |
| **TanStack Router** | Page routing | Type-safe routes, file-based — cleaner than React Router |
| **TanStack Query** | API data fetching | Auto-caching, refetching, loading states — no manual state management |
| **Tailwind CSS** | Styling | Utility classes, fast to build UIs, no CSS file management |
| **FastAPI** | Backend API | Async Python, auto-generates API docs, great with Pydantic |
| **Pydantic** | Data validation | Type-safe request/response models for Python |
| **Supabase** | Database (Postgres) | Hosted Postgres with auth, dashboard, and local dev support |
| **Celery + Redis** | Background jobs | Reliable scheduled tasks (daily invoice checks, sending emails) |
| **Biome** | Frontend linting/formatting | Faster than ESLint, lints + formats in one tool |
| **Ruff** | Python linting/formatting | Same idea as Biome but for Python — blazing fast |

## Prerequisites

macOS install commands (run these one by one):

```bash
# 1. Node.js (v22+)
brew install node

# 2. pnpm (package manager for JS — we don't use npm)
npm install -g pnpm

# 3. Python (3.12+)
brew install python@3.12

# 4. uv (package manager for Python — we don't use pip directly)
brew install uv

# 5. Docker Desktop (for running Redis and Supabase locally)
brew install --cask docker
# Then open Docker Desktop and let it finish starting up

# 6. Supabase CLI
brew install supabase/tap/supabase

# 7. GitHub CLI (for creating PRs)
brew install gh
gh auth login
```

Verify everything is installed:

```bash
node -v       # Should be v22+
pnpm -v       # Should be v9+
python3 -V    # Should be 3.12+
uv --version  # Should show version
docker -v     # Should show version
supabase -v   # Should show version
gh --version  # Should show version
```

## IDE Setup

### VS Code / Cursor Extensions

Install these extensions (search by ID in the extensions panel):

| Extension | ID | What it does |
|---|---|---|
| **Biome** | `biomejs.biome` | Frontend linting + formatting (replaces ESLint + Prettier) |
| **Python** | `ms-python.python` | Python language support |
| **Ruff** | `charliermarsh.ruff` | Python linting + formatting |
| **Tailwind IntelliSense** | `bradlc.vscode-tailwindcss` | Tailwind class autocomplete |
| **mypy** | `ms-python.mypy-type-checker` | Python type checking in editor |

### Recommended Settings

Add to your VS Code `settings.json` (Cmd+Shift+P → "Open User Settings JSON"):

```json
{
  "editor.defaultFormatter": "biomejs.biome",
  "editor.formatOnSave": true,
  "[python]": {
    "editor.defaultFormatter": "charliermarsh.ruff"
  },
  "editor.codeActionsOnSave": {
    "source.organizeImports": "explicit"
  }
}
```

## Getting Started

```bash
# 1. Clone the repo
git clone <repo-url>
cd smart-invoice-reminder-ai

# 2. Install all dependencies
make install

# 3. Set up environment variables
cp .env.example .env.local

# 4. Start Docker Desktop (if not already running)
open -a Docker

# 5. Start everything
make dev
```

Once running:

| Service | URL |
|---|---|
| Web Dashboard | http://localhost:3000 |
| API | http://localhost:8000 |
| API Docs (Swagger) | http://localhost:8000/docs |
| Supabase Studio | http://localhost:54323 |

## Common Commands

```bash
# Daily development
make dev              # Start everything (Redis, Supabase, API, Web)
make dev-web          # Frontend only
make dev-api          # Backend only

# Code quality (run before committing)
make lint             # Lint everything
make format           # Auto-fix formatting
make test             # Run all tests

# Database
make db-migrate       # Apply schema changes
make db-seed          # Reset DB with sample data

# See all commands
make help
```

## Project Structure

```
smart-invoice-reminder-ai/
├── apps/
│   ├── web/                 # Frontend — React + Vite SPA
│   │   ├── src/routes/      # Pages (file-based routing)
│   │   ├── src/queries/     # API hooks (TanStack Query)
│   │   ├── src/components/  # Reusable UI components
│   │   ├── src/lib/         # Utilities (API client, formatters)
│   │   └── src/types/       # TypeScript interfaces
│   └── api/                 # Backend — FastAPI
│       ├── src/app/routers/ # API endpoints (thin handlers)
│       ├── src/app/services/# Business logic (risk scoring, reminders)
│       ├── src/app/models/  # Request/response schemas (Pydantic)
│       ├── src/app/db/      # Database queries (Supabase)
│       └── src/app/workers/ # Background jobs (Celery)
├── supabase/                # DB migrations + seed data
├── infra/                   # Dockerfiles, Compose, Nginx
├── .github/workflows/       # CI (runs on every PR) + deploy
├── .claude/commands/        # AI assistant commands
└── docs/plans/              # Design documents
```

## AI-First Development

This project is set up for **AI-assisted development** (Claude Code, GitHub Copilot, Cursor, Codex, etc.).

**What are these files?**

| File/Dir | Purpose |
|---|---|
| `CLAUDE.md` | Instructions for Claude Code — project conventions, patterns, pitfalls |
| `AGENTS.md` | Symlink to `CLAUDE.md` — same content, for tools that read `AGENTS.md` (like Codex) |
| `.claude/` | Commands and config for Claude Code |
| `.agents/` | Symlink to `.claude/` — same content, for other AI tools |

Each subdirectory (`apps/web/`, `apps/api/`) has its own `CLAUDE.md` with context-specific instructions.

**You don't need to read these files** — they're for AI tools. But if you're curious about project conventions, they're a good reference.

## How Git Hooks Work

Git hooks are scripts that run automatically when you `git commit` or `git push`. They catch issues **before** code reaches GitHub.

### Pre-Commit (runs on every `git commit`)

These checks run automatically — you don't need to do anything:

1. **Biome** — checks frontend code for lint/format errors
2. **Ruff** — checks Python code for lint/format errors
3. **tsc** — checks for TypeScript compile errors
4. **mypy** — checks for Python type errors
5. **Knip** — checks for dead/unused code in frontend

If any check fails, the commit is **blocked**. Fix the issue and try again:

```bash
# Most common fix — auto-format your code
make format

# Then try committing again
git add . && git commit -m "your message"
```

### Pre-Push (runs on every `git push`)

Runs type checks and tests for both frontend and backend. If tests fail, the push is blocked.

### First Time Setup

Hooks are installed automatically when you run `make install` (via Husky). If hooks aren't running, manually install:

```bash
pnpm install    # In project root — this triggers Husky setup
```

## Development Workflow

### Branch Naming

```
<name>/<type>/<short-description>
```

- **name** — your nickname (e.g. `abhip`, `daffa`)
- **type** — `feat`, `fix`, `refactor`, `chore`, `test`, `docs`
- **short-description** — kebab-case, what it's about

Examples:
```
abhip/feat/automate-email-sending
abhip/fix/risk-scoring-crash
abhip/chore/refactor-dashboard-page
```

### Workflow

```bash
# Create a feature branch from main
git checkout main
git pull
git checkout -b abhip/feat/invoice-list-page

# Work on your changes...

# Commit (hooks will run automatically)
git add .
git commit -m "feat(web): add invoice list page"

# Push
git push -u origin abhip/feat/invoice-list-page
```

### Commit Message Format

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(scope): short description
```

**Types**: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`
**Scopes**: `web`, `api`, `worker`, `infra`, `db`, `ci`

Examples:
```
feat(web): add client risk history chart
fix(api): handle empty invoice list
chore(infra): update Docker base image
```

### Pull Requests

```bash
# After pushing your branch, create a PR
gh pr create --title "feat(web): add invoice list page" --body "Added the invoice list with sorting and filtering"
```

## Troubleshooting

**"Port 3000/8000 already in use"**
```bash
# Find and kill the process using the port
lsof -i :3000    # or :8000
kill -9 <PID>
```

**"Docker is not running"**
```bash
open -a Docker    # Start Docker Desktop, wait for it to finish
```

**"Supabase won't start"**
```bash
# Make sure Docker is running first, then:
supabase stop     # Stop any existing instance
supabase start    # Start fresh
```

**"Pre-commit hook failed"**
```bash
make format       # Auto-fix most lint/format issues
# Then try committing again
```

**"pnpm: command not found"**
```bash
npm install -g pnpm
```

**"uv: command not found"**
```bash
brew install uv
```

