with orders as (
    select
        customer_id,
        total_amount,
        to_date(order_date) as order_date
    from {{ source('ecommerce', 'orders') }}
    where upper(status) not in ('CANCELLED', 'RETURNED')
)

select
    customer_id,
    min(order_date) as first_order_date,
    max(order_date) as last_order_date,
    count(*) as order_count,
    sum(total_amount) as lifetime_revenue,
    sum(total_amount) / nullif(count(*), 0) as avg_order_value
from orders
where customer_id is not null
group by customer_id
order by lifetime_revenue desc
