{{
    config(
        materialized = 'incremental',
        unique_key = ['order_id', 'line_number'],
        tags = ['snowdbt']
    )
}}

with new_bronze_data as (
    select 
        order_id,
        part_id,
        supplier_id,
        line_number,
        quantity,
        extended_price,
        discount,
        tax_rate,
        return_flag,
        line_status,
        ship_date,
        dayofweek(ship_date) as shiped_day,
        dayname(ship_date) as shipped_day_name, 
        round({{ calculate_discounted_price('extended_price', 'discount') }},4) as discounted_price,
        round({{ calculate_total_charged_amount('extended_price', 'discount', 'tax_rate') }},4) as total_charged_amount,
        commit_date,
        receipt_date,
        shipping_instructions,
        shipping_mode,
        line_item_comment,
        raw_ingested_at,
        bronze_ingested_at,
        cast(current_timestamp() as timestamp_ntz) as silver_ingested_at

    from {{ ref('bronze_lineitem') }}
    
    {% if is_incremental() %}
        where bronze_ingested_at > (select coalesce(max(bronze_ingested_at), '1900-01-01'::timestamp_ntz) from {{ this }})
    {% endif %}
),

dedup as (
    select * from new_bronze_data 
    qualify row_number() over(partition by order_id, line_number order by raw_ingested_at desc) = 1
)

-- Added the missing final select statement
select * from dedup