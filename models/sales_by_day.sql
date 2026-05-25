with valid_orders as (
    select
        order_id,
        to_date(created_at) as order_date
    from {{ source('ecommerce', 'orders') }}
    where upper(status) not in ('CANCELLED', 'RETURNED')
)

select
    o.order_date,
    count(distinct o.order_id) as total_orders,
    sum(oi.sale_price) as total_revenue,
    sum(oi.sale_price) / nullif(count(distinct o.order_id), 0) as avg_order_value
from {{ source('ecommerce', 'order_items') }} as oi
join valid_orders as o on oi.order_id = o.order_id
group by o.order_date
order by o.order_date
