SELECT * FROM public.netflix_cleaned

Q1 SELECT 
    EXTRACT(YEAR FROM date_added) AS year_added,
    type,
    COUNT(*) AS total_content,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY EXTRACT(YEAR FROM date_added)), 1) AS pct_of_year
FROM netflix_cleaned
WHERE date_added IS NOT NULL
GROUP BY EXTRACT(YEAR FROM date_added), type
ORDER BY year_added, type;

Q2a SELECT 
    genre,
    COUNT(*) AS total_content
FROM (
    SELECT UNNEST(STRING_TO_ARRAY(listed_in, ', ')) AS genre
    FROM netflix_cleaned
    WHERE listed_in IS NOT NULL
) AS genre_table
GROUP BY genre
ORDER BY total_content DESC;

Q2b SELECT 
    country_name,
    genre,
    COUNT(*) AS total_content
FROM (
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ', ')) AS country_name,
        UNNEST(STRING_TO_ARRAY(listed_in, ', ')) AS genre
    FROM netflix_cleaned
    WHERE country IS NOT NULL
      AND listed_in IS NOT NULL
) AS country_genre_table
WHERE country_name IN ('United States', 'India', 'United Kingdom', 'South Korea')
GROUP BY country_name, genre
ORDER BY country_name, total_content DESC;

Q3 SELECT 
    year_added,
    country_name,
    COUNT(*) AS total_content,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY year_added), 1) AS pct_of_year
FROM (
    SELECT 
        EXTRACT(YEAR FROM date_added) AS year_added,
        UNNEST(STRING_TO_ARRAY(country, ', ')) AS country_name
    FROM netflix_cleaned
    WHERE country IS NOT NULL AND date_added IS NOT NULL
) AS country_year_table
GROUP BY year_added, country_name
ORDER BY year_added, total_content DESC;

Q4a SELECT 
    rating,
    COUNT(*) AS total_content
FROM netflix_cleaned
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY total_content DESC;

Q4b SELECT 
    EXTRACT(YEAR FROM date_added) AS year_added,
    COUNT(*) FILTER (WHERE rating IN ('TV-MA','R')) AS mature_content,
    COUNT(*) AS total_content,
    ROUND(COUNT(*) FILTER (WHERE rating IN ('TV-MA','R')) * 100.0 / COUNT(*), 1) AS pct_mature
FROM netflix_cleaned
WHERE date_added IS NOT NULL
GROUP BY EXTRACT(YEAR FROM date_added)
ORDER BY year_added;

Q5a SELECT 
    release_year,
    ROUND(AVG(CAST(REPLACE(duration, ' min', '') AS INTEGER)), 1) AS avg_minutes
FROM netflix_cleaned
WHERE type = 'Movie' AND duration IS NOT NULL
GROUP BY release_year
ORDER BY release_year;

Q5b SELECT 
    release_year,
    ROUND(AVG(CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER)), 1) AS avg_seasons
FROM netflix_cleaned
WHERE type = 'TV Show' AND duration IS NOT NULL
GROUP BY release_year
ORDER BY release_year;

Q6a SELECT
    EXTRACT(YEAR FROM date_added) AS year_added,
    COUNT(*) AS total_content
FROM netflix_cleaned
WHERE date_added IS NOT NULL
GROUP BY EXTRACT(YEAR FROM date_added)
ORDER BY total_content DESC
LIMIT 3;

Q6b SELECT
    EXTRACT(YEAR FROM date_added) AS year_added,
    type,
    COUNT(*) AS total_content
FROM netflix_cleaned
WHERE EXTRACT(YEAR FROM date_added) IN (
    SELECT EXTRACT(YEAR FROM date_added)
    FROM netflix_cleaned
    WHERE date_added IS NOT NULL
    GROUP BY EXTRACT(YEAR FROM date_added)
    ORDER BY COUNT(*) DESC
    LIMIT 3
)
GROUP BY EXTRACT(YEAR FROM date_added), type
ORDER BY year_added, total_content DESC;
