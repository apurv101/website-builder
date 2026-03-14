#!/usr/bin/env bash
set -euo pipefail

# Stop local development stack
# Data persists in the pgdata-local Docker volume between restarts.
# To wipe data: docker volume rm website-builder_pgdata-local

cd "$(dirname "$0")/.."

echo "==> Stopping local stack..."
docker compose -f docker-compose.local.yml down

echo "==> Local stack stopped. Data persists in Docker volume."
echo "    To wipe: docker volume rm website-builder_pgdata-local"
