-- SQL Practice: Anime Database
-- Custom questions and answers for practice
-- Schema:
--   anime (id, title, genre, episodes, status, rating, studio, release_year)
--   character (id, anime_id, name, role, power_level)
--   user (id, username, country, join_date, premium)
--   watchlist (user_id, anime_id, status, progress_episodes, added_date)
--   review (id, user_id, anime_id, rating, review_date)
--   voice_actor (id, name, country, debut_year)
--   character_voice (character_id, voice_actor_id, language)
--   studio (id, name, country, founded_year)

-- ============================================================
-- SECTION 1: Basic SELECT and WHERE
-- ============================================================

-- Q1. Show all anime with rating above 9.0
SELECT title, genre, rating FROM anime
WHERE rating > 9.0
ORDER BY rating DESC;

-- Q2. Show all currently airing anime
SELECT title, studio, release_year FROM anime
WHERE status = 'Airing'
ORDER BY release_year DESC;

-- Q3. Show all main characters (role = 'Main') with power level above 9000
SELECT name, power_level FROM character
WHERE role = 'Main'
AND power_level > 9000
ORDER BY power_level DESC;

-- Q4. Show all anime from the genre 'Shounen'
SELECT title, episodes, rating FROM anime
WHERE genre = 'Shounen'
ORDER BY rating DESC;

-- Q5. Show users who joined after 2022
SELECT username, country, join_date FROM user
WHERE join_date > '2022-12-31'
ORDER BY join_date ASC;

-- ============================================================
-- SECTION 2: Aggregation (SUM, COUNT, AVG, GROUP BY, HAVING)
-- ============================================================

-- Q6. How many anime are there in each genre?
SELECT genre, COUNT(id) AS anime_count
FROM anime
GROUP BY genre
ORDER BY anime_count DESC;

-- Q7. What is the average rating for each studio?
SELECT studio, ROUND(AVG(rating), 2) AS avg_rating
FROM anime
GROUP BY studio
ORDER BY avg_rating DESC;

-- Q8. How many users are watching, completed or dropped each anime?
SELECT anime.title, watchlist.status, COUNT(watchlist.user_id) AS user_count
FROM anime
JOIN watchlist ON anime.id = watchlist.anime_id
GROUP BY anime.title, watchlist.status
ORDER BY anime.title, user_count DESC;

-- Q9. Which studios have produced more than 10 anime?
SELECT studio, COUNT(id) AS anime_count
FROM anime
GROUP BY studio
HAVING COUNT(id) > 10
ORDER BY anime_count DESC;

-- Q10. What is the average power level of characters in each anime?
SELECT anime.title, ROUND(AVG(character.power_level), 0) AS avg_power
FROM anime
JOIN character ON anime.id = character.anime_id
GROUP BY anime.title
ORDER BY avg_power DESC;

-- ============================================================
-- SECTION 3: JOIN
-- ============================================================

-- Q11. Show each character with their anime title and role
SELECT character.name, anime.title, character.role, character.power_level
FROM character
JOIN anime ON character.anime_id = anime.id
ORDER BY anime.title, character.role;

-- Q12. Show all anime on a user's watchlist with their progress
SELECT user.username, anime.title, watchlist.status, 
       watchlist.progress_episodes, anime.episodes
FROM watchlist
JOIN user ON watchlist.user_id = user.id
JOIN anime ON watchlist.anime_id = anime.id
WHERE user.username = 'saksham_910'
ORDER BY watchlist.added_date DESC;

-- Q13. Show voice actors and the characters they voice in English dub
SELECT voice_actor.name AS voice_actor, character.name AS character,
       anime.title AS anime
FROM voice_actor
JOIN character_voice ON voice_actor.id = character_voice.voice_actor_id
JOIN character ON character_voice.character_id = character.id
JOIN anime ON character.anime_id = anime.id
WHERE character_voice.language = 'English'
ORDER BY voice_actor.name;

-- Q14. Show all anime reviewed by users from Japan
SELECT DISTINCT anime.title, anime.rating
FROM anime
JOIN review ON anime.id = review.anime_id
JOIN user ON review.user_id = user.id
WHERE user.country = 'Japan'
ORDER BY anime.rating DESC;

-- Q15. Show the highest rated anime for each genre
SELECT genre, title, rating
FROM anime a
WHERE rating = (
    SELECT MAX(rating) FROM anime b
    WHERE b.genre = a.genre
)
ORDER BY rating DESC;

-- ============================================================
-- SECTION 4: Subqueries
-- ============================================================

-- Q16. Show anime with above average number of episodes
SELECT title, episodes FROM anime
WHERE episodes > (SELECT AVG(episodes) FROM anime)
ORDER BY episodes DESC;

-- Q17. Show users who have never written a review
SELECT username FROM user
WHERE id NOT IN (
    SELECT DISTINCT user_id FROM review
);

-- Q18. Show the most watched anime (most users have it on their watchlist)
SELECT anime.title, COUNT(watchlist.user_id) AS watchlist_count
FROM anime
JOIN watchlist ON anime.id = watchlist.anime_id
GROUP BY anime.title
ORDER BY watchlist_count DESC
LIMIT 1;

-- Q19. Show anime from the same studio as 'Attack on Titan'
SELECT title, genre, rating FROM anime
WHERE studio = (
    SELECT studio FROM anime WHERE title = 'Attack on Titan'
)
AND title != 'Attack on Titan'
ORDER BY rating DESC;

-- Q20. Show voice actors who have dubbed more than 5 characters
SELECT voice_actor.name, COUNT(character_voice.character_id) AS characters_voiced
FROM voice_actor
JOIN character_voice ON voice_actor.id = character_voice.voice_actor_id
GROUP BY voice_actor.name
HAVING COUNT(character_voice.character_id) > 5
ORDER BY characters_voiced DESC;
