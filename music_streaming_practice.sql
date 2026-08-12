-- SQL Practice: Music Streaming Database
-- Custom questions and answers for practice
-- Schema:
--   artist (id, name, country, genre)
--   album (id, title, artist_id, release_year)
--   song (id, title, album_id, duration_secs, streams)
--   playlist (id, name, user_id, created_date)
--   playlist_song (playlist_id, song_id)
--   user (id, username, country, premium)

-- ============================================================
-- SECTION 1: Basic SELECT and WHERE
-- ============================================================

-- Q1. Show all artists from the United States
SELECT * FROM artist
WHERE country = 'United States';

-- Q2. Show the title and release year of all albums released after 2015
SELECT title, release_year FROM album
WHERE release_year > 2015;

-- Q3. Show songs with more than 100 million streams
SELECT title, streams FROM song
WHERE streams > 100000000;

-- Q4. Show all premium users
SELECT username FROM user
WHERE premium = 1;

-- Q5. Show songs whose title contains the word 'love' (case insensitive)
SELECT title FROM song
WHERE title LIKE '%love%';

-- ============================================================
-- SECTION 2: Aggregation (SUM, COUNT, AVG, GROUP BY, HAVING)
-- ============================================================

-- Q6. How many artists are there from each country?
SELECT country, COUNT(id) AS artist_count
FROM artist
GROUP BY country
ORDER BY artist_count DESC;

-- Q7. What is the total number of streams for each genre?
SELECT artist.genre, SUM(song.streams) AS total_streams
FROM song
JOIN album ON song.album_id = album.id
JOIN artist ON album.artist_id = artist.id
GROUP BY artist.genre
ORDER BY total_streams DESC;

-- Q8. What is the average song duration for each album?
SELECT album.title, ROUND(AVG(song.duration_secs), 0) AS avg_duration_secs
FROM song
JOIN album ON song.album_id = album.id
GROUP BY album.title;

-- Q9. Which genres have more than 10 artists?
SELECT genre, COUNT(id) AS artist_count
FROM artist
GROUP BY genre
HAVING COUNT(id) > 10;

-- Q10. How many songs does each album have?
SELECT album.title, COUNT(song.id) AS song_count
FROM album
JOIN song ON song.album_id = album.id
GROUP BY album.title
ORDER BY song_count DESC;

-- ============================================================
-- SECTION 3: JOIN
-- ============================================================

-- Q11. Show each song title with its album title and artist name
SELECT song.title AS song, album.title AS album, artist.name AS artist
FROM song
JOIN album ON song.album_id = album.id
JOIN artist ON album.artist_id = artist.id;

-- Q12. Show all songs in playlists created in 2024
SELECT song.title, playlist.name AS playlist
FROM song
JOIN playlist_song ON song.id = playlist_song.song_id
JOIN playlist ON playlist_song.playlist_id = playlist.id
WHERE YEAR(playlist.created_date) = 2024;

-- Q13. Show all artists who have released an album after 2020
SELECT DISTINCT artist.name, album.release_year
FROM artist
JOIN album ON artist.id = album.artist_id
WHERE album.release_year > 2020
ORDER BY album.release_year DESC;

-- Q14. Show the most streamed song for each genre
SELECT artist.genre, song.title, song.streams
FROM song
JOIN album ON song.album_id = album.id
JOIN artist ON album.artist_id = artist.id
WHERE song.streams = (
    SELECT MAX(s2.streams)
    FROM song s2
    JOIN album a2 ON s2.album_id = a2.id
    JOIN artist ar2 ON a2.artist_id = ar2.id
    WHERE ar2.genre = artist.genre
);

-- Q15. List all users who have 'chill' in any of their playlist names
SELECT DISTINCT user.username
FROM user
JOIN playlist ON user.id = playlist.user_id
WHERE playlist.name LIKE '%chill%';

-- ============================================================
-- SECTION 4: Subqueries
-- ============================================================

-- Q16. Show artists from the same country as 'Bad Bunny'
SELECT name FROM artist
WHERE country = (
    SELECT country FROM artist WHERE name = 'Bad Bunny'
)
AND name != 'Bad Bunny';

-- Q17. Show songs with streams above the average
SELECT title, streams FROM song
WHERE streams > (SELECT AVG(streams) FROM song)
ORDER BY streams DESC;

-- Q18. Show albums that have more songs than the average album
SELECT album.title, COUNT(song.id) AS song_count
FROM album
JOIN song ON song.album_id = album.id
GROUP BY album.title
HAVING COUNT(song.id) > (
    SELECT AVG(song_count) FROM (
        SELECT COUNT(id) AS song_count
        FROM song
        GROUP BY album_id
    ) AS counts
);

-- Q19. Find the artist with the highest total streams across all their songs
SELECT artist.name, SUM(song.streams) AS total_streams
FROM artist
JOIN album ON artist.id = album.artist_id
JOIN song ON album.id = song.album_id
GROUP BY artist.name
ORDER BY total_streams DESC
LIMIT 1;

-- Q20. Show users who have never created a playlist
SELECT username FROM user
WHERE id NOT IN (
    SELECT DISTINCT user_id FROM playlist
);
