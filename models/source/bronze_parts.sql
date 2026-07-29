
{{
    config(
        materialized = 'incremental',
        tags = ['snowdbt']

    )
}}
with cte as (
select 
    p_partkey as part_id,
    p_name as part_name,
    p_mfgr as manufacturer,
    p_brand as brand,
    p_type as part_type,
    p_size as part_size,
    p_container as container_type,
    p_retailprice as retail_price,
    p_comment as part_comment,
    
    -- Metadata
    ingested_at as raw_ingested_at,
    cast(current_timestamp() as timestamp_ntz) as bronze_ingested_at

from {{ source('tpch', 'part') }}


{% if is_incremental() %}
    
    where raw_ingested_at > (select coalesce(max(raw_ingested_at), '1900-01-01'::timestamp_ntz) from {{ this }})

{% endif %}

)
select * from CTE