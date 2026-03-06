#!/usr/bin/env bash
set -euo pipefail

# Deploy website-builder config/skills to existing OpenClaw EC2 instance
# Usage: ./scripts/deploy-to-ec2.sh

EC2_IP="${EC2_IP:-44.192.92.142}"
EC2_USER="${EC2_USER:-ubuntu}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/openclaw-key.pem}"
SSH="ssh -i $SSH_KEY -o StrictHostKeyChecking=no $EC2_USER@$EC2_IP"
SCP="scp -i $SSH_KEY -o StrictHostKeyChecking=no"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "==> Deploying website-builder to $EC2_IP"

# 1. Copy SOUL.md and skills to the workspace
echo "==> Uploading workspace files (SOUL.md + skills)..."
$SSH "mkdir -p ~/.openclaw/workspace/skills"
$SCP "$PROJECT_DIR/workspace/SOUL.md" "$EC2_USER@$EC2_IP:~/.openclaw/workspace/SOUL.md"
$SCP -r "$PROJECT_DIR/workspace/skills/"* "$EC2_USER@$EC2_IP:~/.openclaw/workspace/skills/"

# 2. Read config.json and apply agent settings via openclaw CLI
# Note: agent.extraSystemPrompt is NOT a config key — use SOUL.md instead (already uploaded above).
# Config schema (openclaw 2026.3+): tools.deny, skills.allowBundled
echo "==> Applying agent config..."

DENY_TOOLS=$(python3 -c "import json; print(json.dumps(json.load(open('$PROJECT_DIR/config.json'))['agent']['tools']['deny']))")
ALLOW_SKILLS=$(python3 -c "import json; print(json.dumps(json.load(open('$PROJECT_DIR/config.json'))['skills']['allowBundled']))")

$SSH "cd ~/openclaw && \
  docker compose exec -T openclaw-gateway node dist/index.js config set tools.deny '$DENY_TOOLS' --strict-json && \
  docker compose exec -T openclaw-gateway node dist/index.js config set skills.allowBundled '$ALLOW_SKILLS' --strict-json"

# 3. Restart gateway to pick up changes
echo "==> Restarting gateway..."
$SSH "cd ~/openclaw && docker compose restart openclaw-gateway"

# 4. Verify it's running
echo "==> Waiting for gateway to come up..."
sleep 3
$SSH "cd ~/openclaw && docker compose logs --tail 5 openclaw-gateway"

echo ""
echo "==> Done! Website builder is live."
echo "    SSH tunnel: ssh -i $SSH_KEY -N -L 19000:127.0.0.1:18789 $EC2_USER@$EC2_IP"
