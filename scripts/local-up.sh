#!/usr/bin/env bash
set -euo pipefail

# Start local development stack (PostgreSQL + PostgREST)
# Usage: ./scripts/local-up.sh

cd "$(dirname "$0")/.."

# Create .env from example if it doesn't exist
if [ ! -f .env ]; then
  echo "==> Creating .env from .env.local.example"
  cp .env.local.example .env
fi

echo "==> Starting local stack (PostgreSQL + PostgREST)..."
docker compose -f docker-compose.local.yml up -d

echo "==> Waiting for PostgreSQL to be healthy..."
timeout=60
elapsed=0
while ! docker compose -f docker-compose.local.yml exec -T db pg_isready -U postgres -d websites >/dev/null 2>&1; do
  sleep 1
  elapsed=$((elapsed + 1))
  if [ $elapsed -ge $timeout ]; then
    echo "ERROR: PostgreSQL failed to start within ${timeout}s"
    docker compose -f docker-compose.local.yml logs db
    exit 1
  fi
done
echo "    PostgreSQL ready (${elapsed}s)"

echo "==> Waiting for PostgREST..."
elapsed=0
while ! curl -sf http://localhost:3001/ >/dev/null 2>&1; do
  sleep 1
  elapsed=$((elapsed + 1))
  if [ $elapsed -ge $timeout ]; then
    echo "ERROR: PostgREST failed to start within ${timeout}s"
    docker compose -f docker-compose.local.yml logs postgrest
    exit 1
  fi
done
echo "    PostgREST ready (${elapsed}s)"

echo ""
echo "==> Local stack is running!"
echo "    PostgreSQL: localhost:5433  (user: postgres, password: localdev)"
echo "    PostgREST:  http://localhost:3001"
echo "    DATABASE_URL=postgres://postgres:localdev@localhost:5433/websites"
echo ""
echo "    Next steps:"
echo "      cd workspace/sites/<your-site>"
echo "      echo 'VITE_SITE_NAME=<your-site>' >> .env"
echo "      DATABASE_URL=postgres://postgres:localdev@localhost:5433/websites node ../../scripts/migrate.js <your-site>"
echo "      npm run dev"
