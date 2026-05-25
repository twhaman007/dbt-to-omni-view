select
    date_trunc('week', to_date(created_at)) as week_start,
    count(distinct user_id) as active_customers
from {{ source('ecommerce', 'orders') }}
where upper(status) not in ('CANCELLED', 'RETURNED')
  and user_id is not null
group by week_start
order by week_start
