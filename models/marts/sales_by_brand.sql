{{
    config(
        materialized = 'table', 
        tags = ['snowdbt', 'mart']
    )
}}

-- Marts are usually materialized as tables so BI tools can query them instantly

with facts as (
    select * from {{ ref('fact_order_lines') }}
),

parts as (
    select * from {{ ref('silver_parts') }}
),

part_performance as (
    select
        f.part_id,
        p.brand,
        p.part_name,
        p.part_type,
        
        count(distinct f.order_id) as total_orders, 
        sum(f.quantity) as total_units_sold,
        sum(f.total_charged_amount) as total_sales_revenue

    from facts f
    left join parts p
        on f.part_id = p.part_id
        
    group by 
        f.part_id,
        p.brand,
        p.part_name,
        p.part_type
)

select * from part_performance