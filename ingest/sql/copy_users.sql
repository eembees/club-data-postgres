COPY raw.users (
    oprettet, id, gender, age, city
    ) 
FROM '/var/lib/postgresql/data/tmp/users.csv' 
DELIMITER ';' 
CSV HEADER;