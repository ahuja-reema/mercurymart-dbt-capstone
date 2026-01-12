select
    customer_id,
    first_name,
    last_name,
    lower(email) as email,
    to_date(signup_date) as customer_created_date,
    country,
    segment
from {{ source('mercurymart_raw', 'raw_customers') }}
