{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

select
    order_id,
    customer_id,
    product_id,
    order_status,
    order_amount,
    updated_at,
    ingested_at
from {{ ref('int_orders_enriched') }}

{% if is_incremental() %}
where ingested_at >= (
    select coalesce(dateadd(minute, -10, max(ingested_at)), '1970-01-01'::timestamp_ntz)
    from {{ this }}
)
{% endif %}
