select
    payment_id,
    order_id,
    payment_date::date as payment_date,
    payment_method,
    amount::number(10,2) as payment_amount,
    status as payment_status
from {{ source('mercurymart_raw', 'raw_payments') }}
