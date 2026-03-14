#!/usr/bin/env bash
set -euo pipefail

# Deploy a site from local machine to EC2 production
# Usage: ./scripts/local-deploy.sh <site-name>

SITE_NAME="${1:-}"
if [ -z "$SITE_NAME" ]; then
  echo "Usage: ./scripts/local-deploy.sh <site-name>"
  exit 1
fi

# Validate site name
if ! echo "$SITE_NAME" | grep -qE '^[a-z0-9][a-z0-9-]*[a-z0-9]$|^[a-z0-9]$'; then
  echo "ERROR: Site name must be lowercase alphanumeric with optional hyphens"
  exit 1
fi

cd "$(dirname "$0")/.."

EC2_IP="${EC2_IP:-3.223.52.227}"
EC2_USER="${EC2_USER:-ubuntu}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/openclaw-key.pem}"
SSH="ssh -i $SSH_KEY -o StrictHostKeyChecking=no $EC2_USER@$EC2_IP"
SCP="scp -i $SSH_KEY -o StrictHostKeyChecking=no"

SITE_DIR="workspace/sites/$SITE_NAME"

if [ ! -d "$SITE_DIR" ]; then
  echo "ERROR: Site directory not found: $SITE_DIR"
  exit 1
fi

# Step 1: Run migrations on production DB (if migrations/ exists)
if [ -d "$SITE_DIR/migrations" ]; then
  echo "==> Running migrations on production..."
  $SSH "cd ~/website-builder && DATABASE_URL=\"postgres://postgres:\$(grep POSTGRES_PASSWORD /home/ubuntu/openclaw/infra/.env | cut -d= -f2)@localhost:5432/websites\" node workspace/scripts/migrate.js $SITE_NAME"
  echo "    Migrations applied."
else
  echo "==> No migrations directory, skipping."
fi

# Step 2: Build locally
echo "==> Installing dependencies..."
(cd "$SITE_DIR" && NODE_ENV=development npm install)

echo "==> Type checking..."
(cd "$SITE_DIR" && npx tsc -b) || {
  echo "ERROR: TypeScript errors found. Fix them before deploying."
  exit 1
}

echo "==> Building..."
(cd "$SITE_DIR" && npm run build)

# Step 3: Validate dist/
if [ ! -f "$SITE_DIR/dist/index.html" ]; then
  echo "ERROR: Build failed — dist/index.html not found"
  exit 1
fi

DIST_SIZE=$(du -sh "$SITE_DIR/dist" | cut -f1)
echo "    Build output: $DIST_SIZE"

# Step 4: Deploy dist/ to EC2
REMOTE_DIR="/var/www/sites/$SITE_NAME/dist"

echo "==> Backing up current deployment..."
$SSH "if [ -d $REMOTE_DIR ]; then sudo cp -r $REMOTE_DIR ${REMOTE_DIR}.bak.\$(date +%s); fi"

echo "==> Uploading dist/ to EC2..."
$SSH "sudo mkdir -p $REMOTE_DIR"
# SCP to temp dir, then move (avoids permission issues)
$SSH "mkdir -p /tmp/deploy-$SITE_NAME"
$SCP -r "$SITE_DIR/dist/"* "$EC2_USER@$EC2_IP:/tmp/deploy-$SITE_NAME/"
$SSH "sudo rsync -a --delete /tmp/deploy-$SITE_NAME/ $REMOTE_DIR/ && rm -rf /tmp/deploy-$SITE_NAME"

echo ""
echo "==> Deployed! Site is live at: https://$SITE_NAME.zevza.com"
