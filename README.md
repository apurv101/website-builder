# Website Builder

An AI-powered website creation assistant built on [OpenClaw](https://github.com/openclaw/openclaw). Users can request websites via WhatsApp (or any other messaging channel) and the agent will design, build, and deploy them.

## How it works

This repo is a **config wrapper** around stock OpenClaw. It scopes the AI agent to focus on website creation through:

- **`config.json`** - Restricts available tools and sets the agent's purpose
- **`workspace/SOUL.md`** - Defines the agent's personality and workflow
- **`workspace/skills/`** - Teaches the agent how to scaffold, design, and deploy websites

No OpenClaw source code is modified. Updates are as simple as rebuilding the Docker image.

## Quick start

### Local
```bash
docker compose up --build
```

### Deploy to AWS
```bash
# Set your AWS account ID
export AWS_ACCOUNT_ID=123456789

# Build, push to ECR, deploy to ECS/App Runner
./scripts/deploy.sh build
./scripts/deploy.sh push
```

## Configuration

Add your API keys in `docker-compose.yml` or a `.env` file:
```
ANTHROPIC_API_KEY=sk-...
```

## Updating OpenClaw

Rebuild the Docker image to pull the latest version:
```bash
docker compose build --no-cache
```

## Project structure

```
website-builder/
  config.json              # Agent scoping (tools, system prompt)
  workspace/
    SOUL.md                # Agent personality and workflow
    skills/
      web-scaffold/        # How to create new sites
      web-design/          # Design and styling guidelines
      web-deploy/          # Deployment instructions
  Dockerfile               # Packages everything with openclaw
  docker-compose.yml       # Local dev / production config
  scripts/
    deploy.sh              # AWS deployment helper
```
