SELECT "PRODUCT_ID",
    "PRODUCT_NAME",
    "TOTAL_QUANTITY",
    "TOTAL_SALES",
    COUNT(*) AS "COUNT"
FROM {{ref('top_products')}} AS "omni_dbt__top_products"
GROUP BY 1, 2, 3, 4
