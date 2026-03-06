FROM node:22-slim

# Install openclaw from npm
RUN npm i -g openclaw@latest

# Copy configuration
COPY config.json /root/.openclaw/config.json

# Copy workspace (SOUL.md + skills)
COPY workspace/ /app/

WORKDIR /app

EXPOSE 18789

CMD ["openclaw", "gateway", "run", "--bind", "0.0.0.0", "--port", "18789"]
