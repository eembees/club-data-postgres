COPY raw.door (
    id,obj_id,token_type,token_media,timestamp
    ) 
FROM '/var/lib/postgresql/data/tmp/data.csv' 
DELIMITER ',' CSV HEADER
;