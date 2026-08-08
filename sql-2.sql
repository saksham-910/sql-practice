-- SQLZoo: SELECT from Nobel Tutorial
-- Source: https://www.sqlzoo.net/wiki/SELECT_from_Nobel_Tutorial
-- Table: nobel (yr, subject, winner)

-- 1. Winners from 1950
-- Show Nobel prizes for 1950
SELECT yr, subject, winner
FROM nobel
WHERE yr = 1950;

-- 2. 1962 Literature
-- Show who won the 1962 prize for literature
SELECT winner
FROM nobel
WHERE yr = 1962
AND subject = 'Literature';

-- 3. Albert Einstein
-- Show the year and subject that won Albert Einstein his prize
SELECT yr, subject
FROM nobel
WHERE winner = 'Albert Einstein';

-- 4. Recent Peace Prizes
-- Give the name of Peace winners since 2000, including 2000
SELECT winner
FROM nobel
WHERE subject = 'Peace'
AND yr >= 2000;

-- 5. Literature in the 1980s
-- Show all details of literature prize winners from 1980 to 1989 inclusive
SELECT yr, subject, winner
FROM nobel
WHERE subject = 'Literature'
AND yr BETWEEN 1980 AND 1989;

-- 6. Only Presidents
-- Show all details of presidential winners:
-- Theodore Roosevelt, Thomas Woodrow Wilson, Jimmy Carter, Barack Obama
SELECT *
FROM nobel
WHERE winner IN ('Theodore Roosevelt',
                 'Thomas Woodrow Wilson',
                 'Jimmy Carter',
                 'Barack Obama');

-- 7. John
-- Show winners with first name John
SELECT winner
FROM nobel
WHERE winner LIKE 'John %';

-- 8. Chemistry and Physics from different years
-- Physics winners for 1980 together with Chemistry winners for 1984
SELECT *
FROM nobel
WHERE (subject = 'Physics' AND yr = 1980)
OR (subject = 'Chemistry' AND yr = 1984);

-- 9. Exclude Chemists and Medics
-- Show year, subject, name of winners for 1980 excluding chemistry and medicine
SELECT *
FROM nobel
WHERE yr = 1980
AND subject NOT IN ('Chemistry', 'Medicine');

-- 10. Early Medicine, Late Literature
-- Medicine before 1910 OR Literature after 2004 (including 2004)
SELECT *
FROM nobel
WHERE (subject = 'Medicine' AND yr < 1910)
OR (subject = 'Literature' AND yr >= 2004);

-- 11. Umlaut
-- Find all details of the prize won by PETER GRÜNBERG
SELECT *
FROM nobel
WHERE winner = 'Peter Grünberg';

-- 12. Apostrophe
-- Find all details of the prize won by EUGENE O'NEILL
-- Use two single quotes to escape apostrophe
SELECT *
FROM nobel
WHERE winner = 'Eugene O''Neill';

-- 13. Knights of the Realm
-- List winners starting with Sir, most recent first, then by name
SELECT winner, yr, subject
FROM nobel
WHERE winner LIKE 'Sir%'
ORDER BY yr DESC, winner;

-- 14. Chemistry and Physics Last
-- Show 1984 winners ordered by subject and name, but Chemistry and Physics last
SELECT winner, subject
FROM nobel
WHERE yr = 1984
ORDER BY subject IN ('Physics', 'Chemistry'), subject, winner;
