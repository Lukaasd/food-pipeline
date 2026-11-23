select
    -- Limpiamos los IDs para relacionarlos con las otras vistas
    nullif(trim(r.review_id::varchar), '') as review_id,
    nullif(trim(r.order_id::varchar), '') as order_id,
    nullif(trim(r.user_id::varchar), '') as customer_id,
    nullif(trim(r.restaurant_id::varchar), '') as restaurant_id,

    -- Convertimos la puntuación sin interrumpir la consulta si falla
    try_to_decimal(r.rating::varchar, 3, 1) as rating,

    -- Quitamos espacios exteriores del comentario
    nullif(trim(r.comment::varchar), '') as comment,

    -- Interpretamos la fecha con el formato del CSV
    try_to_date(
        trim(r.review_date::varchar), 'YYYY-MM-DD'
    ) as review_date,

    -- Traemos la ciudad desde la vista de restaurantes
    res.city as city

from {{ source('raw', 'reviews') }} r

-- Conservamos la reseña aunque no encontremos su restaurante
left join {{ ref('stg_restaurants') }} res
    on trim(r.restaurant_id::varchar) = res.restaurant_id