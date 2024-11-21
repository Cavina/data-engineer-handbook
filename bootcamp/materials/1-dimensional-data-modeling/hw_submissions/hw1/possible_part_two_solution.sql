WITH last_year AS (
	SELECT 
	actor,
	actorid,
	year,
	ARRAY_AGG(films_stats) AS films_array,
	AVG(rating) AS avg_rating
	FROM 
	(
		SELECT 
		actor,
		actorid,
		year,
		rating,
		ROW( 
			film,
			votes,
			rating,
			filmid,
			year)::film_stats AS films_stats
	FROM actor_films af
	WHERE af.year = 1969
	) a1
	GROUP BY actor, actorid, year
),
	current_year AS (
	SELECT 
		actor,
		actorid,
		year,
		ARRAY_AGG(films_stats) AS films_array,
		AVG(rating) AS avg_rating
	FROM (
		SELECT
		actor,
		actorid,
		year,
		rating,
		ROW( 
			film,
			votes,
			rating,
			filmid,
			year)::film_stats AS films_stats
	FROM actor_films af
	WHERE af.year = 1970
	) a2
	GROUP BY actor, actorid, year
	) 

	
SELECT 
	*
FROM current_year cy FULL OUTER JOIN last_year ly
ON cy.actorid = ly.actorid;
