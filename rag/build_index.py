import json

from config import CACHE_DIR, EMBEDDING_MODEL
from data import read_reviews
from embeddings import embed

INDEX_FILE = CACHE_DIR / "review_index.json"
BATCH_SIZE = 50


def build_index():
    reviews = read_reviews()
    if not reviews:
        raise RuntimeError("Snowflake no devolvió reseñas con comentario.")

    indexed_reviews = []

    for start in range(0, len(reviews), BATCH_SIZE):
        batch = reviews[start:start + BATCH_SIZE]
        vectors = embed([review["comment"] for review in batch])

        for review, vector in zip(batch, vectors, strict=True):
            rating = review["rating"]
            indexed_reviews.append({
                **review,
                "rating": float(rating) if rating is not None else None,
                "embedding": vector,
            })

        print(f"Reseñas indexadas: {len(indexed_reviews)}/{len(reviews)}", flush=True)

    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    INDEX_FILE.write_text(
        json.dumps(
            {"embedding_model": EMBEDDING_MODEL, "reviews": indexed_reviews},
            ensure_ascii=False,
        ),
        encoding="utf-8",
    )


if __name__ == "__main__":
    build_index()