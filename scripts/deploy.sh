#!/usr/bin/env bash
set -euo pipefail

# Build and deploy the website-builder container
# Usage: ./scripts/deploy.sh [build|push|run]

IMAGE_NAME="website-builder"
AWS_REGION="${AWS_REGION:-us-east-1}"
AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID:-}"
ECR_REPO="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}"

case "${1:-build}" in
  build)
    echo "Building Docker image..."
    docker build -t "$IMAGE_NAME" .
    echo "Done. Run locally with: docker compose up"
    ;;

  push)
    if [ -z "$AWS_ACCOUNT_ID" ]; then
      echo "Set AWS_ACCOUNT_ID first"
      exit 1
    fi
    echo "Logging into ECR..."
    aws ecr get-login-password --region "$AWS_REGION" | \
      docker login --username AWS --password-stdin "$ECR_REPO"
    echo "Tagging and pushing..."
    docker tag "$IMAGE_NAME" "$ECR_REPO:latest"
    docker push "$ECR_REPO:latest"
    echo "Pushed to $ECR_REPO:latest"
    ;;

  run)
    echo "Running locally..."
    docker compose up --build
    ;;

  *)
    echo "Usage: $0 [build|push|run]"
    exit 1
    ;;
esac
