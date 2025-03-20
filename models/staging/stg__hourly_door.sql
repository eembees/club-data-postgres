with source as (
    {#-
    Normally we would select from the table here, but we are using seeds to load
    our data in this project
    #}
    SELECT id, obj_id, token_type, token_media, "timestamp" AT TIME ZONE 'Europe/Copenhagen' AS timestmp
    FROM raw.door
    WHERE
        "timestamp" >= '2024-01-01'
),

localized as (
    SELECT
        id,
        obj_id,
        token_type AS member_type,
        token_media AS access_type,
        timestmp, 
        DATE_TRUNC('hour', timestmp) AS timestamp_hourly,
        EXTRACT(DOW FROM timestmp) AS day_of_week  -- Extracting the day of the week
    FROM source
)

SELECT * 
FROM localized
