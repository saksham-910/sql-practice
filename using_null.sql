-- SQLZoo: Using NULL
-- Source: https://www.sqlzoo.net/wiki/Using_Null
-- Tables: teacher (id, dept, name, phone, mobile)
--         dept (id, name)
-- Key concepts: IS NULL, IS NOT NULL, LEFT JOIN, RIGHT JOIN,
--               COALESCE, COUNT with NULLs, CASE WHEN

-- 1. Finding NULL
-- List teachers who have no department
SELECT name
FROM teacher
WHERE dept IS NULL;

-- 2. INNER JOIN (misses teachers with no dept and depts with no teacher)
SELECT teacher.name, dept.name
FROM teacher INNER JOIN dept
ON teacher.dept = dept.id;

-- 3. LEFT JOIN - include all teachers even if no department
SELECT teacher.name, dept.name
FROM teacher
LEFT JOIN dept ON teacher.dept = dept.id;

-- 4. RIGHT JOIN - include all departments even if no teachers
SELECT teacher.name, dept.name
FROM teacher
RIGHT JOIN dept ON teacher.dept = dept.id;

-- 5. COALESCE - show mobile number, use default if NULL
SELECT name, COALESCE(mobile, '07986 444 2266')
FROM teacher;

-- 6. COALESCE with LEFT JOIN - show dept name, use 'None' if NULL
SELECT teacher.name, COALESCE(dept.name, 'None')
FROM teacher LEFT JOIN dept
ON teacher.dept = dept.id;

-- 7. COUNT non-NULL values
-- COUNT(name) counts all teachers, COUNT(mobile) counts only non-NULL mobiles
SELECT COUNT(teacher.name), COUNT(mobile)
FROM teacher;

-- 8. Number of staff per department using RIGHT JOIN
-- RIGHT JOIN ensures Engineering shows even if no teachers
SELECT dept.name, COUNT(teacher.name)
FROM teacher RIGHT JOIN dept
ON teacher.dept = dept.id
GROUP BY dept.name;

-- 9. CASE WHEN - label teachers as Sci or Art based on dept
SELECT name, CASE WHEN dept IN (1, 2) THEN 'Sci'
                  ELSE 'Art' END AS subject_area
FROM teacher;

-- 10. CASE with multiple conditions
SELECT name, CASE WHEN dept IN (1, 2) THEN 'Sci'
                  WHEN dept = 3 THEN 'Art'
                  ELSE 'None' END AS subject_area
FROM teacher;
