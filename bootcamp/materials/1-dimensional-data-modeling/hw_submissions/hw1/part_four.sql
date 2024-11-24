INSERT INTO actors_history_scd
WITH with_previous AS(
SELECT
	actor,
	quality_class,
	current_year,
	is_active,
	LAG(quality_class, 1) OVER (PARTITION BY actor ORDER BY current_year) AS previous_quality_class,
	LAG(is_active, 1) OVER (PARTITION BY actor ORDER BY current_year) AS previous_is_active
	FROM actors
),
	with_indicators AS (
	SELECT *,
		CASE WHEN quality_class <> previous_quality_class THEN 1
		WHEN is_active <> previous_is_active THEN 1
		ELSE 0
		END AS change_indicator
	FROM with_previous
),
	with_streaks AS (
	SELECT *,
		SUM(change_indicator) OVER (PARTITION BY actor ORDER BY current_year) AS streak_identifier
	FROM with_indicators
	)

	-- SELECT actor, 
	-- 	streak_identifier,
	-- 	is_active,
	-- 	quality_class,
	-- 	MIN(current_year) AS start_year,
	-- 	MAX(current_year) AS end_year
	-- FROM with_streaks
	-- GROUP BY 1,2,3,4

	SELECT actor, 
	quality_class,
	is_active,
	MIN(current_year) AS start_year,
	MAX(current_year) AS end_year,
	1974 AS current_year
	FROM with_streaks
	GROUP BY 1,2,3


-- SELECT * FROM actors_history_scd
	