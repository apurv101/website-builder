#!/usr/bin/env bash
set -euo pipefail

# Pull infrastructure config from EC2 to local infra/ directory
# Usage: ./scripts/pull-from-ec2.sh
# Re-runnable — use `git diff` after to check for drift

EC2_IP="${EC2_IP:-3.223.52.227}"
EC2_USER="${EC2_USER:-ubuntu}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/openclaw-key.pem}"
SSH="ssh -i $SSH_KEY -o StrictHostKeyChecking=no $EC2_USER@$EC2_IP"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
INFRA_DIR="$PROJECT_DIR/infra"

echo "==> Pulling infra config from $EC2_IP"

# 1. Nginx main config
echo "==> Pulling /etc/nginx/nginx.conf..."
mkdir -p "$INFRA_DIR/nginx"
$SSH "sudo cat /etc/nginx/nginx.conf" > "$INFRA_DIR/nginx/nginx.conf"

# 2. Nginx sites-available
echo "==> Pulling /etc/nginx/sites-available/..."
mkdir -p "$INFRA_DIR/nginx/sites-available"
SITE_FILES=$($SSH "sudo ls /etc/nginx/sites-available/")
for f in $SITE_FILES; do
  echo "    $f"
  $SSH "sudo cat /etc/nginx/sites-available/$f" > "$INFRA_DIR/nginx/sites-available/$f"
done

# 3. EC2 docker-compose
echo "==> Pulling ~/openclaw/docker-compose.yml..."
mkdir -p "$INFRA_DIR/ec2-compose"
$SSH "cat ~/openclaw/docker-compose.yml" > "$INFRA_DIR/ec2-compose/docker-compose.yml"

echo ""
echo "==> Done! Files pulled to infra/"
echo "    Run 'git diff' to check for drift."
