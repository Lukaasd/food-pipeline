import json
from math import sqrt

from config import CACHE_DIR, EMBEDDING_MODEL, TOP_K
from embeddings import embed

INDEX_FILE = CACHE_DIR / "review_index.json"


def cosine_similarity(a, b):
    dot_product = sum(x * y for x, y in zip(a, b, strict=True))
    norm_a = sqrt(sum(x * x for x in a))
    norm_b = sqrt(sum(y * y for y in b))
    return dot_product / (norm_a * norm_b)


def load_reviews():
    index = json.loads(INDEX_FILE.read_text(encoding="utf-8"))
    if index["embedding_model"] != EMBEDDING_MODEL:
        raise ValueError("Cambió el modelo de embeddings. Volvé a crear el índice.")
    return index["reviews"]


def find_similar_reviews(question, cities=None, ratings=None):
    candidates = [
        review for review in load_reviews()
        if (not cities or review["city"] in cities)
        and (not ratings or review["rating"] in ratings)
    ]

    if not candidates:
        return []

    question_vector = embed([question])[0]
    scored_reviews = [
        (cosine_similarity(question_vector, review["embedding"]), review)
        for review in candidates
    ]
    scored_reviews.sort(key=lambda result: result[0], reverse=True)
    return scored_reviews[:TOP_K]


if __name__ == "__main__":
    question = input("Pregunta sobre las reseñas: ").strip()
    if question:
        for score, review in find_similar_reviews(question):
            print(f"\n{score:.3f} | Reseña {review['review_id']} | {review['city']}")
            print(review["comment"])