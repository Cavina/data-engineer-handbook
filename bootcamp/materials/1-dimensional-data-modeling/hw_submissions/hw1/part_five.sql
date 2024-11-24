-- CREATE TYPE actor_scd_type AS (
-- 			quality_class quality_class,
-- 			is_active boolean,
-- 			start_date INTEGER,
-- 			end_date INTEGER
-- 			);
-- DROP TYPE actor_scd_type;

WITH last_year_scd AS (
	SELECT * 
	FROM actors_history_scd
	WHERE current_year = 1973
	AND end_date = 1973
),
	historical_scd AS (
		SELECT 
			actor,
			quality_class,
			is_active,
			start_date,
			end_date
		FROM actors_history_scd
		WHERE current_year = 1973
		AND end_date < 1973
	),
	this_year_data AS (
		SELECT * FROM actors
		WHERE current_year = 1974
	),
	unchanged_records AS (
	SELECT
		ty.actor,
		ty.quality_class,
		ty.is_active,
		ly.start_date,
		ty.current_year AS end_date
	FROM this_year_data ty
	JOIN last_year_scd ly
	ON ly.actor = ty.actor
	WHERE ty.quality_class = ly.quality_class
	AND ty.is_active = ly.is_active
	),
	changed_records AS (
	SELECT
		ty.actor,
		UNNEST(ARRAY[
			ROW(
				ly.quality_class,
				ly.is_active,
				ly.start_date,
				ly.end_date
				)::actor_scd_type,
			ROW(
				ty.quality_class,
				ty.is_active,
				ty.current_year,
				ty.current_year
			)::actor_scd_type
		]) AS records
		FROM this_year_data ty
		LEFT JOIN last_year_scd ly
		ON ly.actor = ty.actor
		WHERE (ty.quality_class <> ly.quality_class
		OR ty.is_active <> ly.is_active)
	),
	unnested_changed_records AS (
	SELECT actor,
			(records::actor_scd_type).quality_class,
			(records::actor_scd_type).is_active,
			(records::actor_scd_type).start_date,
			(records::actor_scd_type).end_date
	FROM changed_records
	),
	new_records AS (
		SELECT
			ty.actor,
			ty.quality_class,
			ty.is_active,
			ty.current_year AS start_date,
			ty.current_year AS end_date
		FROM this_year_data ty
		LEFT JOIN last_year_scd ly
		ON ty.actor = ly.actor
		WHERE ly.actor IS NULL
	)
	SELECT *,
		1974 AS current_year FROM (
			SELECT *
			FROM historical_scd

			UNION ALL

			SELECT *
			FROM unchanged_records

			UNION ALL

			SELECT * FROM unnested_changed_records

			UNION ALL 

			SELECT * FROM new_records
		) a

	