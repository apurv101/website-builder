#!/usr/bin/env bash
set -euo pipefail

# Deploy website-builder by pulling latest from GitHub on EC2
# Usage: ./scripts/deploy.sh

EC2_IP="${EC2_IP:-3.223.52.227}"
EC2_USER="${EC2_USER:-ubuntu}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/openclaw-key.pem}"
SSH="ssh -i $SSH_KEY -o StrictHostKeyChecking=no $EC2_USER@$EC2_IP"

echo "==> Deploying website-builder via git pull on $EC2_IP"

$SSH "cd ~/website-builder && git pull && ./scripts/ec2-apply.sh"

echo ""
echo "==> Done! Website builder is live."
echo "    SSH tunnel: ssh -i $SSH_KEY -N -L 19000:127.0.0.1:18789 $EC2_USER@$EC2_IP"
