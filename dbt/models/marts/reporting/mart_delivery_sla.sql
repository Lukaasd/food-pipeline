select
    coalesce(r.city, 'Unknown') as city,

    -- Hora en la que se hizo el pedido, de 0 a 23
    hour(o.order_timestamp) as order_hour,

    -- Contamos los entregados y cuántos tienen un tiempo registrado
    count(*) as delivered_orders,
    count(o.delivery_time_min) as orders_with_delivery_time,

    -- Mediana: la mitad de las entregas queda por debajo o igual
    round(median(o.delivery_time_min), 1) as p50,

    -- Percentil 90: muestra el tiempo que cubre aproximadamente al 90 %
    round(
        percentile_cont(0.9) within group (
            order by o.delivery_time_min
        ),
        1
    ) as p90

from {{ ref('fct_orders') }} o

left join {{ ref('dim_restaurants') }} r
    on o.restaurant_id = r.restaurant_id

-- Analizamos únicamente pedidos entregados
where o.is_delivered

group by
    coalesce(r.city, 'Unknown'),
    hour(o.order_timestamp)