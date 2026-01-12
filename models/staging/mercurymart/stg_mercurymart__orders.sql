{{ config(materialized='view') }}

select
    order_id,
    customer_id,
    order_date::date        as order_date,
    status                  as order_status,
    coupon_code,
    campaign_id
from {{ source('mercurymart_raw', 'raw_orders') }}
