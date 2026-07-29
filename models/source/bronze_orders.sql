
{{
    config(
        materialized = 'incremental',
        tags = ['snowdbt']

    )
}}
with cte as (
select 
    o_orderkey as order_id,
    o_custkey as customer_id,
    o_orderstatus as order_status,
    o_totalprice as total_price,
    o_orderdate as order_date,
    o_orderpriority as order_priority,
    o_clerk as clerk_name,
    o_shippriority as ship_priority,
    o_comment as order_comment,
    ingested_at as raw_ingested_at,
    current_timestamp() as bronze_ingested_at


from {{ source('tpch', 'orders') }}


{% if is_incremental() %}
    
    where raw_ingested_at > (select coalesce(max(raw_ingested_at), '1900-01-01'::timestamp_ntz) from {{ this }})

{% endif %}

)
select * from CTE