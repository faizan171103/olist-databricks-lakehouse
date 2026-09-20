WITH date_range AS (

    SELECT
        MIN(CAST(order_purchase_timestamp AS DATE)) AS min_date,
        MAX(CAST(order_purchase_timestamp AS DATE)) AS max_date
    FROM {{ ref('stg_orders') }}

),

dates AS (

    SELECT
        EXPLODE(
            SEQUENCE(
                min_date,
                max_date,
                INTERVAL 1 DAY
            )
        ) AS date_day
    FROM date_range

)

SELECT
    date_day AS date,

    YEAR(date_day) AS year,

    QUARTER(date_day) AS quarter,

    MONTH(date_day) AS month,

    MONTHNAME(date_day) AS month_name,

    WEEKOFYEAR(date_day) AS week_of_year,

    DAYOFMONTH(date_day) AS day_of_month,

    DAYOFWEEK(date_day) AS day_of_week,

    DAYNAME(date_day) AS day_name,

    CASE
        WHEN DAYOFWEEK(date_day) IN (1, 7)
        THEN 1
        ELSE 0
    END AS is_weekend

FROM dates