{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('fact_trips') }}
)
    select 
    -- Revenue grouping 
    pickup_zone as revenue_zone,
    {{ dbt.date_trunc("year", "pickup_datetime") }} as revenue_year, 

    service_type, 

    -- Revenue calculation 
    sum(fare_amount) as revenue_yearly_fare,
    sum(extra) as revenue_yearly_extra,
    sum(mta_tax) as revenue_yearly_mta_tax,
    sum(tip_amount) as revenue_yearly_tip_amount,
    sum(tolls_amount) as revenue_yearly_tolls_amount,
    sum(improvement_surcharge) as revenue_yearly_improvement_surcharge,
    sum(total_amount) as revenue_yearly_total_amount,

    -- Additional calculations
    count(tripid) as total_yearly_trips,
    avg(passenger_count) as avg_yearly_passenger_count,
    avg(trip_distance) as avg_yearly_trip_distance

    from trips_data
    group by 1,2,3