WITH source AS (
    SELECT *
    FROM {{ source('olist_bronze', 'olist_sellers_dataset') }}
),

cleaned AS (
    SELECT
        TRIM(seller_id) AS seller_id,
        CAST(seller_zip_code_prefix AS INT) AS seller_zip_code_prefix,
        UPPER(TRIM(seller_city)) AS seller_city,
        UPPER(TRIM(seller_state)) AS seller_state

    FROM source

    WHERE seller_id IS NOT NULL
)

SELECT *
FROM cleaned