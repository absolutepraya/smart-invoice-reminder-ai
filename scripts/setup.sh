#!/bin/bash
set -e

echo "=== Smart Invoice Reminder AI — Setup ==="

# Check prerequisites
command -v node >/dev/null 2>&1 || { echo "Node.js is required. Install via: brew install node"; exit 1; }
command -v pnpm >/dev/null 2>&1 || { echo "pnpm is required. Install via: npm install -g pnpm"; exit 1; }
command -v uv >/dev/null 2>&1 || { echo "uv is required. Install via: brew install uv"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "Docker is required. Install Docker Desktop."; exit 1; }
command -v supabase >/dev/null 2>&1 || { echo "Supabase CLI is required. Install via: brew install supabase/tap/supabase"; exit 1; }

# Install dependencies
echo "Installing frontend dependencies..."
cd apps/web && pnpm install
cd ../..

echo "Installing backend dependencies..."
cd apps/api && uv sync
cd ../..

# Copy env files
if [ ! -f apps/web/.env ]; then
    cp apps/web/.env.example apps/web/.env
    echo "Created apps/web/.env from template"
fi

if [ ! -f apps/api/.env ]; then
    cp apps/api/.env.example apps/api/.env
    echo "Created apps/api/.env from template"
fi

echo ""
echo "=== Setup complete! ==="
echo "Run 'make dev' to start developing."
