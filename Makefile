.PHONY: clean all
# note use gsed which is gnused (brew install gnu-sed)
TODAY := $(shell date +"%B %e, %Y")

clean:
		rm -rf pdfs/*
# Rule to compile PDFs from .md files in the lectures directory into the pdfs folder
slides: 
	pandoc -s --slide-level 2 -t beamer --pdf-engine lualatex -H ./deck/preamble_beamer.tex ./deck/slides.md -o ./deck/slides.pdf;

tables:
	docker exec -i postgres psql -U postgres -d postgres -f /Users/mags/Code/club-data-postgres/ingest/sql/create_door.sql -f /Users/mags/Code/club-data-postgres/ingest/sql/create_users.sql

ingestion:
	cp ingest/*.csv ./data/tmp
	docker exec -i postgres psql -U postgres -d postgres -c "COPY users (oprettet, id, gender, alder, city) FROM 'var/lib/postgresql/data/tmp/users.csv' DELIMITER ';' CSV HEADER;"
	docker exec -i postgres psql -U postgres -d postgres -c ""


dbt-build:
	docker-compose run dbt build


dbt-test:
	docker-compose run dbt test


dbt-compile:
	docker-compose run dbt compile