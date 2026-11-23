select
    -- Limpiamos los IDs y mantenemos el mismo tipo que en las otras vistas
    nullif(trim(order_id::varchar), '') as order_id,
    nullif(trim(user_id::varchar), '') as customer_id,
    nullif(trim(r_id::varchar), '') as restaurant_id,

    -- Interpretamos las fechas con el formato que vimos en el CSV
    try_to_timestamp_ntz(
        trim(order_timestamp::varchar), 'AUTO'
    ) as order_timestamp,
    try_to_date(trim(order_date::varchar), 'YYYY-MM-DD') as order_date,

    -- Guardamos la ubicación completa y extraemos la ciudad al final
    nullif(trim(restaurant_city), '') as restaurant_location,
    nullif(trim(regexp_substr(restaurant_city, '[^,]+$')), '') as city,

    -- Limpiamos las categorías sin modificar su contenido
    nullif(trim(cuisine), '') as cuisine,

    -- Convertimos los conteos a números
    try_to_number(items_count::varchar) as items_count,
    try_to_number(sales_qty::varchar) as sales_qty,

    -- Convertimos los importes a números con dos decimales
    try_to_decimal(subtotal::varchar, 12, 2) as subtotal,
    try_to_decimal(discount::varchar, 12, 2) as discount,
    try_to_decimal(delivery_fee::varchar, 12, 2) as delivery_fee,
    try_to_decimal(gst::varchar, 12, 2) as gst,
    try_to_decimal(sales_amount::varchar, 12, 2) as sales_amount,

    -- Unificamos la escritura de moneda, forma de pago y estado
    nullif(upper(trim(currency)), '') as currency,
    nullif(upper(trim(payment_method)), '') as payment_method,
    nullif(upper(trim(order_status)), '') as order_status,

    -- Identificamos los pedidos entregados, ignorando espacios y mayúsculas
    (upper(trim(order_status)) = 'DELIVERED') as is_delivered,

    -- Los valores ausentes quedan en NULL; no los reemplazamos por cero
    try_to_decimal(customer_rating::varchar, 3, 1) as customer_rating,
    try_to_decimal(delivery_time_min::varchar, 10, 2) as delivery_time_min

from {{ source('raw', 'orders') }}

