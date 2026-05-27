select
    u.id as customer_id,
    u.first_name,
    u.last_name,
    u.email,
    u.country,
    u.state,
    u.created_at as created_date
from {{ source('ecommerce', 'users') }} as u
