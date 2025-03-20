-- models/marts/daily_hour_distribution.sql
WITH hourly_data AS (
    SELECT
        day_of_week,                                     -- Day of the week (0=Sunday, 6=Saturday)
        EXTRACT(HOUR FROM timestmp) AS hour,             -- Hour of the day (0-23)
        EXTRACT(YEAR FROM timestmp) AS year,             -- Year (e.g., 2023)
        COUNT(*) AS count                               -- Number of observations
    FROM 
        {{ ref('stg__hourly_door') }}                    -- Reference to the hourly door data
    GROUP BY 
        day_of_week, hour, year
)

SELECT
    day_of_week,
    hour,
    year,
    count
FROM
    hourly_data
ORDER BY 
    year, day_of_week, hour

