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
        {{ ref('stg__hourly_door')}}
    GROUP BY 
        obj_id
)

SELECT
    u.id,
    u.gender,
    u.age,
    u.city,
    COALESCE(v.number_of_visits_last_year, 0) AS number_of_visits_last_year
FROM
    users_data u
LEFT JOIN 
    visits_last_year v
    ON u.id = v.user_id

