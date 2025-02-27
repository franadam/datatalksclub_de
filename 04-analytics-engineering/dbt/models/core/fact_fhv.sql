{{
    config(
        materialized='table'
    )
}}


select
    fhv.pickup_locationid,
    fhv.dropoff_locationid,
    fhv.pickup_datetime,
    fhv.dropoff_datetime,
    fhv.sr_flag
from {{ ref('stg_staging__fhv_tripdata') }} as fhv
join dim_zones as pickup_zone
    on fhv.pickup_locationid = pickup_zone.locationid
join dim_zones as dropoff_zone
    on fhv.dropoff_locationid = dropoff_zone.locationid
where pickup_zone.borough != 'Unknown' and dropoff_zone.borough != 'Unknown' 