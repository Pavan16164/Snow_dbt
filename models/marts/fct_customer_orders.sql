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

    from {{ ref('silver_lineitem') }} limit 10
