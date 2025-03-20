    -- oprettet DATE,
    -- id NUMERIC(38, 0),
    -- gender VARCHAR,
    -- age VARCHAR,
    -- city VARCHAR

with source as 
(
    SELECT id, oprettet, gender, age, city
    FROM raw.users
),

cleaned as 
(
    SELECT
    id, 
    gender,
    oprettet, 
    CAST(split_part(age, ' ', 2) AS INTEGER) as age, 
    city
    FROM source 
)
SELECT * FROM cleaned 
