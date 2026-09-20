WITH source AS (
    SELECT *
    FROM {{ source('olist_bronze', 'olist_order_items_dataset') }}
),

cleaned AS (
    SELECT
        TRIM(order_id) AS order_id,
        CAST(order_item_id AS INT) AS order_item_id,
        TRIM(product_id) AS product_id,
        TRIM(seller_id) AS seller_id,
        CAST(shipping_limit_date AS TIMESTAMP) AS shipping_limit_date,
        CAST(price AS DECIMAL(12,2)) AS price,
        CAST(freight_value AS DECIMAL(12,2)) AS freight_value
    FROM source
    WHERE order_id IS NOT NULL
      AND product_id IS NOT NULL
      AND seller_id IS NOT NULL
)

SELECT *
FROM cleaned