WITH payments AS (
    SELECT *
    FROM {{ ref('stg_order_payments') }}
),

orders AS (
    SELECT
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp
    FROM {{ ref('stg_orders') }}
)

SELECT
    p.order_id,
    p.payment_sequential,
    p.payment_type,
    p.payment_installments,
    p.payment_value,

    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp

FROM payments p

LEFT JOIN orders o
    ON p.order_id = o.order_id