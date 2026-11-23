{{ config(tags=['ai']) }}

with enriched_reviews as (
    select
        review_id,
        topic,
        sentiment_label,
        sentiment_score,
        key_issue
    from {{ source('ai', 'review_enriched') }}

    qualify row_number() over (
        partition by review_id
        order by enriched_at desc
    ) = 1
)

select
    r.city,
    e.topic,
    e.sentiment_label,

    count(*) as reviews,

    round(avg(e.sentiment_score), 3) as avg_sentiment_score,
    round(avg(r.rating), 2) as avg_star_rating,

    count(nullif(trim(e.key_issue), '')) as flagged_issues

from enriched_reviews e
inner join {{ ref('stg_reviews') }} r
    on e.review_id = r.review_id

group by r.city, e.topic, e.sentiment_label