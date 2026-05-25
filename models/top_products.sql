with valid_orders as (
    select order_id
    from {{ source('ecommerce', 'orders') }}
    where upper(status) not in ('CANCELLED', 'RETURNED')
)

select
    p.id as product_id,
    p.name as product_name,
    count(*) as total_quantity,
    sum(oi.sale_price) as total_sales
from {{ source('ecommerce', 'order_items') }} as oi
join valid_orders as o on oi.order_id = o.order_id
join {{ source('ecommerce', 'products') }} as p on oi.product_id = p.id
group by p.id, p.name
order by total_sales desc
limit 50
