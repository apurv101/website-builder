#!/usr/bin/env bash
set -euo pipefail

# Runs ON EC2 after git pull to apply all changes
# Called by: ./scripts/deploy.sh (via SSH)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
INFRA_DIR="$PROJECT_DIR/infra"

echo "==> Applying website-builder config on EC2"

# 1. Copy workspace files (SOUL.md + skills + scripts)
echo "==> Copying workspace files (SOUL.md + skills + scripts)..."
mkdir -p ~/.openclaw/workspace/skills
mkdir -p ~/.openclaw/workspace/scripts
cp "$PROJECT_DIR/workspace/SOUL.md" ~/.openclaw/workspace/SOUL.md
cp "$PROJECT_DIR/workspace/IDENTITY.md" ~/.openclaw/workspace/IDENTITY.md
cp -r "$PROJECT_DIR/workspace/skills/"* ~/.openclaw/workspace/skills/
cp -r "$PROJECT_DIR/workspace/scripts/"* ~/.openclaw/workspace/scripts/

# 2. Deploy docker-compose.yml
if [[ -f "$INFRA_DIR/ec2-compose/docker-compose.yml" ]]; then
  echo "==> Copying docker-compose.yml..."
  cp "$INFRA_DIR/ec2-compose/docker-compose.yml" ~/openclaw/docker-compose.yml
fi

# 3. Deploy postgres init scripts
if [[ -d "$INFRA_DIR/ec2-compose/postgres-init" ]]; then
  echo "==> Copying postgres init scripts..."
  mkdir -p ~/openclaw/postgres-init
  cp "$INFRA_DIR/ec2-compose/postgres-init/"* ~/openclaw/postgres-init/
  chmod +x ~/openclaw/postgres-init/*.sh 2>/dev/null || true
fi

# 4. Deploy nginx config
if [[ -d "$INFRA_DIR/nginx" ]]; then
  echo "==> Deploying nginx config..."
  sudo cp "$INFRA_DIR/nginx/nginx.conf" /etc/nginx/nginx.conf
  if [[ -d "$INFRA_DIR/nginx/sites-available" ]]; then
    for f in "$INFRA_DIR/nginx/sites-available/"*; do
      [[ -f "$f" ]] || continue
      sudo cp "$f" "/etc/nginx/sites-available/$(basename "$f")"
    done
  fi
  sudo nginx -t
  sudo systemctl reload nginx
fi

# 5. Apply agent config
echo "==> Applying agent config..."
DENY_TOOLS=$(python3 -c "import json; print(json.dumps(json.load(open('$PROJECT_DIR/config.json'))['agent']['tools']['deny']))")
ALLOW_SKILLS=$(python3 -c "import json; print(json.dumps(json.load(open('$PROJECT_DIR/config.json'))['skills']['allowBundled']))")

cd ~/openclaw
docker compose exec -T openclaw-gateway node dist/index.js config set tools.deny "$DENY_TOOLS" --strict-json
docker compose exec -T openclaw-gateway node dist/index.js config set skills.allowBundled "$ALLOW_SKILLS" --strict-json

# 6. Back up auth-profiles.json before restart
AUTH_PATH=~/.openclaw/agents/main/agent/auth-profiles.json
echo "==> Backing up auth-profiles.json..."
if [[ -f "$AUTH_PATH" ]]; then
  cp "$AUTH_PATH" /tmp/auth-profiles.json.bak
  echo "    Backup saved to /tmp/auth-profiles.json.bak"
else
  echo "    WARNING: auth-profiles.json not found (first-time setup?)"
fi

# 7. Restart all services (gateway + db + postgrest)
echo "==> Restarting services..."
docker compose up -d --remove-orphans

# 8. Restore auth-profiles.json if lost during restart
echo "==> Verifying auth-profiles.json..."
sleep 3
if [[ ! -f "$AUTH_PATH" ]]; then
  if [[ -f /tmp/auth-profiles.json.bak ]]; then
    echo "    auth-profiles.json missing after restart — restoring from backup"
    mkdir -p "$(dirname "$AUTH_PATH")"
    cp /tmp/auth-profiles.json.bak "$AUTH_PATH"
  else
    echo "    WARNING: auth-profiles.json missing and no backup available"
  fi
else
  echo "    auth-profiles.json OK"
fi

# 9. Install migration dependencies (pg module for Node.js)
echo "==> Installing migration dependencies..."
docker compose exec -T openclaw-gateway sh -c \
  "cd /home/node/.openclaw/workspace/scripts && npm install --production 2>&1" || \
  echo "    WARNING: Failed to install migration deps (may need manual install)"

# 10. Verify services are running
echo "==> Checking services..."
docker compose ps
echo ""
docker compose logs --tail 3 db postgrest openclaw-gateway

echo ""
echo "==> EC2 apply complete!"
