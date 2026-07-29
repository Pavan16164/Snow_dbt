
{{
    config(
        materialized = 'incremental',
        tags = ['snowdbt']

    )
}}
with cte as (
select 
    l_orderkey as order_id,
    l_partkey as part_id,
    l_suppkey as supplier_id,
    l_linenumber as line_number,
    l_quantity as quantity,
    l_extendedprice as extended_price,
    l_discount as discount,
    l_tax as tax_rate,
    l_returnflag as return_flag,
    l_linestatus as line_status,
    l_shipdate as ship_date,
    l_commitdate as commit_date,
    l_receiptdate as receipt_date,
    l_shipinstruct as shipping_instructions,
    l_shipmode as shipping_mode,
    l_comment as line_item_comment,
    
    ingested_at as raw_ingested_at,
    current_timestamp() as bronze_ingested_at

from {{ source('tpch', 'lineitem') }}


{% if is_incremental() %}
    
    where raw_ingested_at > (select coalesce(max(raw_ingested_at), '1900-01-01'::timestamp_ntz) from {{ this }})

{% endif %}

)
select * from cte