select
    order_id::string as order_id,
    customer_id::string as customer_id,
    product_id::string as product_id,
    status::string as order_status,
    try_cast(amount as number(18,2)) as order_amount,
    try_to_timestamp_ntz(updated_at) as updated_at,
    try_to_timestamp_ntz(ingested_at) as ingested_at
from {{ source('raw', 'orders') }}
where order_id is not null
