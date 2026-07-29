{{
    config(
        materialized = 'incremental',
        unique_key = 'part_id',
        tags = ['snowdbt']
    )
}}


with cte as (
    select * , current_timestamp() as silver_ingested_at from {{ref('bronze_parts')}}
),

dedup as (
    select * from cte 
    qualify row_number() over(partition by part_id order by raw_ingested_at desc) = 1
)

select * from dedup