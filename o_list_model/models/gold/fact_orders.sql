WITH orders AS (
    SELECT *
    FROM {{ ref('stg_orders') }}
),

customers AS (
    SELECT *
    FROM {{ ref('dim_customers') }}
)

SELECT
    o.order_id,
    o.customer_id,
    c.customer_unique_id,

    o.order_status,

    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    -- Order timing metrics
    DATEDIFF(
        o.order_delivered_customer_date,
        o.order_purchase_timestamp
    ) AS delivery_days,

    DATEDIFF(
        o.order_estimated_delivery_date,
        o.order_delivered_customer_date
    ) AS estimated_vs_actual_delivery_days,

    CASE
        WHEN o.order_delivered_customer_date IS NOT NULL
         AND o.order_estimated_delivery_date IS NOT NULL
         AND o.order_delivered_customer_date
             <= o.order_estimated_delivery_date
        THEN 1
        ELSE 0
    END AS delivered_on_time

FROM orders o

LEFT JOIN customers c
    ON o.customer_id = c.customer_id