#!/usr/bin/env bash
# ==============================================================================
# 🚀 ADVANCED PRODUCTION RAG DATA AGENT - UNIFIED LAUNCHER
# Supported Flags:
#   ./deploy.sh            # Standard Docker Compose Deployment (Qdrant, API, UI)
#   ./deploy.sh --quick    # Standalone Container Mode
#   ./deploy.sh --host     # Host Native Python execution
# ==============================================================================

set -eo pipefail

BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

MODE="compose"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --quick) MODE="quick"; shift ;;
    --host) MODE="host"; shift ;;
    --compose) MODE="compose"; shift ;;
    *) echo -e "${YELLOW}Unknown flag $1; defaulting to compose.${NC}"; shift ;;
  esac
done

echo -e "${CYAN}${BOLD}"
cat << "EOF"
================================================================================
  🤖 ADVANCED PRODUCTION RAG & AGENTIC DATA PLATFORM DEPLOYMENT
================================================================================
EOF
echo -e "${NC}"

# Ensure .env exists
if [ ! -f .env ] && [ -f .env.example ]; then
  cp .env.example .env
  echo -e "${GREEN}✓ Created default .env from .env.example${NC}"
fi

run_compose() {
  if docker compose version &>/dev/null; then
    docker compose "$@"
  elif command -v docker-compose &>/dev/null; then
    docker-compose "$@"
  elif sudo docker compose version &>/dev/null; then
    sudo docker compose "$@"
  else
    sudo docker-compose "$@"
  fi
}

# 1. Host Native Mode
if [ "$MODE" = "host" ]; then
  echo -e "${YELLOW}[*] Launching in Host Python Mode...${NC}"
  export PORT="${PORT:-8000}"

  if [ -d ".venv" ]; then
    source .venv/bin/activate
  fi

  uvicorn app.main:app --host 0.0.0.0 --port "$PORT"
  exit 0
fi

# 2. Standalone Container Mode
if [ "$MODE" = "quick" ]; then
  echo -e "${CYAN}[*] Building standalone container...${NC}"
  docker build -t advanced-production-rag:latest .
  docker rm -f advanced-rag-api 2>/dev/null || true
  docker run -d --name advanced-rag-api \
    -p 8000:8080 \
    --env-file .env \
    advanced-production-rag:latest

  echo -e "${GREEN}✓ Advanced RAG API running at http://localhost:8000${NC}"
  exit 0
fi

# 3. Docker Compose Mode
echo -e "${CYAN}[*] Starting Qdrant, FastAPI & Streamlit via Docker Compose...${NC}"
run_compose up -d --build

echo -e "${YELLOW}[*] Verifying service health...${NC}"
for i in {1..35}; do
  if curl -sf http://localhost:8000/health >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Advanced Production RAG Service is UP and HEALTHY!${NC}"
    echo -e "  - FastAPI Docs:  http://localhost:8000/docs"
    echo -e "  - Streamlit UI:  http://localhost:8501"
    echo -e "  - Graph Flow:    http://localhost:8000/graph"
    echo -e "  - Query API:     POST http://localhost:8000/query"
    echo -e "  - Qdrant Vector: http://localhost:6333/dashboard"
    exit 0
  fi
  sleep 1
done

echo -e "${RED}[!] Health check timed out after 35s. Checking logs:${NC}"
run_compose logs --tail=25
exit 1
