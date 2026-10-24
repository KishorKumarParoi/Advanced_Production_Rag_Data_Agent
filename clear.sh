#!/usr/bin/env bash
# ==============================================================================
# 🧹 ADVANCED PRODUCTION RAG DATA AGENT - ZERO-COST TEARDOWN SCRIPT ($0.00)
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

echo -e "${YELLOW}${BOLD}[*] Initiating Zero-Cost Teardown for Advanced Production RAG Data Agent...${NC}"

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

echo -e "${CYAN}[1/4] Stopping Docker Compose containers & removing volumes...${NC}"
run_compose down --volumes --remove-orphans 2>/dev/null || true

echo -e "${CYAN}[2/4] Removing standalone containers...${NC}"
docker rm -f advanced-rag-api 2>/dev/null || true

echo -e "${CYAN}[3/4] Terminating orphan uvicorn and streamlit processes...${NC}"
pkill -f "uvicorn app.main:app" 2>/dev/null || true
pkill -f "streamlit run ui/app.py" 2>/dev/null || true

echo -e "${CYAN}[4/4] Removing cache & temporary artifacts...${NC}"
find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
find . -type f -name "*.pyc" -delete 2>/dev/null || true

echo -e "${GREEN}${BOLD}✓ Teardown complete. Zero compute resources running (\$0.00 spend).${NC}"
