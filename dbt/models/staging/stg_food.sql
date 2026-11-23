select
    trim(f_id) as food_id,  -- limpiamos el identificador y conservamos su formato de texto
    nullif(trim(item), '') as food_name,  -- quitamos espacios exteriores; un nombre vacio queda en NULL
    initcap(nullif(trim(veg_or_non_veg), '')) as veg_or_non_veg  -- unificamos mayusculas y quitamos espacios exteriores

from {{ source('raw', 'food') }}
where nullif(trim(f_id), '') is not null  -- rxcluimos IDs nulos, vacios o compuestos solo por espacios
