with orders as (
    select
        order_id,
        to_date(order_date) as order_date,
        total_amount
    from {{ source('ecommerce', 'orders') }}
    where upper(status) not in ('CANCELLED', 'RETURNED')
)

select
    order_date,
    count(distinct order_id) as total_orders,
    sum(total_amount) as total_revenue,
    avg(total_amount) as avg_order_value
from orders
group by order_date
order by order_date
