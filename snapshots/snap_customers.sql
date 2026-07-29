-- snapshots/snap_customers.sql
{% snapshot snap_customers %}

{{
    config(
      target_database='DEV_DB',
      target_schema = 'gold',
      unique_key='customer_id',
      tags = ['snowdbt'],
      strategy='timestamp',
      updated_at='silver_ingested_at'
    )
}}

select * from {{ ref('silver_customer') }}

{% endsnapshot %}