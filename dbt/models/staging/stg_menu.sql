select
    -- lipiamos los identificadores sin quitarles letras ni ceros
    nullif(trim(menu_id), '') as menu_id,
    nullif(trim(r_id::varchar), '') as restaurant_id,
    nullif(trim(f_id), '') as food_id,
    nullif(trim(cuisine), '') as cuisine,  -- conservamos las categoias y quitamos espacios exteriores
    try_to_decimal(trim(price::varchar), 12, 2) as price  -- convertimos el precio a numero con dos decimales

from {{ source('raw', 'menu') }}

-- dejamos fuera registros sin identificadores para relacionarlos
where nullif(trim(menu_id), '') is not null
  and nullif(trim(r_id::varchar), '') is not null
  and nullif(trim(f_id), '') is not null