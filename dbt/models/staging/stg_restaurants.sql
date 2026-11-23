select
    -- el ID queda como texto; si está vacio, lo dejamos en NULL
    nullif(trim(id::varchar), '') as restaurant_id,

    -- quitamos espacios de los extremos del nombre
    nullif(trim(name), '') as restaurant_name,

    -- limpiamos los espacios y conservamos la ciudad completa
    nullif(trim(city), '') as city,

    -- cambiamos '--' por NULL y pasamos el rating a número con un decimal
    try_to_decimal(
        nullif(trim(rating), '--'), 3, 1
    ) as rating,

    -- sacamos el numero de valoraciones; si tiene K, multiplicamos por 1000
    -- es un mínimo: '1K+ ratings' significa al menos 1000
    try_to_decimal(
        regexp_substr(rating_count, '[0-9]+([.][0-9]+)?'),
        12, 2
    ) * case
        when upper(rating_count) like '%K%' then 1000
        else 1
    end as rating_count_min,

    -- guardamos el texto original para no perder el '+' o 'Too Few Ratings'
    trim(rating_count) as rating_count_raw,

    -- quitamos ₹ y las comas de miles, y convertimos el costo a decimal
    try_to_decimal(
        replace(replace(trim(cost), '₹', ''), ',', ''),
        12, 2
    ) as cost,

    -- conservamos las categorías como texto y quitamos espacios exteriores
    nullif(trim(cuisine), '') as cuisine,

    -- la licencia queda como texto para conservar posibles ceros iniciales
    nullif(trim(lic_no::varchar), '') as license_no,

    -- limpiamos la URL; si está vacía, queda en NULL
    nullif(trim(link), '') as link,

    -- quitamos espacios exteriores sin modificar el contenido de la dirección
    nullif(trim(address), '') as address,

    -- conservamos la ruta al JSON del menú
    nullif(trim(menu), '') as menu


from {{ source('raw', 'restaurants') }}