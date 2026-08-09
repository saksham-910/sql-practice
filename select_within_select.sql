-- SQLZoo: SELECT within SELECT Tutorial
-- Source: https://www.sqlzoo.net/wiki/SELECT_within_SELECT_Tutorial
-- Table: world (name, continent, area, population, gdp)
-- Key concept: Subqueries and correlated subqueries

-- 1. Bigger than Russia
-- List countries with population larger than Russia
SELECT name FROM world
WHERE population > (
    SELECT population FROM world
    WHERE name = 'Russia'
);

-- 2. Richer than UK
-- Show countries in Europe with per capita GDP greater than UK
SELECT name FROM world
WHERE continent = 'Europe'
AND gdp/population > (
    SELECT gdp/population FROM world
    WHERE name = 'United Kingdom'
);

-- 3. Neighbours of Argentina and Australia
-- List name and continent of countries in same continent as Argentina or Australia
SELECT name, continent
FROM world
WHERE continent IN (
    SELECT continent FROM world
    WHERE name IN ('Argentina', 'Australia')
)
ORDER BY name;

-- 4. Between Canada and Poland
-- Country with population more than UK but less than Germany
SELECT name, population FROM world
WHERE population BETWEEN
    (SELECT population + 1 FROM world WHERE name = 'United Kingdom')
    AND
    (SELECT population - 1 FROM world WHERE name = 'Germany');

-- 5. Percentages of Germany
-- Show population of each European country as % of Germany's population
SELECT name,
       CONCAT(ROUND(population * 100 / (SELECT population FROM world WHERE name = 'Germany'), 0), '%')
FROM world
WHERE continent = 'Europe';

-- 6. Bigger than every country in Europe
-- Countries with GDP greater than every European country
SELECT name FROM world
WHERE gdp > ALL (
    SELECT gdp FROM world
    WHERE continent = 'Europe'
    AND gdp IS NOT NULL
);

-- 7. Largest in each continent
-- Find largest country by area in each continent
-- Uses correlated subquery with table aliases x and y
SELECT continent, name, area
FROM world x
WHERE area >= ALL (
    SELECT area FROM world y
    WHERE y.continent = x.continent
    AND area > 0
);

-- 8. First country of each continent alphabetically
-- List each continent and the country that comes first alphabetically
SELECT continent, name FROM world x
WHERE x.name <= ALL (
    SELECT name FROM world y
    WHERE x.continent = y.continent
);

-- 9. Small continent countries
-- Find continents where ALL countries have population <= 25 million
-- Show name, continent and population of those countries
SELECT name, continent, population FROM world x
WHERE 25000000 >= ALL (
    SELECT population FROM world y
    WHERE x.continent = y.continent
    AND y.population > 0
);

-- 10. Three times bigger
-- Countries with population more than 3x all their continental neighbours
SELECT name, continent FROM world x
WHERE population > ALL (
    SELECT population * 3 FROM world y
    WHERE y.continent = x.continent
    AND y.name != x.name
);
