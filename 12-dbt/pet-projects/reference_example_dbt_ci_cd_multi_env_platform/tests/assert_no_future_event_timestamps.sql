select *
from {{ ref('fct_orders') }}
where event_time > current_timestamp()
