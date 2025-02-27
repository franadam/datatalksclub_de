{{
    config(
        materialized='table'
    )
}}

SELECT
    service_type,
    year,
    month,
    SUM(fare_amount) as total_monthly_amount,
    NULLIF(LAG(SUM(fare_amount)) OVER (PARTITION BY service_type, month ORDER BY year), 0) AS prev_year_revenue,
    (SUM(fare_amount) - LAG(SUM(fare_amount)) OVER (PARTITION BY service_type, month ORDER BY year)) / 
        NULLIF(LAG(SUM(fare_amount)) OVER (PARTITION BY service_type, month ORDER BY year), 0) AS yoy_growth
FROM {{ ref('fact_trips') }} ft
JOIN dim_date dd
    ON   year(ft.pickup_datetime) = dd.year and month(ft.pickup_datetime) = dd.month
WHERE 
    fare_amount > 0 and
    trip_distance > 0 and 
    payment_type_description in ('Cash', 'Credit Card')
GROUP BY 
    service_type,
    year,
    month