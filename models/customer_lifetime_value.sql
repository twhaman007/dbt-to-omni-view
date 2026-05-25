with valid_orders as (
    select
        order_id,
        user_id
    from {{ source('ecommerce', 'orders') }}
    where upper(status) not in ('CANCELLED', 'RETURNED')
)

select
    o.user_id as customer_id,
    min(to_date(oi.created_at)) as first_order_date,
    max(to_date(oi.created_at)) as last_order_date,
    count(distinct oi.order_id) as order_count,
    sum(oi.sale_price) as lifetime_revenue,
    sum(oi.sale_price) / nullif(count(distinct oi.order_id), 0) as avg_order_value
from {{ source('ecommerce', 'order_items') }} as oi
join valid_orders as o on oi.order_id = o.order_id
where o.user_id is not null
group by o.user_id
order by lifetime_revenue desc
