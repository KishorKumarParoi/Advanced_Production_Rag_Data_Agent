# 🤖 Enterprise Agentic RAG Data Platform (Scalable Mesh)

[![Architecture Flow](docs/images/01_architecture_flow.svg)](docs/images/01_architecture_flow.svg)

[![Python](https://img.shields.io/badge/Python-3.11-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.115+-009688?style=for-the-badge&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com/)
[![Streamlit](https://img.shields.io/badge/Streamlit-1.42+-FF4B4B?style=for-the-badge&logo=streamlit&logoColor=white)](https://streamlit.io/)
[![LangGraph](https://img.shields.io/badge/LangGraph-Agentic_Core-1C3C3C?style=for-the-badge)](https://langchain.com/)
[![Qdrant](https://img.shields.io/badge/Qdrant-Vector_DB-DC2626?style=for-the-badge&logo=qdrant&logoColor=white)](https://qdrant.tech/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)

A production-grade, enterprise-level Agentic RAG system built with **LangGraph**, **NeMo Guardrails**, **Portkey LLM Gateway**, **Qdrant Vector Database**, and **Gemini Embeddings**. Engineered strictly in accordance with the **Enterprise AI Architect Roadmap (Phases 0 - 5)**.

---

## ⚡ One-Click Cloud Bootstrap (Zero-Touch)

Deploy the complete multi-container stack (Qdrant, FastAPI Engine, and Streamlit UI) on any Ubuntu, Debian, AWS EC2, GCP Compute Engine, or macOS instance with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/KishorKumarParoi/Advanced_Production_Rag_Data_Agent/main/bootstrap.sh | bash
```

---

## 🚀 Quick Start & Deployment Options

Clone and launch locally using the unified `deploy.sh` script:

```bash
git clone https://github.com/KishorKumarParoi/Advanced_Production_Rag_Data_Agent.git
cd Advanced_Production_Rag_Data_Agent
chmod +x deploy.sh clear.sh bootstrap.sh
```

### 1. Docker Compose Mode (Default)
```bash
./deploy.sh
```
*Builds and runs Qdrant, FastAPI Engine (:8000), and Streamlit UI (:8501).*

### 2. Standalone Container Mode
```bash
./deploy.sh --quick
```

### 3. Native Host Execution
```bash
./deploy.sh --host
```

---

## 🧹 Zero-Cost Teardown ($0.00 Spend)

To cleanly stop and eliminate all active containers, volumes, networks, and background processes:

```bash
./clear.sh
```

---

## 📡 API Reference & Integration

### 1. Health Probe
```bash
curl -s http://localhost:8000/health | jq .
```
**Response:**
```json
{
  "service": "advanced-production-rag",
  "status": "healthy",
  "version": "1.0.0"
}
```

### 2. Query Agentic RAG
```bash
curl -s -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{"q": "What is our enterprise data retention policy?", "thread_id": "session_123"}' | jq .
```

### 3. Visual Agent Graph
```bash
# View or download the Mermaid DAG of the agent workflow
curl -s http://localhost:8000/graph --output graph.png
```

---

## 🏗️ Technical Architecture & Roadmap

For full architectural blueprints, NeMo Colang safety policies, FlashRank cross-encoder reranking algorithms, and RAGAS eval metrics, consult [ARCHITECTURE.md](ARCHITECTURE.md).

---

## Key Features

- **Agentic Intelligence**: LangGraph for cyclic reasoning, multi-step planning, and conversation memory.
- **Guardrails**: NeMo Guardrails gate blocks off-topic, jailbreak, and injection inputs before any retrieval.
- **LLM Gateway**: Portkey routes all LLM calls with automatic fallback between primary and backup Groq keys.
- **Enterprise Search**: Qdrant Cloud for high-performance vector search + FlashRank for local semantic reranking.
- **Gemini Embeddings**: Google `gemini-embedding-2-preview` (3072-dim) via `langchain-google-genai`.
- **Local Document Parsing**: PDF, HTML, TXT, DOCX, PPTX parsed entirely on-device — no external OCR service.
- **Observability**: Full trace nesting with **Pydantic Logfire** and **LangSmith** across every agent node.
- **Evaluation Suite**: RAGAS-powered eval pipeline (6 metrics) with a dedicated Streamlit demo app.

---

## Agent Intelligence Flow

```mermaid
graph TD
    User((User)) --> UI[Streamlit UI]
    UI --> API[FastAPI /query]
    API --> Guard{NeMo Guardrails}
    Guard -->|Blocked| UI
    Guard -->|Pass| Planner{Planner Node}
    Planner -->|Conversational| Responder[Responder Node]
    Planner -->|Technical| Retriever[Retriever Node]
    Retriever --> Reranker[FlashRank Local Reranker]
    Reranker --> Responder
    Responder --> UI
    Responder -.-> Memory[(LangGraph MemorySaver)]
```

---

## Project Structure

```text
├── app/
│   ├── agents/
│   │   └── nodes/       # Planner, Retriever, Responder LangGraph nodes
│   ├── gateway/         # Portkey LLM gateway — primary + fallback Groq routing
│   ├── guardrails/      # NeMo Guardrails input/output filtering
│   ├── ingestion/
│   │   ├── chunking/    # Paragraph-based text splitter (1500 char max)
│   │   └── loaders/     # Local parsers — PDF (pypdf), HTML, TXT, DOCX, PPTX
│   ├── services/
│   │   └── retrieval/   # Gemini embeddings + Qdrant search + FlashRank reranking
│   ├── config.py        # Centralized environment variable management
│   └── main.py          # FastAPI entrypoint — guardrails gate + /query endpoint
├── evals/               # RAGAS evaluation suite + Streamlit 3-tab demo
├── ui/                  # Streamlit chat interface with reasoning step transparency
├── processed_data/      # Auto-generated — parsed & chunked JSON output per document
├── docs/                # Architectural and operational guides (11 docs)
├── DATA/                # Sample datasets (True vs Noisy documentation)
└── requirements.txt     # Pinned dependencies
```

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Orchestration | LangChain + LangGraph |
| LLMs | Groq (Llama 3.3 70B) via **Portkey** gateway |
| Guardrails | NeMo Guardrails |
| Vector DB | Qdrant Cloud |
| Reranking | FlashRank (local, zero-latency) |
| Embeddings | Gemini `gemini-embedding-2-preview` (3072-dim) |
| Document Parsing | pypdf + pdfplumber (local, no OCR service) |
| Observability | Pydantic Logfire + LangSmith |
| Evaluation | RAGAS + custom Tool Correctness (Jaccard) |

---

## Getting Started

### 1. Install dependencies

```powershell
python -m venv tenvv
.\tenvv\Scripts\activate
pip install -r requirements.txt
```

### 2. Configure environment

Create a `.env` file with the following keys:

```env
# Groq Reasoning Engine (Llama 3.3)
GROQ_API_KEY = ""
GROQ_FALLBACK_API_KEY = ""          # second Groq key, or same as primary

# Portkey LLM Gateway
PORTKEY_API_KEY = ""

# Qdrant Vector DB
QDRANT_API_KEY = ""
QDRANT_CLUSTER_ENDPOINT = ""        # e.g. https://your-cluster.cloud.qdrant.io:6333

# Pydantic Logfire Observability
LOGFIRE_TOKEN = ""

# LangSmith
LANGSMITH_TRACING = true
LANGSMITH_ENDPOINT = https://api.smith.langchain.com
LANGSMITH_API_KEY = ""
LANGSMITH_PROJECT = ""

# Streamlit UI → FastAPI
BACKEND_URL = ""                    # e.g. http://localhost:8000

# Eval judge LLM (keep separate from main key to avoid rate-limiting the live app)
JUDGE_GROQ = ""

# Gemini Embeddings
GEMINI_API_KEY = ""
```

### 3. Run data ingestion

Parses all documents in `DATA/`, chunks them, saves metadata to `processed_data/`, and indexes vectors into Qdrant.

```powershell
python -m app.ingestion.processor DATA --wipe
```

> Pass `--wipe` to drop and recreate the Qdrant collection. Omit it to append to an existing collection.

### 4. Launch the app

```powershell
# Terminal 1 — FastAPI backend
uvicorn app.main:app --reload --port 8000

# Terminal 2 — Streamlit UI
streamlit run ui/app.py
```

### 5. Run the eval suite (optional)

```powershell
# Requires the FastAPI backend running on :8000
streamlit run evals/app.py
```

---

## Documentation Index

| # | Guide | What it covers |
|---|-------|---------------|
| 01 | [System Overview](docs/01_SYSTEM_OVERVIEW.md) | High-level vision and end-to-end flow |
| 02 | [Ingestion Engine](docs/02_INGESTION_ENGINE.md) | Document parsing and indexing pipeline |
| 03 | [Node Intelligence](docs/03_NODE_INTELLIGENCE.md) | Planner, Retriever, Responder internals |
| 04 | [Observability](docs/04_TRACING_AND_OBSERVABILITY.md) | Logfire + LangSmith tracing |
| 05 | [Environment Variables](docs/05_ENVIRONMENT_VARIABLES.md) | All env vars and configuration reference |
| 06 | [Known Gotchas](docs/06_KNOWN_GOTCHAS.md) | Non-obvious bugs and architectural decisions |
| 07 | [FlashRank Reranking](docs/07_FLASHRANK_RERANKING.md) | Local semantic reranker deep-dive |
| 08 | [Guardrails](docs/08_GUARDRAILS.md) | NeMo Guardrails implementation |
| 09 | [LLM Gateway](docs/09_LLM_GATEWAY.md) | Portkey routing, fallback, and observability |
| 10 | [Evals](docs/10_EVALS.md) | RAGAS metrics theory and token budget |
| 11 | [Evals Pipeline](docs/11_EVALS_PIPELINE.md) | Live eval pipeline and Streamlit demo |

---

*Built for High-Scale Enterprise Document Intelligence.*
