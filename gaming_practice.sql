-- SQL Practice: Gaming Database
-- Custom questions and answers for practice
-- Schema:
--   player (id, username, country, rank, level, join_date)
--   game (id, title, genre, developer, release_year, platform)
--   match (id, game_id, played_date, mode, map)
--   match_player (match_id, player_id, kills, deaths, assists, result)
--   achievement (id, game_id, name, difficulty, points)
--   player_achievement (player_id, achievement_id, unlocked_date)
--   team (id, name, region, founded_year)
--   team_player (team_id, player_id, role, joined_date)

-- ============================================================
-- SECTION 1: Basic SELECT and WHERE
-- ============================================================

-- Q1. Show all players from India
SELECT * FROM player
WHERE country = 'India';

-- Q2. Show all games released after 2020 on PC platform
SELECT title, release_year FROM game
WHERE release_year > 2020
AND platform = 'PC'
ORDER BY release_year DESC;

-- Q3. Show all players above level 50
SELECT username, level, rank FROM player
WHERE level > 50
ORDER BY level DESC;

-- Q4. Show all battle royale games
SELECT title, developer FROM game
WHERE genre = 'Battle Royale';

-- Q5. Show players who joined in 2024
SELECT username, join_date FROM player
WHERE join_date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY join_date ASC;

-- ============================================================
-- SECTION 2: Aggregation (SUM, COUNT, AVG, GROUP BY, HAVING)
-- ============================================================

-- Q6. How many players are there from each country?
SELECT country, COUNT(id) AS player_count
FROM player
GROUP BY country
ORDER BY player_count DESC;

-- Q7. What is the average kills per match for each player?
SELECT player.username, ROUND(AVG(match_player.kills), 2) AS avg_kills
FROM player
JOIN match_player ON player.id = match_player.player_id
GROUP BY player.username
ORDER BY avg_kills DESC;

-- Q8. How many achievements does each game have by difficulty?
SELECT game.title, achievement.difficulty, COUNT(achievement.id) AS achievement_count
FROM game
JOIN achievement ON game.id = achievement.game_id
GROUP BY game.title, achievement.difficulty
ORDER BY game.title, achievement.difficulty;

-- Q9. Which players have a kill/death ratio greater than 2?
SELECT player.username,
       ROUND(SUM(match_player.kills) / SUM(match_player.deaths), 2) AS kd_ratio
FROM player
JOIN match_player ON player.id = match_player.player_id
GROUP BY player.username
HAVING SUM(match_player.deaths) > 0
AND SUM(match_player.kills) / SUM(match_player.deaths) > 2
ORDER BY kd_ratio DESC;

-- Q10. What is the total achievement points unlocked by each player?
SELECT player.username, SUM(achievement.points) AS total_points
FROM player
JOIN player_achievement ON player.id = player_achievement.player_id
JOIN achievement ON player_achievement.achievement_id = achievement.id
GROUP BY player.username
ORDER BY total_points DESC;

-- ============================================================
-- SECTION 3: JOIN
-- ============================================================

-- Q11. Show each match with the game title, date and map
SELECT game.title, match.played_date, match.map, match.mode
FROM match
JOIN game ON match.game_id = game.id
ORDER BY match.played_date DESC;

-- Q12. Show all players and their team name and role
SELECT player.username, team.name AS team, team_player.role
FROM player
JOIN team_player ON player.id = team_player.player_id
JOIN team ON team_player.team_id = team.id
ORDER BY team.name;

-- Q13. Show every achievement unlocked by players from India
SELECT player.username, achievement.name, achievement.points, player_achievement.unlocked_date
FROM player
JOIN player_achievement ON player.id = player_achievement.player_id
JOIN achievement ON player_achievement.achievement_id = achievement.id
WHERE player.country = 'India'
ORDER BY player_achievement.unlocked_date DESC;

-- Q14. Show match results for all players in team 'Fnatic'
SELECT player.username, match.played_date, game.title, match_player.kills,
       match_player.deaths, match_player.result
FROM player
JOIN team_player ON player.id = team_player.player_id
JOIN team ON team_player.team_id = team.id
JOIN match_player ON player.id = match_player.player_id
JOIN match ON match_player.match_id = match.id
JOIN game ON match.game_id = game.id
WHERE team.name = 'Fnatic'
ORDER BY match.played_date DESC;

-- Q15. Show all players who have unlocked a legendary achievement
SELECT DISTINCT player.username, achievement.name, achievement.difficulty
FROM player
JOIN player_achievement ON player.id = player_achievement.player_id
JOIN achievement ON player_achievement.achievement_id = achievement.id
WHERE achievement.difficulty = 'Legendary';

-- ============================================================
-- SECTION 4: Subqueries
-- ============================================================

-- Q16. Show players with more kills than the average kills per match
SELECT player.username, ROUND(AVG(match_player.kills), 2) AS avg_kills
FROM player
JOIN match_player ON player.id = match_player.player_id
GROUP BY player.username
HAVING AVG(match_player.kills) > (
    SELECT AVG(kills) FROM match_player
)
ORDER BY avg_kills DESC;

-- Q17. Show players who have never played a match
SELECT username FROM player
WHERE id NOT IN (
    SELECT DISTINCT player_id FROM match_player
);

-- Q18. Show the most played game (by number of matches)
SELECT game.title, COUNT(match.id) AS match_count
FROM game
JOIN match ON game.id = match.game_id
GROUP BY game.title
ORDER BY match_count DESC
LIMIT 1;

-- Q19. Show players from the same country as the highest ranked player
SELECT username, country, rank FROM player
WHERE country = (
    SELECT country FROM player
    ORDER BY rank ASC
    LIMIT 1
)
ORDER BY rank ASC;

-- Q20. Show teams that have more than 5 players
SELECT team.name, COUNT(team_player.player_id) AS player_count
FROM team
JOIN team_player ON team.id = team_player.team_id
GROUP BY team.name
HAVING COUNT(team_player.player_id) > 5
ORDER BY player_count DESC;
