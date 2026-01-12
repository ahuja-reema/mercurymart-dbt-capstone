{{ config(materialized='table') }}

select
    p.product_id,
    p.product_name,
    p.category,
    p.brand,
    p.supplier_id,
    case
        when p.unit_price >= 100 then 'High'
        when p.unit_price >= 50 then 'Medium'
        else 'Low'
    end as price_bucket
from {{ ref('stg_mercurymart__products') }} p
