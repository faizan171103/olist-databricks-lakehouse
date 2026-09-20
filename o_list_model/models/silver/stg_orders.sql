WITH source AS (
    SELECT *
    FROM {{ source('olist_bronze', 'olist_orders_dataset') }}
),

cleaned AS (
    SELECT
        TRIM(order_id) AS order_id,
        TRIM(customer_id) AS customer_id,
        LOWER(TRIM(order_status)) AS order_status,

        CAST(order_purchase_timestamp AS TIMESTAMP) AS order_purchase_timestamp,
        CAST(order_approved_at AS TIMESTAMP) AS order_approved_at,
        CAST(order_delivered_carrier_date AS TIMESTAMP) AS order_delivered_carrier_date,
        CAST(order_delivered_customer_date AS TIMESTAMP) AS order_delivered_customer_date,
        CAST(order_estimated_delivery_date AS TIMESTAMP) AS order_estimated_delivery_date

    FROM source

    WHERE order_id IS NOT NULL
      AND customer_id IS NOT NULL
)

SELECT *
FROM cleaned