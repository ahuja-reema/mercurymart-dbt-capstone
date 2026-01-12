{{ config(materialized='table') }}

with first_orders as (
    select
        customer_id,
        min(order_date) as first_order_date
    from {{ ref('stg_mercurymart__orders') }}
    group by customer_id
),

lifetime_orders as (
    select
        o.customer_id,
        sum(oi.quantity * oi.unit_price) as lifetime_value
    from {{ ref('stg_mercurymart__orders') }} o
    join {{ ref('stg_mercurymart__order_items') }} oi
      on o.order_id = oi.order_id
    group by o.customer_id
)

select
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.customer_created_date,
    c.country,
    c.segment,
    f.first_order_date,
    l.lifetime_value,
    case
        when l.lifetime_value >= 1000 then 'Gold'
        when l.lifetime_value >= 500 then 'Silver'
        else 'Bronze'
    end as loyalty_tier
from {{ ref('stg_mercurymart__customers') }} c
left join first_orders f on c.customer_id = f.customer_id
left join lifetime_orders l on c.customer_id = l.customer_id
