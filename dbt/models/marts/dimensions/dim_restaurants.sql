select
    restaurant_id,
    restaurant_name,
    city,
    cuisine,
    rating,

    -- Es un mínimo aproximado, no un conteo exacto
    rating_count_min,
    rating_count_raw,

    -- Conservamos este nombre hasta confirmar qué representa el importe
    cost,
    license_no

from {{ ref('stg_restaurants') }}