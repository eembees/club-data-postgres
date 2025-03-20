-- models/marts/marts_users.sql
WITH users_data AS (
    -- Use the cleaned users data from the staging model
    SELECT 
        id, 
        gender, 
        age, 
        city, 
        oprettet
    FROM 
        {{ ref('stg__users') }}  -- Referencing the staging model `stg_users`
),

visits_last_year AS (
    SELECT
        obj_id AS user_id,
        COUNT(*) AS number_of_visits_last_year
    FROM 
        {{ ref('stg__hourly_door') }}
    GROUP BY 
        obj_id
),

favorite_day_of_week AS (
    SELECT
        obj_id AS user_id,
        day_of_week,
        COUNT(*) AS visit_count
    FROM 
        {{ ref('stg__hourly_door') }}
    GROUP BY 
        obj_id, day_of_week
    ORDER BY
        visit_count DESC
),

ranked_days AS (
    SELECT
        user_id,
        day_of_week,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY visit_count DESC) AS row_num
    FROM 
        favorite_day_of_week
)

SELECT
    u.id,
    u.gender,
    u.age,
    u.city,
    COALESCE(v.number_of_visits_last_year, 0) AS number_of_visits_last_year,
    r.day_of_week AS favorite_day_of_week
FROM
    users_data u
LEFT JOIN 
    visits_last_year v
    ON u.id = v.user_id
LEFT JOIN
    ranked_days r
    ON u.id = r.user_id AND r.row_num = 1
