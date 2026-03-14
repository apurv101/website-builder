#!/bin/bash
set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE_DIR="$(dirname "$SCRIPTS_DIR")"
SITES_DIR="${SITES_DIR:-$WORKSPACE_DIR/sites}"
DEPLOY_ROOT="/var/www/sites"
MAX_BACKUPS=3

red()   { printf '\033[0;31m%s\033[0m\n' "$*"; }
green() { printf '\033[0;32m%s\033[0m\n' "$*"; }
yellow(){ printf '\033[0;33m%s\033[0m\n' "$*"; }

usage() {
  echo "Usage:"
  echo "  $(basename "$0") <site-name>              Deploy a site"
  echo "  $(basename "$0") rollback <site-name>      Restore most recent backup"
  exit 1
}

# --- Rollback ---
do_rollback() {
  local site="$1"
  local deploy_dir="$DEPLOY_ROOT/$site"
  local latest
  latest=$(ls -1d "$deploy_dir"/dist.bak.* 2>/dev/null | sort -r | head -1 || true)

  if [ -z "$latest" ]; then
    red "No backups found for '$site'"
    exit 1
  fi

  echo "Restoring from: $(basename "$latest")"
  rm -rf "$deploy_dir/dist"
  cp -r "$latest" "$deploy_dir/dist"
  green "Rolled back '$site' to $(basename "$latest")"
}

# --- Argument parsing ---
if [ $# -eq 0 ]; then usage; fi

if [ "$1" = "rollback" ]; then
  [ $# -lt 2 ] && usage
  do_rollback "$2"
  exit 0
fi

SITE_NAME="$1"

# --- Validate site name ---
if ! echo "$SITE_NAME" | grep -qE '^[a-z0-9][a-z0-9-]*$'; then
  red "Invalid site name '$SITE_NAME': must be lowercase letters, numbers, hyphens"
  exit 1
fi

PROJECT_DIR="$SITES_DIR/$SITE_NAME"
if [ ! -d "$PROJECT_DIR" ]; then
  red "Project directory not found: $PROJECT_DIR"
  exit 1
fi

echo "=== Deploying $SITE_NAME ==="

# --- Step 1: Migrations ---
if [ -d "$PROJECT_DIR/migrations" ] && ls "$PROJECT_DIR/migrations"/*.sql >/dev/null 2>&1; then
  echo ""
  echo "--- Applying migrations ---"
  cd "$SCRIPTS_DIR"
  node migrate.js "$SITE_NAME"
else
  echo ""
  yellow "No migrations to apply"
fi

# --- Step 2: Install dependencies ---
echo ""
echo "--- Installing dependencies ---"
cd "$PROJECT_DIR"
NODE_ENV=development npm install

# --- Step 3: Type check ---
echo ""
echo "--- Type checking ---"
if NODE_ENV=development npx tsc -b; then
  green "Type check passed"
else
  red "Type errors found — deploy blocked"
  echo "Fix the errors above and try again."
  exit 1
fi

# --- Step 4: Build ---
echo ""
echo "--- Building ---"
if NODE_ENV=development npm run build; then
  green "Build succeeded"
else
  red "Build failed — deploy blocked"
  exit 1
fi

# --- Step 5: Validate build output ---
echo ""
echo "--- Validating build output ---"
ERRORS=0

if [ ! -f "$PROJECT_DIR/dist/index.html" ]; then
  red "Missing: dist/index.html"
  ERRORS=1
fi

if ! ls "$PROJECT_DIR/dist/assets/"*.js >/dev/null 2>&1; then
  red "Missing: JS bundles in dist/assets/"
  ERRORS=1
fi

if ! ls "$PROJECT_DIR/dist/assets/"*.css >/dev/null 2>&1; then
  red "Missing: CSS files in dist/assets/"
  ERRORS=1
fi

if [ -d "$PROJECT_DIR/public/images" ]; then
  if [ ! -d "$PROJECT_DIR/dist/images" ]; then
    red "Missing: dist/images/ (public/images/ exists but was not copied)"
    ERRORS=1
  fi
fi

if [ $ERRORS -ne 0 ]; then
  red "Build validation failed — deploy blocked"
  exit 1
fi

green "Build output valid"

# --- Step 6: Backup current deployment ---
DEPLOY_DIR="$DEPLOY_ROOT/$SITE_NAME"
mkdir -p "$DEPLOY_DIR"

if [ -d "$DEPLOY_DIR/dist" ]; then
  echo ""
  echo "--- Backing up current deployment ---"
  TIMESTAMP=$(date +%Y%m%d-%H%M%S)
  BACKUP_DIR="$DEPLOY_DIR/dist.bak.$TIMESTAMP"
  cp -r "$DEPLOY_DIR/dist" "$BACKUP_DIR"
  echo "Backup: $BACKUP_DIR"

  # Prune old backups, keep last $MAX_BACKUPS
  BACKUPS=$(ls -1d "$DEPLOY_DIR"/dist.bak.* 2>/dev/null | sort -r)
  COUNT=0
  while IFS= read -r backup; do
    COUNT=$((COUNT + 1))
    if [ $COUNT -gt $MAX_BACKUPS ]; then
      rm -rf "$backup"
      echo "Pruned old backup: $(basename "$backup")"
    fi
  done <<< "$BACKUPS"
fi

# --- Step 7: Deploy ---
echo ""
echo "--- Deploying to $DEPLOY_DIR/dist/ ---"
rm -rf "$DEPLOY_DIR/dist"
cp -r "$PROJECT_DIR/dist" "$DEPLOY_DIR/dist"

echo ""
green "=== Deployed $SITE_NAME ==="
echo "Live at: https://$SITE_NAME.zevza.com"
echo ""
echo "To rollback: $(basename "$0") rollback $SITE_NAME"
