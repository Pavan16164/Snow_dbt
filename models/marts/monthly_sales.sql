{{
    config(
        materialized = 'table',
        tags = ['snowdbt', 'mart']
    )
}}

with facts as (
    select * from {{ ref('fact_order_lines') }}
),

customers as (
    select * from {{ ref('silver_customer') }}
),

monthly_aggregate as (
    select 
        -- Dimensions (The "Group Bys")
        date_trunc('month', f.order_date) as order_month,
        c.market_segment,
        
        -- Metrics (The "Math")
        count(distinct f.order_id) as total_orders,
        sum(f.quantity) as total_items_sold,
        sum(f.extended_price) as gross_revenue,
        sum(f.discount) as total_discount_given,
        sum(f.total_charged_amount) as net_revenue

    from facts f
    left join customers c
        -- Notice we join on the SK, guaranteeing perfectly accurate historical segments!
        on f.customer_id = c.customer_id
        
    group by 
        date_trunc('month', f.order_date),
        c.market_segment
)

select * from monthly_aggregate