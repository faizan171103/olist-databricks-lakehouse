WITH source AS (
    SELECT *
    FROM {{ source('olist_bronze', 'product_category_name_translation') }}
),

cleaned AS (
    SELECT
        TRIM(product_category_name) AS product_category_name,
        TRIM(product_category_name_english) AS product_category_name_english
    FROM source

    WHERE product_category_name IS NOT NULL
      AND product_category_name_english IS NOT NULL
)

SELECT *
FROM cleaned