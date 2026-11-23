import os

import snowflake.connector
from dotenv import load_dotenv

from config import ENV_FILE, SAMPLE_N


def read_reviews():
    load_dotenv(ENV_FILE)

    query = """
        SELECT review_id, city, rating, comment
        FROM FOOD.STAGING.STG_REVIEWS
        WHERE review_id IS NOT NULL
          AND NULLIF(TRIM(comment), '') IS NOT NULL
        LIMIT %s
    """

    with snowflake.connector.connect(
        account=os.environ["SNOWFLAKE_ACCOUNT"],
        user=os.environ["SNOWFLAKE_USER"],
        password=os.environ["SNOWFLAKE_PASSWORD"],
        role="DBT_ROLE",
        warehouse="FOOD_WH",
        database="FOOD",
        schema="STAGING",
    ) as conn:
        with conn.cursor(snowflake.connector.DictCursor) as cursor:
            cursor.execute(query, (SAMPLE_N,))
            return [
                {key.lower(): value for key, value in row.items()}
                for row in cursor
            ]


if __name__ == "__main__":
    reviews = read_reviews()
    print(f"Reseñas leídas: {len(reviews)}")

    if reviews:
        print("Campos disponibles:", ", ".join(reviews[0]))