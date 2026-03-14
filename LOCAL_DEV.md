# Local Development

Run the full stack (PostgreSQL + PostgREST + Vite) locally so API calls work without deploying to EC2.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (or Docker Engine + Compose)
- Node.js 18+

## Setup

```bash
# 1. Start the local database + API stack
./scripts/local-up.sh

# This starts:
#   PostgreSQL on localhost:5433
#   PostgREST  on http://localhost:3001
```

The script creates `.env` from `.env.local.example` if it doesn't exist. Default password is `localdev`.

## Per-site workflow

```bash
cd workspace/sites/my-site

# Tell Vite which site schema to use (needed because localhost != subdomain)
echo "VITE_SITE_NAME=my-site" >> .env

# Apply database migrations locally
DATABASE_URL=postgres://postgres:localdev@localhost:5433/websites \
  node ../../scripts/migrate.js my-site

# Start dev server — API calls proxy to local PostgREST
npm run dev
# Open http://localhost:5173
```

The Vite dev server proxy (`/api` → `localhost:3001`) is configured in `vite.config.ts`. This only affects dev mode — production builds are unaffected.

## Deploying to production

```bash
# Deploy a site to EC2 (builds locally, uploads to server)
./scripts/local-deploy.sh my-site

# Site goes live at: https://my-site.zevza.com
```

This runs migrations on the production database, builds the frontend locally, and uploads `dist/` to the EC2 server.

## Stopping

```bash
./scripts/local-down.sh
```

Data persists in a Docker volume between restarts. To wipe:
```bash
docker volume rm website-builder_pgdata-local
```

## OpenClaw web app (optional)

To run the OpenClaw agent interface locally (separate from site development):
```bash
docker compose up
# Accessible on port 18789
```

## Troubleshooting

**PostgREST won't start:** Check Postgres is healthy first: `docker compose -f docker-compose.local.yml logs db`. If the init scripts haven't run, the volume may have stale data — wipe it and restart.

**Port conflicts:** If 5433 or 3001 are in use, stop the conflicting service or change ports in `docker-compose.local.yml`.

**API returns 404:** Make sure you've run migrations for your site and that `VITE_SITE_NAME` is set in the site's `.env` file.

**Schema not found:** PostgREST caches schemas. After running migrations, send a reload signal: `docker compose -f docker-compose.local.yml kill -s SIGUSR1 postgrest`
