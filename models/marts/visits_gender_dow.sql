-- models/marts/gender_day_preferences.sql
WITH users_data AS (
    -- Cleaned users data from the staging model
    SELECT 
        id, 
        gender
    FROM 
        {{ ref('stg__users') }}  -- Referencing the staging model `stg_users`
),

visits_data AS (
    -- Data from stg__hourly_door with gender and day of week
    SELECT
        u.gender,
        day_of_week,
        COUNT(*) AS count
    FROM 
        {{ ref('stg__hourly_door') }} d
    JOIN 
        users_data u ON d.obj_id = u.id
    GROUP BY 
        u.gender, day_of_week
)

SELECT * FROM visits_data