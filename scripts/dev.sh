#!/bin/bash
set -e

echo "=== Starting dev environment ==="

# Start infrastructure
echo "Starting Docker infra (Redis)..."
docker compose -f infra/docker-compose.dev.yml up -d

echo "Starting Supabase..."
cd supabase && supabase start
cd ..

# Start services in background
echo "Starting API server..."
cd apps/api && uv run uvicorn app.main:app --reload --port 8000 &
API_PID=$!
cd ../..

echo "Starting web dev server..."
cd apps/web && pnpm dev &
WEB_PID=$!
cd ../..

echo ""
echo "=== Dev environment running ==="
echo "  Web: http://localhost:3000"
echo "  API: http://localhost:8000"
echo "  Supabase Studio: http://localhost:54323"
echo ""
echo "Press Ctrl+C to stop all services."

trap "kill $API_PID $WEB_PID 2>/dev/null; docker compose -f infra/docker-compose.dev.yml down" EXIT
wait
