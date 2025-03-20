-- models/marts/gender_day_preferences.sql
WITH visits_data as (
    SELECT * from {{ ref('visits_gender_dow')}}
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

