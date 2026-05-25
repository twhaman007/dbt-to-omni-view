SELECT "PRODUCT_ID" AS "omni_dbt__top_products.product_id",
    "PRODUCT_NAME" AS "omni_dbt__top_products.product_name",
    "TOTAL_QUANTITY" AS "omni_dbt__top_products.total_quantity",
    "TOTAL_SALES" AS "omni_dbt__top_products.total_sales",
    COUNT(*) AS "omni_dbt__top_products.count"
FROM "TOP_PRODUCTS" AS "omni_dbt__top_products"
GROUP BY 1, 2, 3, 4
ORDER BY 5 DESC NULLS LAST
LIMIT 1000
