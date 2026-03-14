#!/bin/bash
set -e

# Create PostgREST roles
# Runs once when the 'websites' database is first initialized
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<EOSQL
CREATE ROLE web_anon NOLOGIN;
CREATE ROLE authenticator NOINHERIT LOGIN PASSWORD '${POSTGREST_PASSWORD:-postgrest_pass}';
GRANT web_anon TO authenticator;
EOSQL
