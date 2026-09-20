WITH reviews AS (
    SELECT *
    FROM {{ ref('stg_order_reviews') }}
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
    r.review_id,
    r.order_id,

    r.review_score,
    r.review_comment_title,
    r.review_comment_message,
    r.review_creation_date,
    r.review_answer_timestamp,

    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,

    CASE
        WHEN r.review_score >= 4 THEN 'Positive'
        WHEN r.review_score = 3 THEN 'Neutral'
        WHEN r.review_score <= 2 THEN 'Negative'
        ELSE 'Unknown'
    END AS review_sentiment_category

FROM reviews r

LEFT JOIN orders o
    ON r.order_id = o.order_id