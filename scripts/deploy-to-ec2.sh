#!/usr/bin/env bash
set -euo pipefail

# Deploy website-builder config/skills + infra to existing OpenClaw EC2 instance
# Usage: ./scripts/deploy-to-ec2.sh [--dry-run]

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "==> DRY RUN — showing what would be deployed"
fi

EC2_IP="${EC2_IP:-3.223.52.227}"
EC2_USER="${EC2_USER:-ubuntu}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/openclaw-key.pem}"
SSH="ssh -i $SSH_KEY -o StrictHostKeyChecking=no $EC2_USER@$EC2_IP"
SCP="scp -i $SSH_KEY -o StrictHostKeyChecking=no"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
INFRA_DIR="$PROJECT_DIR/infra"

run() {
  if $DRY_RUN; then
    echo "  [dry-run] $*"
  else
    "$@"
  fi
}

echo "==> Deploying website-builder to $EC2_IP"

# 1. Copy SOUL.md and skills to the workspace
echo "==> Uploading workspace files (SOUL.md + skills)..."
run $SSH "mkdir -p ~/.openclaw/workspace/skills"
run $SCP "$PROJECT_DIR/workspace/SOUL.md" "$EC2_USER@$EC2_IP:~/.openclaw/workspace/SOUL.md"
run $SCP -r "$PROJECT_DIR/workspace/skills/"* "$EC2_USER@$EC2_IP:~/.openclaw/workspace/skills/"

# 2. Deploy nginx config (if infra/nginx exists)
if [[ -d "$INFRA_DIR/nginx" ]]; then
  echo "==> Deploying nginx config..."

  # Upload to /tmp first
  run $SCP "$INFRA_DIR/nginx/nginx.conf" "$EC2_USER@$EC2_IP:/tmp/nginx.conf"
  if [[ -d "$INFRA_DIR/nginx/sites-available" ]]; then
    for f in "$INFRA_DIR/nginx/sites-available/"*; do
      [[ -f "$f" ]] || continue
      run $SCP "$f" "$EC2_USER@$EC2_IP:/tmp/sites-available-$(basename "$f")"
    done
  fi

  # Move into place, validate, reload
  run $SSH "sudo cp /tmp/nginx.conf /etc/nginx/nginx.conf"
  if [[ -d "$INFRA_DIR/nginx/sites-available" ]]; then
    for f in "$INFRA_DIR/nginx/sites-available/"*; do
      [[ -f "$f" ]] || continue
      run $SSH "sudo cp /tmp/sites-available-$(basename "$f") /etc/nginx/sites-available/$(basename "$f")"
    done
  fi
  run $SSH "sudo nginx -t"
  run $SSH "sudo systemctl reload nginx"
fi

# 3. Deploy EC2 docker-compose (if infra/ec2-compose exists)
if [[ -f "$INFRA_DIR/ec2-compose/docker-compose.yml" ]]; then
  echo "==> Deploying EC2 docker-compose.yml..."
  run $SCP "$INFRA_DIR/ec2-compose/docker-compose.yml" "$EC2_USER@$EC2_IP:~/openclaw/docker-compose.yml"
fi

# 4. Apply agent config
echo "==> Applying agent config..."

DENY_TOOLS=$(python3 -c "import json; print(json.dumps(json.load(open('$PROJECT_DIR/config.json'))['agent']['tools']['deny']))")
ALLOW_SKILLS=$(python3 -c "import json; print(json.dumps(json.load(open('$PROJECT_DIR/config.json'))['skills']['allowBundled']))")

run $SSH "cd ~/openclaw && \
  docker compose exec -T openclaw-gateway node dist/index.js config set tools.deny '$DENY_TOOLS' --strict-json && \
  docker compose exec -T openclaw-gateway node dist/index.js config set skills.allowBundled '$ALLOW_SKILLS' --strict-json"

# 5. Restart gateway to pick up changes
echo "==> Restarting gateway..."
run $SSH "cd ~/openclaw && docker compose up -d --remove-orphans"

# 6. Verify it's running
if ! $DRY_RUN; then
  echo "==> Waiting for gateway to come up..."
  sleep 3
  $SSH "cd ~/openclaw && docker compose logs --tail 5 openclaw-gateway"
fi

echo ""
echo "==> Done! Website builder is live."
echo "    SSH tunnel: ssh -i $SSH_KEY -N -L 19000:127.0.0.1:18789 $EC2_USER@$EC2_IP"
