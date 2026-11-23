select
    oi.order_item_id,
    oi.order_id,
    oi.restaurant_id,
    oi.food_id,

    -- Traemos el cliente y la fecha desde el pedido
    o.customer_id,
    o.order_timestamp as order_ts,
    o.order_date,

    -- Misma clave que usamos en dim_date
    to_char(o.order_date, 'YYYYMMDD')::number(8, 0) as date_key,

    -- Permiten distinguir ventas entregadas, canceladas y reembolsadas
    o.order_status,
    o.is_delivered,

    -- Medidas correspondientes a esta línea del pedido
    oi.price,
    oi.quantity,
    oi.line_amount

from {{ ref('stg_order_items') }} oi

-- Conservamos los ítems aunque falte su pedido en la fuente
left join {{ ref('stg_orders') }} o
    on oi.order_id = o.order_id