select
    customer_id,
    customer_name,
    email,
    age,

    case
        when age is null or age < 0 then 'Unknown'
        when age < 18 then 'Under 18'
        when age < 25 then '18-24'
        when age < 40 then '25-39'
        when age < 55 then '40-54'
        when age < 65 then '55-64'
        else '65+'
    end as age_segment,

    gender,
    marital_status,
    occupation,
    income_band,
    education,
    family_size

from {{ ref('stg_users') }}