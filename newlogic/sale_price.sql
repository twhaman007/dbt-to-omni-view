SELECT "ID",
    "ORDER_ID",
    "PRODUCT_ID",
    "SALE_PRICE"
FROM {{source('ecommerce', 'order_items')}} AS "omni_dbt__order_items"
GROUP BY 1, 2, 3, 4
