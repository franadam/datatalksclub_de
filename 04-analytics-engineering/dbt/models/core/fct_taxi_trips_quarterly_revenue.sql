{{
    config(
        materialized='table'
    )
}}

SELECT
    service_type,
    year,
    quarter,
    SUM(total_amount) as total_quaterly_amount,
    NULLIF(LAG(SUM(total_amount)) OVER (PARTITION BY service_type, quarter ORDER BY year), 0) AS prev_year_revenue,
    (SUM(total_amount) - LAG(SUM(total_amount)) OVER (PARTITION BY service_type, quarter ORDER BY year)) / 
        NULLIF(LAG(SUM(total_amount)) OVER (PARTITION BY service_type, quarter ORDER BY year), 0) AS yoy_growth
FROM {{ ref('fact_trips') }} ft
JOIN dim_date dd
    ON   year(ft.pickup_datetime) = dd.year and quarter(ft.pickup_datetime) = dd.quarter
GROUP BY 
    service_type,
    year,
    quarter