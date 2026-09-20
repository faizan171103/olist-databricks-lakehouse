WITH source AS (
    SELECT *
    FROM {{ source('olist_bronze', 'olist_order_reviews_dataset') }}
),

cleaned AS (
    SELECT
        TRIM(review_id) AS review_id,
        TRIM(order_id) AS order_id,

        CAST(review_score AS INT) AS review_score,

        CAST(review_comment_title AS STRING) AS review_comment_title,
        CAST(review_comment_message AS STRING) AS review_comment_message,

        CAST(review_creation_date AS TIMESTAMP) AS review_creation_date,
        CAST(review_answer_timestamp AS TIMESTAMP) AS review_answer_timestamp

    FROM source

    WHERE review_id IS NOT NULL
      AND order_id IS NOT NULL
      AND review_score BETWEEN 1 AND 5
)

SELECT *
FROM cleaned