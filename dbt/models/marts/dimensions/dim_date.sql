with spine as (
    select
        dateadd(
            day,
            row_number() over (order by seq4()) - 1,
            '2024-01-01'::date
        ) as date_day
    from table(generator(rowcount => 1200))

)

select
    to_char(date_day, 'YYYYMMDD')::number(8, 0) as date_key,
    date_day,

    year(date_day) as year,
    quarter(date_day) as quarter,
    month(date_day) as month,
    monthname(date_day) as month_name,

    weekiso(date_day) as iso_week,
    yearofweekiso(date_day) as iso_week_year,

    day(date_day) as day_of_month,
    dayofweekiso(date_day) as day_of_week,
    dayname(date_day) as day_name,

    (dayofweekiso(date_day) >= 6) as is_weekend

from spine
where date_day <= '2026-12-31'::date