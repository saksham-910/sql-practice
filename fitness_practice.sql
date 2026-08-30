-- SQL Practice: Fitness & Gym Database
-- Custom questions and answers for practice
-- Schema:
--   member (id, name, age, gender, city, join_date, membership_type)
--   workout (id, member_id, date, duration_mins, calories_burned, workout_type)
--   exercise (id, name, muscle_group, equipment, difficulty)
--   workout_exercise (workout_id, exercise_id, sets, reps, weight_kg)
--   trainer (id, name, speciality, rating, experience_years)
--   session (id, member_id, trainer_id, date, duration_mins, notes)
--   goal (id, member_id, goal_type, target_value, current_value, deadline)

-- ============================================================
-- SECTION 1: Basic SELECT and WHERE
-- ============================================================

-- Q1. Show all premium members
SELECT name, city, join_date FROM member
WHERE membership_type = 'premium'
ORDER BY join_date;

-- Q2. Show all workouts longer than 60 minutes
SELECT member_id, date, duration_mins, workout_type FROM workout
WHERE duration_mins > 60
ORDER BY duration_mins DESC;

-- Q3. Show all chest exercises
SELECT name, equipment, difficulty FROM exercise
WHERE muscle_group = 'chest'
ORDER BY difficulty;

-- Q4. Show trainers with rating above 4.5
SELECT name, speciality, rating, experience_years FROM trainer
WHERE rating > 4.5
ORDER BY rating DESC;

-- Q5. Show members who joined in 2024
SELECT name, city, membership_type FROM member
WHERE join_date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY join_date;

-- ============================================================
-- SECTION 2: Aggregation
-- ============================================================

-- Q6. How many members are there per membership type?
SELECT membership_type, COUNT(id) AS member_count
FROM member
GROUP BY membership_type
ORDER BY member_count DESC;

-- Q7. What is the average calories burned per workout type?
SELECT workout_type, ROUND(AVG(calories_burned), 0) AS avg_calories
FROM workout
GROUP BY workout_type
ORDER BY avg_calories DESC;

-- Q8. Which members have worked out more than 20 times this year?
SELECT member.name, COUNT(workout.id) AS workout_count
FROM member
JOIN workout ON member.id = workout.member_id
WHERE YEAR(workout.date) = 2025
GROUP BY member.name
HAVING COUNT(workout.id) > 20
ORDER BY workout_count DESC;

-- Q9. What is the total weight lifted per muscle group?
SELECT exercise.muscle_group,
       SUM(workout_exercise.sets * workout_exercise.reps * workout_exercise.weight_kg) AS total_volume_kg
FROM workout_exercise
JOIN exercise ON workout_exercise.exercise_id = exercise.id
GROUP BY exercise.muscle_group
ORDER BY total_volume_kg DESC;

-- Q10. Which trainer has the most sessions?
SELECT trainer.name, COUNT(session.id) AS session_count
FROM trainer
JOIN session ON trainer.id = session.trainer_id
GROUP BY trainer.name
ORDER BY session_count DESC
LIMIT 1;

-- ============================================================
-- SECTION 3: JOIN
-- ============================================================

-- Q11. Show each workout with the member name and workout type
SELECT member.name, workout.date, workout.workout_type,
       workout.duration_mins, workout.calories_burned
FROM workout
JOIN member ON workout.member_id = member.id
ORDER BY workout.date DESC;

-- Q12. Show all exercises done by members from Delhi
SELECT DISTINCT exercise.name, exercise.muscle_group
FROM exercise
JOIN workout_exercise ON exercise.id = workout_exercise.exercise_id
JOIN workout ON workout_exercise.workout_id = workout.id
JOIN member ON workout.member_id = member.id
WHERE member.city = 'Delhi';

-- Q13. Show each session with member name, trainer name and duration
SELECT member.name AS member, trainer.name AS trainer,
       session.date, session.duration_mins
FROM session
JOIN member ON session.member_id = member.id
JOIN trainer ON session.trainer_id = trainer.id
ORDER BY session.date DESC;

-- Q14. Show members who have achieved their fitness goal
SELECT member.name, goal.goal_type, goal.target_value, goal.current_value
FROM goal
JOIN member ON goal.member_id = member.id
WHERE goal.current_value >= goal.target_value;

-- Q15. Show the most used exercise in workouts
SELECT exercise.name, exercise.muscle_group, COUNT(workout_exercise.workout_id) AS times_used
FROM exercise
JOIN workout_exercise ON exercise.id = workout_exercise.exercise_id
GROUP BY exercise.name, exercise.muscle_group
ORDER BY times_used DESC
LIMIT 10;

-- ============================================================
-- SECTION 4: Subqueries
-- ============================================================

-- Q16. Show members who burn more calories than average per workout
SELECT member.name, ROUND(AVG(workout.calories_burned), 0) AS avg_calories
FROM member
JOIN workout ON member.id = workout.member_id
GROUP BY member.name
HAVING AVG(workout.calories_burned) > (SELECT AVG(calories_burned) FROM workout)
ORDER BY avg_calories DESC;

-- Q17. Show members who have never booked a trainer session
SELECT name FROM member
WHERE id NOT IN (
    SELECT DISTINCT member_id FROM session
);

-- Q18. Show the most popular workout type per city
SELECT city, workout_type, count
FROM (
    SELECT member.city, workout.workout_type, COUNT(*) AS count
    FROM workout
    JOIN member ON workout.member_id = member.id
    GROUP BY member.city, workout.workout_type
) AS city_workouts
WHERE count = (
    SELECT MAX(count_inner)
    FROM (
        SELECT member.city AS c, COUNT(*) AS count_inner
        FROM workout JOIN member ON workout.member_id = member.id
        GROUP BY member.city, workout.workout_type
    ) AS inner_cw
    WHERE inner_cw.c = city_workouts.city
);

-- Q19. Show trainers from the same city as the highest rated trainer
SELECT name, speciality, rating FROM trainer
WHERE city = (
    SELECT city FROM trainer
    ORDER BY rating DESC
    LIMIT 1
)
ORDER BY rating DESC;

-- Q20. Show members with more than 3 active goals
SELECT member.name, COUNT(goal.id) AS active_goals
FROM member
JOIN goal ON member.id = goal.member_id
WHERE goal.current_value < goal.target_value
GROUP BY member.name
HAVING COUNT(goal.id) > 3
ORDER BY active_goals DESC;
