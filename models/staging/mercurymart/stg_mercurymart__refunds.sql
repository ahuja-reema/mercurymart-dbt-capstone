select
    refund_id,
    payment_id,
    order_id,
    refund_date::date as refund_date,
    amount::number(10,2) as refund_amount,
    reason
from {{ source('mercurymart_raw', 'raw_refunds') }}
