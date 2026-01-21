-- 15 Business problems

-- 1. What is the overall distribution of Movies versus TV Shows in Netflix’s content library?

SELECT 
     type,
	 COUNT(*) as total_content
FROM netflix_titles_
GROUP BY TYPE

-- 2. How has Netflix’s preference for Movies vs TV Shows changed over the years?

SELECT 
    release_year,
	type,
    COUNT(*) AS total_content
FROM netflix_titles_
WHERE date_added IS NOT NULL
GROUP BY release_year, type
ORDER BY release_year, type;

-- 3. Which genres dominate Netflix’s catalog?

SELECT 
    genre,
    COUNT(*) AS total_content
FROM (
    SELECT 
        UNNEST(STRING_TO_ARRAY(listed_in, ', ')) AS genre
    FROM netflix_titles_
) AS genre_table
GROUP BY genre
ORDER BY total_content DESC;

-- 4. Are certain genres more likely to be produced as TV Shows rather than Movies?

SELECT 
    genre,
    type,
    COUNT(*) AS total_content
FROM (
    SELECT 
        UNNEST(STRING_TO_ARRAY(listed_in, ', ')) AS genre,
        type
    FROM netflix_titles_
) AS genre_type_table
GROUP BY genre, type
ORDER BY genre, total_content DESC;

-- 5. Which genres have shown consistent growth over the years?

SELECT 
    release_year,
    genre,
    COUNT(*) AS total_titles
FROM (
    SELECT 
        release_year,
        UNNEST(STRING_TO_ARRAY(listed_in, ', ')) AS genre
    FROM netflix_titles_
) AS genre_year_table
GROUP BY release_year, genre
ORDER BY genre, release_year;

-- 6. How has Netflix’s content library grown year by year?

SELECT 
    release_year,
    COUNT(*) AS total_content
FROM netflix_titles_
GROUP BY release_year
ORDER BY release_year;

-- 7. Which years experienced the highest number of content additions?

SELECT 
    release_year,
    COUNT(*) AS total_content
FROM netflix_titles_
GROUP BY release_year
ORDER BY total_content DESC;

-- 8. Is Netflix’s content growth accelerating or slowing down in recent years?

SELECT 
    release_year,
    COUNT(*) AS total_content
FROM netflix_titles_
GROUP BY release_year
ORDER BY release_year;

-- 9. What proportion of Netflix’s content was released in the last 5 years?

SELECT MAX(release_year)
FROM netflix_titles_;

SELECT 
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM netflix_titles_) 
        AS percentage_last_5_years
FROM netflix_titles_
WHERE release_year >= (
    SELECT MAX(release_year) - 5 FROM netflix_titles_
);

-- 10. Which content ratings dominate Netflix’s catalog?

SELECT 
    rating,
    COUNT(*) AS total_content
FROM netflix_titles_
GROUP BY rating
ORDER BY total_content DESC;

-- 11. Has Netflix increasingly focused on mature-rated content over time?

SELECT 
    release_year,
    COUNT(*) AS mature_content
FROM netflix_titles_
WHERE rating IN ('TV-MA', 'R')
GROUP BY release_year
ORDER BY release_year;

-- 12. How does rating distribution differ between Movies and TV Shows?

SELECT 
    type,
    rating,
    COUNT(*) AS total_content
FROM netflix_titles_
GROUP BY type, rating
ORDER BY type, total_content DESC;

-- 13. Which countries contribute the highest volume of content to Netflix?

SELECT 
    country_name,
    COUNT(*) AS total_content
FROM (
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ', ')) AS country_name
    FROM netflix_titles_
    WHERE country IS NOT NULL
) AS country_table
GROUP BY country_name
ORDER BY total_content DESC;

-- 14. How has country-wise content contribution changed over time?

SELECT 
    release_year,
    country_name,
    COUNT(*) AS total_content
FROM (
    SELECT 
        release_year,
        UNNEST(STRING_TO_ARRAY(country, ', ')) AS country_name
    FROM netflix_titles_
    WHERE country IS NOT NULL
) AS country_year_table
GROUP BY release_year, country_name
ORDER BY country_name, release_year;

-- 15. Which countries offer the most diverse genre combinations on Netflix?

SELECT 
    country_name,
    COUNT(DISTINCT genre) AS genre_diversity
FROM (
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ', ')) AS country_name,
        UNNEST(STRING_TO_ARRAY(listed_in, ', ')) AS genre
    FROM netflix_titles_
    WHERE country IS NOT NULL
) AS country_genre_table
GROUP BY country_name
ORDER BY genre_diversity DESC;

