{{ config(materialized='table') }}

WITH distinct_dates AS (
    SELECT DISTINCT CAST(pickup_datetime AS date) AS dt
    FROM {{ ref('fact_trips') }}
)

SELECT
    year(dt) * 1000 + month(dt) * 100 + day(dt) AS date_key,
    year(dt) AS year,
    quarter(dt) AS quarter,
    month(dt) AS month,
    CAST(year(dt) AS varchar) || '/Q' || CAST(quarter(dt) AS varchar) AS year_quarter
FROM distinct_dates
ORDER BY dt
