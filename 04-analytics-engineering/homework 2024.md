## Module 4 Homework  (DRAFT)

In this homework, we'll use the models developed during the week 4 videos and enhance the already presented dbt project using the already loaded Taxi data for fhv vehicles for year 2019 in our DWH.

This means that in this homework we use the following data [Datasets list](https://github.com/DataTalksClub/nyc-tlc-data/)
* Yellow taxi data - Years 2019 and 2020
* Green taxi data - Years 2019 and 2020 
* fhv data - Year 2019. 

We will use the data loaded for:

* Building a source table: `stg_fhv_tripdata`
* Building a fact table: `fact_fhv_trips`
* Create a dashboard 

If you don't have access to GCP, you can do this locally using the ingested data from your Postgres database
instead. If you have access to GCP, you don't need to do it for local Postgres - only if you want to.

> **Note**: if your answer doesn't match exactly, select the closest option 

### Question 1: 

**What happens when we execute dbt build --vars '{'is_test_run':'true'}'**
You'll need to have completed the ["Build the first dbt models"](https://www.youtube.com/watch?v=UVI30Vxzd6c) video. 

`It applies a _limit 100_ only to our staging models`


### Question 2: 

**What is the code that our CI job will run? Where is this code coming from?**  

`The code that has been merged into the main branch`



### Question 3 (2 points)

**What is the count of records in the model fact_fhv_trips after running all dependencies with the test run variable disabled (:false)?**  
Create a staging model for the fhv data, similar to the ones made for yellow and green data. Add an additional filter for keeping only records with pickup time in year 2019.
Do not add a deduplication step. Run this models without limits (is_test_run: false).

Create a core model similar to fact trips, but selecting from stg_fhv_tripdata and joining with dim_zones.
Similar to what we've done in fact_trips, keep only records with known pickup and dropoff locations entries for pickup and dropoff locations. 
Run the dbt model without limits (is_test_run: false).

`22998722`
<br>
Here the fact_fhv script and  the command line to build the model.
```sql
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
```

```bash
dbt build --select +fact_fhv+ --vars '{'is_test_run': 'false'}'
```
### Question 4 (2 points)

**What is the service that had the most rides during the month of July 2019 month with the biggest amount of rides after building a tile for the fact_fhv_trips table and the fact_trips tile as seen in the videos?**

Create a dashboard with some tiles that you find interesting to explore the data. One tile should show the amount of trips per month, as done in the videos for fact_trips, including the fact_fhv_trips data.

```sql
with green_yellow_trips as (
    select
        service_type,
        count(*) as total_rides
    from {{ ref('fact_trips.sql') }}
    where 
        extract(year(pickup_datetime)) = 2019 and
        extract(month(pickup_datetime)) = 7
    group by 1
), 
fhv_trips as (
    select
        service_type,
        count(*) as total_rides
    from {{ ref('fact_fhv.sql') }}
    where 
        extract(year(pickup_datetime)) = 2019 and
        extract(month(pickup_datetime)) = 7
    group by 1 
)
```
`Yellow`


## Submitting the solutions

* Form for submitting: https://courses.datatalks.club/de-zoomcamp-2024/homework/hw4

Deadline: 22 February (Thursday), 22:00 CET


## Solution

To be published after deadline
