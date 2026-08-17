-- SQLZoo: More JOIN Operations
-- Source: https://www.sqlzoo.net/wiki/More_JOIN_operations
-- Tables: movie (id, title, yr, director, budget, gross)
--         actor (id, name)
--         casting (movieid, actorid, ord)
-- Key concepts: Multi-table JOIN, subqueries with JOIN, GROUP BY with JOIN

-- 1. 1962 movies with budget over 2 million
SELECT id, title
FROM movie
WHERE yr = 1962
AND budget > 2000000;

-- 2. When was Citizen Kane released?
SELECT yr
FROM movie
WHERE title = 'Citizen Kane';

-- 3. Star Trek movies ordered by year
SELECT id, title, yr
FROM movie
WHERE title LIKE 'Star Trek%'
ORDER BY yr;

-- 4. ID for actor Glenn Close
SELECT id FROM actor
WHERE name = 'Glenn Close';

-- 5. ID for Casablanca (1942)
SELECT id
FROM movie
WHERE title = 'Casablanca'
AND yr = 1942;

-- 6. Cast list for Casablanca
SELECT name
FROM casting JOIN actor ON casting.actorid = actor.id
WHERE movieid = (
    SELECT id FROM movie
    WHERE title = 'Casablanca' AND yr = 1942
);

-- 7. Cast list for Alien
SELECT name
FROM movie JOIN casting ON movie.id = casting.movieid
           JOIN actor ON casting.actorid = actor.id
WHERE title = 'Alien';

-- 8. Films Harrison Ford appeared in
SELECT title
FROM movie JOIN casting ON movie.id = casting.movieid
           JOIN actor ON casting.actorid = actor.id
WHERE name = 'Harrison Ford';

-- 9. Films where Harrison Ford was NOT the lead (ord > 1)
SELECT title
FROM movie JOIN casting ON movie.id = casting.movieid
           JOIN actor ON casting.actorid = actor.id
WHERE name = 'Harrison Ford'
AND ord <> 1;

-- 10. Lead actors in 1962 films
SELECT title, name
FROM movie JOIN casting ON movie.id = casting.movieid
           JOIN actor ON casting.actorid = actor.id
WHERE yr = 1962
AND ord = 1;

-- 11. Busy years for Rock Hudson (years with more than 2 movies)
SELECT yr, COUNT(title) AS movie_count
FROM movie JOIN casting ON movie.id = casting.movieid
           JOIN actor ON casting.actorid = actor.id
WHERE name = 'Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2;

-- 12. Lead actor in Julie Andrews movies
SELECT title, name
FROM movie JOIN casting ON movie.id = casting.movieid
           JOIN actor ON casting.actorid = actor.id
WHERE ord = 1
AND movieid IN (
    SELECT movieid FROM casting JOIN actor ON casting.actorid = actor.id
    WHERE name = 'Julie Andrews'
);

-- 13. Actors with at least 15 starring roles (alphabetical)
SELECT name
FROM casting JOIN actor ON actorid = actor.id
WHERE ord = 1
GROUP BY name
HAVING COUNT(movieid) >= 15
ORDER BY name;

-- 14. Films released in 1978 ordered by cast size then title
SELECT title, COUNT(actorid) AS cast_size
FROM casting JOIN movie ON casting.movieid = movie.id
WHERE yr = 1978
GROUP BY title
ORDER BY cast_size DESC, title ASC;

-- 15. People who have worked with Art Garfunkel
SELECT DISTINCT a.name
FROM actor a JOIN casting ca ON a.id = ca.actorid
JOIN casting cb ON ca.movieid = cb.movieid
JOIN actor b ON cb.actorid = b.id
WHERE b.name = 'Art Garfunkel'
AND a.name != 'Art Garfunkel';
