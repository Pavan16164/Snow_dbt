{{
    config(
        materialized = 'incremental',
        unique_key = ['ORDER_ID','line_number'],
        tags = ['snowdbt', 'gold']
    )
}}

with lineitems as (
    select
        order_id,
        part_id,
        supplier_id,
        line_number,
        quantity,
        extended_price,
        discount,
        tax_rate,
        discounted_price,
        total_charged_amount,
        return_flag,
        line_status,
        ship_date,
        shiped_day,
        shipped_day_name,
        commit_date,
        receipt_date,
        shipping_mode,
        silver_ingested_at

    from {{ ref('silver_lineitem') }}

{% if is_incremental() %}
    where silver_ingested_at >= (
        select dateadd(day, -2, coalesce(max(silver_ingested_at), '1500-01-01'::timestamp_ntz)) 
        from {{ this }}
    )
{% endif %}
),

orders as (
    select * 
    from {{ ref('silver_orders') }} o 
    {% if is_incremental() %}
        where exists (
            select 1 from lineitems l where l.order_id = o.order_id
        )
    {% endif %}
),

customers_scd as (
    select * 
    from {{ ref('silver_customer') }} c 
    {% if is_incremental() %}
        where exists (
            select 1 from orders o where o.customer_id = c.customer_id
        )
    {% endif %}
),

parts as (
    select * 
    from {{ ref('silver_parts') }} 
),

joined as (
    select 
        l.order_id as ORDER_ID,
        l.line_number as line_number,
        l.part_id,
        c.customer_id,
        l.supplier_id,
        p.PART_NAME,
        p.brand,
        p.RETAIL_PRICE,

        o.order_date,
        o.order_status,
        O.day_of_week AS "ORDER_DAY",
        l.shipping_mode,
        l.return_flag,
        l.line_status,
        l.ship_date,


        l.quantity,
        l.extended_price,
        l.discount,
        l.tax_rate,
        l.discounted_price,
        l.total_charged_amount,
        l.silver_ingested_at,

        -- 5. Metadata
        current_timestamp() as gold_ingested_at

    from lineitems l
    left join orders o 
        on l.order_id = o.order_id
    left join parts p
        on p.part_id = l.part_id
    left join customers_scd c 
        on o.customer_id = c.customer_id
)

select * from joined