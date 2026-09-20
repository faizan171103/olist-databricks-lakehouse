WITH order_items AS (
    SELECT *
    FROM {{ ref('stg_order_items') }}
),

orders AS (
    SELECT
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp
    FROM {{ ref('stg_orders') }}
),

products AS (
    SELECT
        product_id,
        product_category_name,
        product_category_name_english
    FROM {{ ref('dim_products') }}
),

sellers AS (
    SELECT
        seller_id,
        seller_city,
        seller_state
    FROM {{ ref('dim_sellers') }}
)

SELECT
    oi.order_id,
    oi.order_item_id,

    oi.product_id,
    p.product_category_name,
    p.product_category_name_english,

    oi.seller_id,
    s.seller_city,
    s.seller_state,

    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,

    oi.shipping_limit_date,

    oi.price,
    oi.freight_value,

    -- Revenue metrics
    oi.price + oi.freight_value AS item_total_value,

    CASE
        WHEN oi.price > 0
        THEN oi.freight_value / oi.price
        ELSE NULL
    END AS freight_to_price_ratio

FROM order_items oi

LEFT JOIN orders o
    ON oi.order_id = o.order_id

LEFT JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id