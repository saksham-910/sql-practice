-- SQLZoo: SELECT from WORLD Tutorial
-- Source: https://www.sqlzoo.net/wiki/SELECT_from_WORLD_Tutorial
-- Table: world (name, continent, area, population, gdp)

-- 1. Introduction
-- Show the name, continent and population of all countries
SELECT name, continent, population
FROM world;

-- 2. Large Countries
-- Show the name for countries with population of at least 200 million
SELECT name
FROM world
WHERE population > 200000000;

-- 3. Per Capita GDP
-- Show name and per capita GDP for countries with population over 200 million
SELECT name, gdp/population
FROM world
WHERE population > 200000000;

-- 4. South America In Millions
-- Show name and population in millions for South American countries
SELECT name, population/1000000
FROM world
WHERE continent = 'South America';

-- 5. France, Germany, Italy
-- Show name and population for France, Germany, Italy
SELECT name, population
FROM world
WHERE name IN ('France', 'Germany', 'Italy');

-- 6. United
-- Show countries with 'United' in the name
SELECT name
FROM world
WHERE name LIKE '%United%';

-- 7. Two Ways to be Big
-- Show countries with area > 3 million OR population > 250 million
SELECT name, population, area
FROM world
WHERE area > 3000000
OR population > 250000000;

-- 8. One or the Other (but not both) - XOR
-- Show countries big by area OR big by population but NOT both
SELECT name, population, area
FROM world
WHERE (population > 250000000 OR area > 3000000)
AND NOT (population > 250000000 AND area > 3000000);

-- 9. Rounding
-- Show name, population in millions and GDP in billions for South America
-- Rounded to 2 decimal places
SELECT name,
       ROUND(population/1000000.0, 2),
       ROUND(gdp/1000000000.0, 2)
FROM world
WHERE continent = 'South America';

-- 10. Trillion Dollar Economies
-- Show name and per-capita GDP for countries with GDP >= 1 trillion
-- Rounded to nearest 1000
SELECT name, ROUND(gdp/population, -3)
FROM world
WHERE gdp > 1000000000000;

-- 11. Name and Capital Have the Same Length
-- Show name and capital where both have the same number of characters
SELECT name, capital
FROM world
WHERE LENGTH(name) = LENGTH(capital);

-- 12. Matching Name and Capital
-- Show name and capital where first letters match but are not the same word
SELECT name, capital
FROM world
WHERE LEFT(name, 1) = LEFT(capital, 1)
AND name <> capital;

-- 13. All the Vowels
-- Find country with all vowels (a,e,i,o,u) and no spaces in its name
SELECT name
FROM world
WHERE name LIKE '%a%'
AND name LIKE '%e%'
AND name LIKE '%i%'
AND name LIKE '%o%'
AND name LIKE '%u%'
AND name NOT LIKE '% %';
