WITH source AS (
    SELECT *
    FROM {{ source('olist_bronze', 'olist_order_payments_dataset') }}
),

cleaned AS (
    SELECT
        TRIM(order_id) AS order_id,
        CAST(payment_sequential AS INT) AS payment_sequential,
        LOWER(TRIM(payment_type)) AS payment_type,
        CAST(payment_installments AS INT) AS payment_installments,
        CAST(payment_value AS DECIMAL(12,2)) AS payment_value

    FROM source

    WHERE order_id IS NOT NULL
      AND payment_type IS NOT NULL
      AND payment_value IS NOT NULL
)

SELECT *
FROM cleaned
