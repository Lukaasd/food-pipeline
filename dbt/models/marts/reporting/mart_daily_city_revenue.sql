select
    o.order_date,
    coalesce(r.city, 'Unknown') as city,

    -- Contamos todos los pedidos y los entregados por separado
    count(*) as orders,
    count_if(o.is_delivered) as delivered_orders,

    -- Proporción de pedidos cancelados: 0.15 equivale a 15 %
    round(
        div0(count_if(o.order_status = 'CANCELLED'), count(*)),
        4
    ) as cancel_rate,

    -- Sumamos el importe final de los pedidos entregados
    sum(iff(o.is_delivered, o.sales_amount, 0)) as gmv,

    -- Importe promedio por pedido entregado
    round(
        div0(
            sum(iff(o.is_delivered, o.sales_amount, 0)),
            count_if(o.is_delivered)
        ),
        2
    ) as aov

from {{ ref('fct_orders') }} o

-- Conservamos los pedidos aunque no encontremos su restaurante
left join {{ ref('dim_restaurants') }} r
    on o.restaurant_id = r.restaurant_id

group by
    o.order_date,
    coalesce(r.city, 'Unknown')