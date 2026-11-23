select
    -- limpiamos los IDs y los conservamos como texto
    nullif(trim(order_item_id::varchar), '') as order_item_id,
    nullif(trim(order_id::varchar), '') as order_id,
    nullif(trim(r_id::varchar), '') as restaurant_id,
    nullif(trim(f_id::varchar), '') as food_id,
    try_to_decimal(price::varchar, 12, 2) as price,  -- pasamos el precio a numero con dos decimales
    case  -- convertimos la cantidad sin redondear valores fraccionarios
        when try_to_decimal(quantity::varchar, 18, 6)
             = trunc(try_to_decimal(quantity::varchar, 18, 6))
        then try_to_number(quantity::varchar)
    end as quantity,
    try_to_decimal(line_amount::varchar, 12, 2) as line_amount  -- conservamos el importe informado por el origen

from {{ source('raw', 'order_items') }}