#!/usr/bin/env bash
# ==============================================================================
# 🚀 ZERO-TOUCH CLOUD BOOTSTRAPPER: ADVANCED PRODUCTION RAG DATA AGENT
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/KishorKumarParoi/Advanced_Production_Rag_Data_Agent/main/bootstrap.sh | bash
# ==============================================================================

set -eo pipefail

BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

REPO_NAME="Advanced_Production_Rag_Data_Agent"
REPO_URL="https://github.com/KishorKumarParoi/Advanced_Production_Rag_Data_Agent.git"
INSTALL_DIR="$HOME/$REPO_NAME"

echo -e "${CYAN}${BOLD}"
cat << "EOF"
================================================================================
   🤖 ADVANCED PRODUCTION RAG DATA AGENT - ONE-CLICK CLOUD BOOTSTRAPPER
================================================================================
EOF
echo -e "${NC}"

echo -e "${YELLOW}[1/4] Detecting runtime environment & system dependencies...${NC}"

if command -v apt-get &>/dev/null; then
  sudo apt-get update -y
  sudo apt-get install -y git curl ca-certificates
elif command -v yum &>/dev/null; then
  sudo yum install -y git curl ca-certificates
fi

if ! command -v docker &>/dev/null; then
  echo -e "${YELLOW}[!] Docker not found. Installing Docker engine...${NC}"
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker "$USER" 2>/dev/null || true
  sudo systemctl enable --now docker 2>/dev/null || true
fi

echo -e "${YELLOW}[2/4] Cloning or updating repository at $INSTALL_DIR...${NC}"
if [ -d "$INSTALL_DIR/.git" ]; then
  cd "$INSTALL_DIR"
  git fetch origin main
  git reset --hard origin/main
else
  git clone "$REPO_URL" "$INSTALL_DIR"
  cd "$INSTALL_DIR"
fi

chmod +x deploy.sh clear.sh bootstrap.sh

echo -e "${YELLOW}[3/4] Triggering automated deployment pipeline...${NC}"
./deploy.sh

echo -e "${GREEN}${BOLD}"
cat << "EOF"
================================================================================
  🎉 BOOTSTRAP COMPLETED SUCCESSFULLY!
================================================================================
  • FastAPI Docs:     http://localhost:8000/docs
  • Streamlit Web UI: http://localhost:8501
  • Agent Flow Graph: http://localhost:8000/graph
  • Query API:        POST http://localhost:8000/query
  • Health Endpoint:  http://localhost:8000/health
  • Teardown Command: ./clear.sh
================================================================================
EOF
echo -e "${NC}"
