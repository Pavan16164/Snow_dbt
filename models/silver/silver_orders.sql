{{
    config(
        materialized = 'incremental',
        unique_key = 'order_id',
        tags = ['snowdbt']
    )
}}
with cte as(
select 
    order_id,
    customer_id,
    order_status,
    total_price,
    order_date,
    dayofweek(order_date) as day_of_week,
    dayname(order_date) as Day_name,
    order_priority,
    {{derive_name('clerk_name')}} as clerk_name,
    ship_priority,
    order_comment,
    raw_ingested_at,
    bronze_ingested_at, 
    cast(current_timestamp() as TIMESTAMP_NTZ) as silver_ingested_at

from {{ref('bronze_orders')}}

{% if is_incremental() %}
    
    where bronze_ingested_at > (select coalesce(max(bronze_ingested_at), '1500-01-01'::timestamp_ntz) from {{ this }})

{% endif %}
),
dedup as (
    select * from cte 
    qualify row_number() over(partition by order_id order by raw_ingested_at desc) = 1
)
select * from dedup