{{
    config(
        materialized = 'incremental',
        tags = ['snowdbt','customers']
    )
}}
with cte as(
select 
    c_custkey as customer_id,
    c_name as customer_name,
    c_address as address,
    c_nationkey as nation_id,
    c_phone as phone_number,
    c_acctbal as account_balance,
    c_mktsegment as market_segment,
    c_comment as customer_comment,
    ingested_at as raw_ingested_at,
    current_timestamp() as bronze_ingested_at

from {{ source('tpch', 'customer') }}

{% if is_incremental() %}
    
    where raw_ingested_at > (select coalesce(max(raw_ingested_at), '1900-01-01'::timestamp_ntz) from {{ this }})

{% endif %}
)
select * FROM cte