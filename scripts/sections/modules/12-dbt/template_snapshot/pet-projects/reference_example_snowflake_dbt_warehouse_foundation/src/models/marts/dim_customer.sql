select
    customer_id::string as customer_id,
    customer_name::string as customer_name,
    customer_email::string as customer_email,
    customer_country::string as customer_country
from {{ source('raw', 'customers') }}
where customer_id is not null
