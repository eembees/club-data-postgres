-- models/marts/gender_day_preferences.sql
WITH users_data AS (
    -- Cleaned users data from the staging model
    SELECT 
        id, 
        gender,
        oprettet
    FROM 
        {{ ref('stg__users') }}  -- Referencing the staging model `stg_users`
),

visits_data AS (
    -- Data from stg__hourly_door with gender and day of week
    SELECT
        u.gender,
        EXTRACT(DOW FROM d.timestmp) AS day_of_week,  -- Day of week (0=Sunday, 6=Saturday)
        COUNT(*) AS count
    FROM 
        {{ ref('stg__hourly_door') }} d
    JOIN 
        users_data u ON d.obj_id = u.id
    WHERE
        d.timestmp >= '2023-01-01' AND d.timestmp < '2024-01-01'  -- Filter for visits last year
    GROUP BY 
        u.gender, EXTRACT(DOW FROM d.timestmp)
),

gender_day_preferences AS (
    -- Join with the stat_weekdays seed to get weekday name
    SELECT
        v.gender,
        "wk"."weekday_name" AS weekday,
        v.count
    FROM
        visits_data v
    LEFT JOIN
        {{ ref('stat_weekdays') }} "wk"
    ON 
        v.day_of_week = wk.day_of_week
)

SELECT
    gender,
    weekday,
    count
FROM 
    gender_day_preferences
ORDER BY
    gender, weekday

