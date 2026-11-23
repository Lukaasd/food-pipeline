import json
from urllib.request import Request, urlopen

from config import EMBEDDING_MODEL, OLLAMA_URL


def embed(texts):
    payload = {
        "model": EMBEDDING_MODEL,
        "input": texts,
    }
    request = Request(
        f"{OLLAMA_URL}/api/embed",
        data=json.dumps(payload).encode("utf-8"),
        headers={"Content-Type": "application/json"},
    )

    with urlopen(request, timeout=120) as response:
        return json.load(response)["embeddings"]


if __name__ == "__main__":
    vectors = embed(["The food arrived cold and the delivery was late."])
    print(f"Vectores generados: {len(vectors)}")
    print(f"Dimensiones del vector: {len(vectors[0])}")