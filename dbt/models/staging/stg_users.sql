select
    -- Limpiamos el ID sin convertirlo a número
    nullif(trim(user_id::varchar), '') as customer_id,

    -- Conservamos la escritura del nombre y quitamos espacios exteriores
    nullif(trim(name), '') as customer_name,

    -- Unificamos el correo en minúsculas
    nullif(lower(trim(email)), '') as email,

    -- Convertimos la edad a número
    try_to_number(age::varchar) as age,

    -- Limpiamos las categorías y unificamos su escritura
    nullif(initcap(trim(gender)), '') as gender,
    nullif(initcap(trim(marital_status)), '') as marital_status,

    -- Corregimos el error de escritura que encontramos en la muestra
    case
        when upper(trim(occupation)) in (
            'SELF EMPLOYEED', 'SELF EMPLOYED'
        ) then 'Self Employed'
        else nullif(initcap(trim(occupation)), '')
    end as occupation,

    -- El ingreso es una categoría, no un importe exacto
    nullif(trim(monthly_income), '') as income_band,

    -- Conservamos la escritura de categorías como Ph.D
    nullif(trim(education), '') as education,

    -- Convertimos el tamaño de la familia a número
    try_to_number(family_size::varchar) as family_size

from {{ source('raw', 'users') }}