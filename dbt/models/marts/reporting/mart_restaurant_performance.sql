select
    f.restaurant_id,
    r.restaurant_name,
    coalesce(r.city, 'Unknown') as city,
    r.cuisine,

    -- Contamos todos los pedidos y los entregados
    count(*) as orders,
    count_if(f.is_delivered) as delivered_orders,

    -- Importe final de los pedidos entregados, expresado en INR
    sum(iff(f.is_delivered, f.sales_amount, 0)) as delivered_sales_amount,

    -- Promedio de las puntuaciones disponibles de pedidos entregados
    round(
        avg(iff(f.is_delivered, f.customer_rating, null)),
        2
    ) as avg_customer_rating,

    -- Tiempo promedio de entrega, usando solo entregados con tiempo conocido
    round(
        avg(iff(f.is_delivered, f.delivery_time_min, null)),
        1
    ) as avg_delivery_min

from {{ ref('fct_orders') }} f

left join {{ ref('dim_restaurants') }} r
    on f.restaurant_id = r.restaurant_id

group by
    f.restaurant_id,
    r.restaurant_name,
    coalesce(r.city, 'Unknown'),
    r.cuisine