
DROP TYPE IF EXISTS film_stats;
DROP TYPE IF EXISTS quality_class;

CREATE TYPE film_stats AS (
	film TEXT,
	votes INTEGER,
	rating REAL,
	filmid TEXT
);

CREATE TYPE quality_class AS ENUM(
	'star', 'good', 'average', 'bad'
);

DROP TABLE IF EXISTS actors;

CREATE TABLE actors (
	actor TEXT,
	actorid TEXT,
	films film_stats[],
	quality_class quality_class,
	current_year INTEGER,
	is_active BOOLEAN, -- True when the most recent year is the current year
	PRIMARY KEY(actorid, current_year)
	);




