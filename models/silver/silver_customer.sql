{{
    config(
        materialized = 'incremental',
        unique_key = 'customer_id',
        tags = ['snowdbt']
    )
}}

with cte AS(

select  *, cast(current_timestamp() as TIMESTAMP_NTZ) as silver_ingested_at

from {{ref('bronze_customer')}}

{% if is_incremental() %}
    
    where bronze_ingested_at > (select coalesce(max(bronze_ingested_at), '1900-01-01'::timestamp_ntz) from {{ this }})

{% endif %}
),
dedup as (
    select * from cte qualify row_number() over(partition by customer_id order by raw_ingested_at desc) =1
)

select * from dedup
