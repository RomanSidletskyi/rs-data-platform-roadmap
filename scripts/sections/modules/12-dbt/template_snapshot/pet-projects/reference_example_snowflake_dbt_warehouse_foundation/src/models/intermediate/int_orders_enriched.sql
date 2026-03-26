with orders as (

    select *
    from {{ ref('stg_orders') }}

), latest_orders as (

    select *
    from (
        select
            *,
            row_number() over (
                partition by order_id
                order by updated_at desc, ingested_at desc
            ) as rn
        from orders
    ) ranked
    where rn = 1

)

select
    order_id,
    customer_id,
    product_id,
    order_status,
    order_amount,
    updated_at,
    ingested_at
from latest_orders
