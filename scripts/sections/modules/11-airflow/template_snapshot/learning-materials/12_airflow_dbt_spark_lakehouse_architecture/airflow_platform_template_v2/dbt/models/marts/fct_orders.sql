select
    interval_start,
    interval_end,
    count(*) as row_count
from {{ ref('stg_orders') }}
group by 1, 2
