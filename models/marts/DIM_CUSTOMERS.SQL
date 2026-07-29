{{
    config(
        materialized = 'table',
        tags = ['snowdbt', 'gold'],
    )
}}

select
    dbt_scd_id as customer_sk, 
    customer_id,
    customer_name,
    address,
    nation_id,
    phone_number,
    account_balance,
    market_segment,
    
    -- SCD2 Metadata
    dbt_valid_from as valid_from,
    coalesce(dbt_valid_to, '9999-12-31'::timestamp_ntz) as valid_to,
    case when dbt_valid_to is null then true else false end as is_current

from {{ ref('snap_customers') }}