with orders as (
    select
        customer_id,
        to_date(order_date) as order_date
    from {{ source('ecommerce', 'orders') }}
    where upper(status) not in ('CANCELLED', 'RETURNED')
      and customer_id is not null
)

select
    date_trunc('week', order_date) as week_start,
    count(distinct customer_id) as active_customers
from orders
group by week_start
order by week_start
