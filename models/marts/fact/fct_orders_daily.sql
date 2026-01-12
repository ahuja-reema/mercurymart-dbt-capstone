{{ config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='merge',
    on_schema_change='sync_all_columns'
) }}

with base as (
    select
        o.order_id,
        o.customer_id,
        o.order_date,
        o.order_status ,
        coalesce(sum(oi.quantity * oi.unit_price),0) as gross_revenue,
        p.payment_amount,
        r.refund_amount,
        greatest((coalesce(sum(oi.quantity * oi.unit_price),0) - coalesce(p.payment_amount,0) - coalesce(r.refund_amount,0)),0) as net_revenue
    from {{ ref('stg_mercurymart__orders') }} o
    left join {{ ref('stg_mercurymart__order_items') }} oi
      on o.order_id = oi.order_id
    left join {{ ref('stg_mercurymart__payments') }} p
      on o.order_id = p.order_id
    left join {{ ref('stg_mercurymart__refunds') }} r
      on o.order_id = r.order_id
    group by 1,2,3,4,p.payment_amount,r.refund_amount
)

select *
from base

{% if is_incremental() %}
  where order_date > (select max(order_date)- interval '1 day' from {{ this }})
{% endif %}
