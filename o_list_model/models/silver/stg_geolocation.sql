WITH source AS (
    SELECT *
    FROM {{ source('olist_bronze', 'olist_geolocation_dataset') }}
),

cleaned AS (
    SELECT
        CAST(geolocation_zip_code_prefix AS INT) AS geolocation_zip_code_prefix,
        CAST(geolocation_lat AS DECIMAL(12,8)) AS geolocation_lat,
        CAST(geolocation_lng AS DECIMAL(12,8)) AS geolocation_lng,
        UPPER(TRIM(geolocation_city)) AS geolocation_city,
        UPPER(TRIM(geolocation_state)) AS geolocation_state

    FROM source

    WHERE geolocation_zip_code_prefix IS NOT NULL
)

SELECT *
FROM cleaned