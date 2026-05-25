with valid_orders as (
    select order_id
    from {{ source('ecommerce', 'orders') }}
    where upper(status) not in ('CANCELLED', 'RETURNED')
),
order_items as (
    select
        order_id,
        product_id,
        quantity,
        item_price
    from {{ source('ecommerce', 'order_items') }}
)

select
    p.product_id,
    p.product_name,
    sum(oi.quantity) as total_quantity,
    sum(oi.quantity * oi.item_price) as total_sales
from order_items oi
join valid_orders o using (order_id)
join {{ source('ecommerce', 'products') }} p using (product_id)
group by p.product_id, p.product_name
order by total_sales desc
limit 50
