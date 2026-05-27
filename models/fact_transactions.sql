with order_totals as (
    select
        oi.order_id,
        sum(oi.sale_price) as transaction_total,
        avg(oi.sale_price) as average_transaction_total,
        approx_percentile(oi.sale_price, 0.5) as median_sales
    from {{ source('ecommerce', 'order_items') }} as oi
    group by oi.order_id
),
valid_orders as (
    select
        order_id,
        user_id,
        created_at,
        status
    from {{ source('ecommerce', 'orders') }}
    where upper(status) not in ('CANCELLED', 'RETURNED')
)

select
    o.order_id as transaction_id,
    o.user_id as customer_id,
    to_date(o.created_at) as transaction_date,
    u.country as order_country,
    ot.transaction_total,
    ot.average_transaction_total,
    ot.median_sales
from valid_orders as o
join order_totals as ot on o.order_id = ot.order_id
left join {{ source('ecommerce', 'users') }} as u on o.user_id = u.id
