DROP TABLE IF EXISTS actors_history_scd;

CREATE TABLE actors_history_scd (
		actor TEXT,
		quality_class quality_class,
		is_active BOOLEAN,
		start_date INTEGER,
		end_date INTEGER,
		current_year INTEGER,
		PRIMARY KEY(actor, start_date, current_year)
	)