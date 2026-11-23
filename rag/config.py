from pathlib import Path

RAG_DIR = Path(__file__).resolve().parent
PROJECT_DIR = RAG_DIR.parent

ENV_FILE = PROJECT_DIR / "airflow" / ".env"

OLLAMA_URL = "http://localhost:11434"
EMBEDDING_MODEL = "embeddinggemma"
CHAT_MODEL = "qwen3:8b"

SAMPLE_N = 500
TOP_K = 5

CACHE_DIR = RAG_DIR / "cache"