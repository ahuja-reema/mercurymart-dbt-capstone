{{ config(materialized='view') }}

select
    product_id,
    product_name,
    category,
    brand,
    unit_price::number(10,2) as unit_price,
    supplier_id

from {{ source('mercurymart_raw', 'raw_products') }}