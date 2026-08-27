-- SQL Practice: Movies Database
-- Custom questions and answers for practice
-- Schema:
--   movie (id, title, genre, release_year, duration_mins, language, budget, revenue)
--   director (id, name, country, debut_year)
--   actor (id, name, country, birth_year)
--   movie_director (movie_id, director_id)
--   movie_actor (movie_id, actor_id, role, is_lead)
--   rating (id, movie_id, user_id, score, review_date)
--   user (id, username, country, join_date)

-- ============================================================
-- SECTION 1: Basic SELECT and WHERE
-- ============================================================

-- Q1. Show all movies released after 2020
SELECT title, genre, release_year FROM movie
WHERE release_year > 2020
ORDER BY release_year DESC;

-- Q2. Show all English language movies with budget over $100 million
SELECT title, budget, revenue FROM movie
WHERE language = 'English'
AND budget > 100000000
ORDER BY budget DESC;

-- Q3. Show all directors from South Korea
SELECT name, debut_year FROM director
WHERE country = 'South Korea'
ORDER BY debut_year;

-- Q4. Show all lead actors in action movies
SELECT DISTINCT actor.name
FROM actor
JOIN movie_actor ON actor.id = movie_actor.actor_id
JOIN movie ON movie_actor.movie_id = movie.id
WHERE movie.genre = 'Action'
AND movie_actor.is_lead = 1;

-- Q5. Show movies longer than 3 hours (180 minutes)
SELECT title, duration_mins FROM movie
WHERE duration_mins > 180
ORDER BY duration_mins DESC;

-- ============================================================
-- SECTION 2: Aggregation
-- ============================================================

-- Q6. How many movies are there per genre?
SELECT genre, COUNT(id) AS movie_count
FROM movie
GROUP BY genre
ORDER BY movie_count DESC;

-- Q7. What is the average revenue per language?
SELECT language, ROUND(AVG(revenue), 0) AS avg_revenue
FROM movie
WHERE revenue IS NOT NULL
GROUP BY language
ORDER BY avg_revenue DESC;

-- Q8. Which directors have directed more than 5 movies?
SELECT director.name, COUNT(movie_director.movie_id) AS movie_count
FROM director
JOIN movie_director ON director.id = movie_director.director_id
GROUP BY director.name
HAVING COUNT(movie_director.movie_id) > 5
ORDER BY movie_count DESC;

-- Q9. What is the average rating for each genre?
SELECT movie.genre, ROUND(AVG(rating.score), 2) AS avg_rating
FROM movie
JOIN rating ON movie.id = rating.movie_id
GROUP BY movie.genre
ORDER BY avg_rating DESC;

-- Q10. Which year had the highest total box office revenue?
SELECT release_year, SUM(revenue) AS total_revenue
FROM movie
WHERE revenue IS NOT NULL
GROUP BY release_year
ORDER BY total_revenue DESC
LIMIT 1;

-- ============================================================
-- SECTION 3: JOIN
-- ============================================================

-- Q11. Show each movie with its director name and genre
SELECT movie.title, director.name AS director, movie.genre, movie.release_year
FROM movie
JOIN movie_director ON movie.id = movie_director.movie_id
JOIN director ON movie_director.director_id = director.id
ORDER BY movie.release_year DESC;

-- Q12. Show all movies featuring actors from India
SELECT DISTINCT movie.title, movie.genre
FROM movie
JOIN movie_actor ON movie.id = movie_actor.movie_id
JOIN actor ON movie_actor.actor_id = actor.id
WHERE actor.country = 'India';

-- Q13. Show movies with revenue more than double their budget (profitable films)
SELECT title, budget, revenue,
       ROUND(revenue / budget, 2) AS roi
FROM movie
WHERE revenue > budget * 2
ORDER BY roi DESC;

-- Q14. Show the top rated movie for each genre
SELECT genre, title, avg_score
FROM (
    SELECT movie.genre, movie.title,
           ROUND(AVG(rating.score), 2) AS avg_score
    FROM movie
    JOIN rating ON movie.id = rating.movie_id
    GROUP BY movie.genre, movie.title
) AS rated
WHERE avg_score = (
    SELECT MAX(avg_score_inner)
    FROM (
        SELECT movie.genre AS g,
               ROUND(AVG(rating.score), 2) AS avg_score_inner
        FROM movie JOIN rating ON movie.id = rating.movie_id
        GROUP BY movie.genre, movie.title
    ) AS inner_rated
    WHERE inner_rated.g = rated.genre
);

-- Q15. Show actors who have appeared in more than 10 movies
SELECT actor.name, COUNT(movie_actor.movie_id) AS movie_count
FROM actor
JOIN movie_actor ON actor.id = movie_actor.actor_id
GROUP BY actor.name
HAVING COUNT(movie_actor.movie_id) > 10
ORDER BY movie_count DESC;

-- ============================================================
-- SECTION 4: Subqueries
-- ============================================================

-- Q16. Show movies with above average duration
SELECT title, duration_mins FROM movie
WHERE duration_mins > (SELECT AVG(duration_mins) FROM movie)
ORDER BY duration_mins DESC;

-- Q17. Show directors who have never directed a horror movie
SELECT name FROM director
WHERE id NOT IN (
    SELECT DISTINCT movie_director.director_id
    FROM movie_director
    JOIN movie ON movie_director.movie_id = movie.id
    WHERE movie.genre = 'Horror'
);

-- Q18. Show the most reviewed movie
SELECT movie.title, COUNT(rating.id) AS review_count
FROM movie
JOIN rating ON movie.id = rating.movie_id
GROUP BY movie.title
ORDER BY review_count DESC
LIMIT 1;

-- Q19. Show movies from the same country as the most prolific director
SELECT movie.title, movie.genre, director.country
FROM movie
JOIN movie_director ON movie.id = movie_director.movie_id
JOIN director ON movie_director.director_id = director.id
WHERE director.country = (
    SELECT director.country
    FROM director
    JOIN movie_director ON director.id = movie_director.director_id
    GROUP BY director.country
    ORDER BY COUNT(movie_director.movie_id) DESC
    LIMIT 1
);

-- Q20. Show users who have rated more than 50 movies
SELECT user.username, COUNT(rating.id) AS ratings_given
FROM user
JOIN rating ON user.id = rating.user_id
GROUP BY user.username
HAVING COUNT(rating.id) > 50
ORDER BY ratings_given DESC;
