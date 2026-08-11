-- SQLZoo: The JOIN Operation (WC2026)
-- Source: https://www.sqlzoo.net/wiki/The_JOIN_WC2026
-- Tables: goal (game, team, player, gtime)
--         game (id, played, city, team1, team2)
--         team (id, teamname, coach)
--         player (team, playername, pos)
-- Key concept: JOIN, multiple JOINs across tables

-- 1. Leandro Trossard goals
-- Show game, team, player, gtime for all goals by Leandro Trossard
SELECT game, team, player, gtime
FROM goal
WHERE player = 'Leandro Trossard';

-- 2. Team names
-- Show id, teamname and coach for team with code 'BEL'
SELECT id, teamname, coach
FROM team
WHERE id = 'BEL';

-- 3. JOIN - Early goals
-- Show player, gtime and teamname for every goal scored in under 8 minutes
SELECT player, gtime, teamname
FROM goal JOIN team ON goal.team = team.id
WHERE gtime < 8;

-- 4. Coach Sébastien
-- Show player, teamname and coach for every goal scored by a team
-- with coach named 'Sébastien'
SELECT player, teamname, coach
FROM goal JOIN team ON goal.team = team.id
WHERE coach LIKE 'Sébastien%';

-- 5. Where's Harry?
-- For each goal by Harry Edward Kane show the player, game id and city
SELECT player, id, city
FROM goal JOIN game ON goal.game = game.id
WHERE player = 'Harry Edward Kane';

-- 6. Games in Vancouver
-- List player and team (short code) for every goal scored in Vancouver
SELECT player, team
FROM goal JOIN game ON goal.game = game.id
WHERE city = 'Vancouver';

-- 7. Goal Scorer
-- List player and teamname for every goal scored in Vancouver
-- Requires joining 3 tables
SELECT player, teamname
FROM goal JOIN game ON goal.game = game.id
          JOIN team ON goal.team = team.id
WHERE city = 'Vancouver';

-- 8. Teams Playing on July 1st
-- For each team playing on 2026-07-01, show the city and teamname
SELECT game.city, team.teamname
FROM game
JOIN team ON team.id = game.team1 OR team.id = game.team2
WHERE game.played = '2026-07-01';

-- 9. Every goal on one day
-- For every goal scored on 2026-07-02 show teamname and player
SELECT team.teamname, goal.player
FROM game
JOIN goal ON goal.game = game.id
JOIN team ON goal.team = team.id
WHERE game.played = '2026-07-02';

-- 10. Mexico City scorer positions
-- For every goal scored in Mexico City show date played, player and position
SELECT played, player, pos
FROM goal JOIN game   ON goal.game = game.id
          JOIN player ON goal.player = player.playername
WHERE city = 'Mexico City';

-- 11. Defenders score
-- For each goal scored by a defender, show the player and their teamname
SELECT player, teamname
FROM goal JOIN player ON goal.player = player.playername
          JOIN team   ON player.team = team.id
WHERE pos = 'DEF';

-- 12. Extra time goals
-- For each goal scored in extra time (gtime BETWEEN 91 AND 120)
-- show player, position, teamname and city
SELECT player, pos, teamname, city
FROM goal JOIN player ON goal.player = player.playername
          JOIN game   ON goal.game = game.id
          JOIN team   ON player.team = team.id
WHERE gtime BETWEEN 91 AND 120;
