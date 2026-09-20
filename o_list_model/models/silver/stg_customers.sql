WITH source AS (

    SELECT *
    FROM {{ source('olist_bronze', 'olist_customers_dataset') }}

),

cleaned AS (

    SELECT
        TRIM(customer_id) AS customer_id,
        TRIM(customer_unique_id) AS customer_unique_id,
        CAST(customer_zip_code_prefix AS INT) AS customer_zip_code_prefix,
        UPPER(TRIM(customer_city)) AS customer_city,
        UPPER(TRIM(customer_state)) AS customer_state

    FROM source

    WHERE customer_id IS NOT NULL

)

SELECT *
FROM cleaned