-- SQLZoo: SUM and COUNT Tutorial
-- Source: https://www.sqlzoo.net/wiki/SUM_and_COUNT
-- Table: world (name, continent, area, population, gdp)
-- Key concepts: SUM, COUNT, DISTINCT, GROUP BY, HAVING

-- 1. Total world population
SELECT SUM(population)
FROM world;

-- 2. List of continents (each once only)
SELECT DISTINCT continent
FROM world;

-- 3. GDP of Africa
SELECT SUM(gdp)
FROM world
WHERE continent = 'Africa';

-- 4. Count the big countries
-- How many countries have an area of at least 1,000,000
SELECT COUNT(name)
FROM world
WHERE area >= 1000000;

-- 5. Baltic states population
-- Total population of Estonia, Latvia, Lithuania
SELECT SUM(population)
FROM world
WHERE name IN ('Estonia', 'Latvia', 'Lithuania');

-- 6. Counting the countries of each continent
-- For each continent show the continent and number of countries
SELECT continent, COUNT(name)
FROM world
GROUP BY continent;

-- 7. Counting big countries in each continent
-- For each continent, count countries with population >= 10 million
SELECT continent, COUNT(name)
FROM world
WHERE population >= 10000000
GROUP BY continent;

-- 8. Counting big continents
-- List continents with total population of at least 100 million
SELECT continent
FROM world
GROUP BY continent
HAVING SUM(population) >= 100000000;
