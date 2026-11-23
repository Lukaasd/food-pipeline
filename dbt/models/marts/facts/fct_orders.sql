select
    order_id,

    -- Claves para conectar con las dimensiones
    customer_id,
    restaurant_id,
    to_char(order_date, 'YYYYMMDD')::number(8, 0) as date_key,

    -- Conservamos la fecha y hora del pedido
    order_timestamp,
    order_date,

    -- Atributos del pedido
    payment_method,
    order_status,
    is_delivered,

    -- Cantidades informadas por el origen
    items_count,
    sales_qty,

    -- Importes del pedido, sin repetirlos en cada ítem
    subtotal,
    discount,
    delivery_fee,
    gst,
    sales_amount,

    -- Datos de la experiencia del cliente
    customer_rating,
    delivery_time_min

from {{ ref('stg_orders') }}