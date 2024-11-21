INSERT INTO actors
WITH last_year AS (
    SELECT *
    FROM actors
    WHERE current_year = 1970
),
current_year AS (
    SELECT 
        actor,
        actorid,
        ARRAY_AGG(
            ROW(
                film,
                votes,
                rating,
                filmid
            )::film_stats
        ) AS films,
		year,
		AVG(rating) AS quality_class
    FROM actor_films
    WHERE year = 1971
    GROUP BY actor, actorid, year
)
	SELECT
		COALESCE(cy.actor, ly.actor) AS actor,
		COALESCE(cy.actorid, ly.actorid) AS actorid,
		CASE WHEN ly.films IS NULL THEN
			cy.films
		WHEN cy.year IS NOT NULL THEN ly.films ||
			cy.films
		ELSE ly.films
		END AS films,
		CASE WHEN cy.year IS NOT NULL THEN
		CASE WHEN cy.quality_class > 8 THEN 'star'
			WHEN cy.quality_class > 7 THEN 'good'
			WHEN cy.quality_class > 6 THEN 'average'
			ELSE 'bad'
		END::quality_class
		ELSE ly.quality_class
		END AS quality_class,
		COALESCE(cy.year, ly.current_year+1) AS current_year,
		CASE WHEN cy.year IS NOT NULL THEN TRUE
		ELSE FALSE
		END AS is_active
	FROM current_year cy FULL OUTER JOIN last_year ly
	ON cy.actorid = ly.actorid;

SELECT * FROM actors;