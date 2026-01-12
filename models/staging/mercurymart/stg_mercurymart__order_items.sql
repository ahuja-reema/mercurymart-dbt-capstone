select
    order_item_id,
    order_id,
    product_id,
    quantity::int as quantity,
    unit_price::number(10,2) as unit_price,
    (quantity * unit_price)::number(10,2) as gross_item_amount
from {{ source('mercurymart_raw', 'raw_order_items') }}
