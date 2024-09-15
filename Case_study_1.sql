-- In this case study, we use "tutorial" dataset and "sat_scores" table from mode.com


-- Extracting the data from sat_scores table
SELECT * FROM tutorial.sat_scores;

--Aggregate Functions on different columns
SELECT MIN(sat_verbal) FROM tutorial.sat_scores ;
SELECT MAX(sat_math) FROM tutorial.sat_scores ;
SELECT AVG(sat_writing) FROM tutorial.sat_scores ;
SELECT SUM(sat_verbal) FROM tutorial.sat_scores ;
SELECT COUNT(student_id) FROM tutorial.sat_scores ;

--Selecting sat_writing, sat_verbal, sat_math column from the sat_scores table
SELECT sat_writing, sat_verbal, sat_math FROM tutorial.sat_scores ;

--Get the top 2 rows of the table
SELECT TOP 2 * FROM tutorial.sat_scores;

--Get the last 3 rows of the table
SELECT LAST 3 * FROM tutorial.sat_scores;


-- WAQ to add column - avg_sat_writing. Each row in this column should include average marks in the writing section of the student per school.
SELECT *, AVG(sat_writing)
OVER (PARTITION BY school) AS avg_sat_writing
FROM tutorial.sat_scores;

-- WAQ to add column - avg_sat_writing. Each row in this column should include average marks in the writing section of the student per school and order by school.
SELECT *, AVG(sat_writing)
OVER (PARTITION BY school ORDER BY school) AS avg_sat_writing
FROM tutorial.sat_scores;


-- WAQ wrt abobve Query only -> add an additional col - count_per_school.Each row of this column should include the number of students per school.
SELECT *, 
AVG(sat_writing) OVER(PARTITION BY school ORDER BY school) AS avg_sat_writing,
COUNT(student_id) OVER(PARTITION BY school ORDER BY school) AS count_per_school 
FROM tutorial.sat_scores;



-- WAQ wrt above Query only -> add two additional col - max_per_teacher and min_per_teacher. Each of these columns must include maximum and minimum marks in sat_math per teacher respectively.
SELECT *, 
AVG(sat_writing) OVER(PARTITION BY school ORDER BY school) AS avg_sat_writing,
COUNT(student_id) OVER(PARTITION BY school ORDER BY school) AS count_per_school,
MAX(sat_math) OVER(PARTITION BY teacher ORDER BY school) AS max_per_teacher,
MIN(sat_math) OVER(PARTITION BY teacher ORDER BY school) AS min_per_teacher
FROM tutorial.sat_scores;


-- WAQ to add two columns: cum_hrs_studied and total_hrs_studied.
-- Each row in cum_hrs_studied should display the cumulative sum of hours studied per school.
-- Each row in total_hrs_studied should display the total hours studied per school.        
-- order the data in ASC order of student_id.
SELECT school, student_id, hrs_studied,
SUM(hrs_studied) OVER(PARTITION BY school ORDER BY student_id) AS cum_hrs_studied,
SUM(hrs_studied) OVER(PARTITION BY school ORDER BY student_id ROWS BETWEEN unbounded preceding AND unbounded following) AS total_hrs_studied
FROM tutorial.sat_scores;


-- WAQ to add column sub_hrs_studied and total_hrs_studied.
-- Each row in the sub_hrs_studied should display the sum of hrs_studied for the row above,
-- a row below and current row per school.
-- Order the data in ASC order of student_id.
SELECT school, student_id, hrs_studied,
SUM(hrs_studied) OVER(PARTITION BY school ORDER BY student_id ROWS BETWEEN unbounded preceding AND unbounded following) AS total_hrs_studied,
SUM(hrs_studied) OVER(PARTITION BY school ORDER BY student_id ROWS BETWEEN 1 preceding
AND 1 following) AS sub_hrs_studied
FROM tutorial.sat_scores
ORDER BY student_id;


-- WAQ to RANK the students per school based on scores in sat_verbal.
-- Use both RANK and DENSE_RANK function. Students with the highest marks should get RANK 1.
-- Observe if incase you see any difference in the ranking provided by both functions.
SELECT school, teacher, sat_verbal,
RANK() OVER(PARTITION BY school ORDER BY sat_verbal DESC) AS score_verbal_RANK,
DENSE_RANK() OVER(PARTITION BY school ORDER BY sat_verbal DESC) AS score_verbal_dense_RANK
FROM tutorial.sat_scores;


-- WAQ to RANK the students per school based on scores in sat_writing.
-- Use both RANK and dense_RANK function.       
-- Students with the highest marks should get RANK 1.
SELECT school, teacher, sat_writing,
RANK() OVER(PARTITION BY school ORDER BY sat_writing DESC) AS score_writing_RANK,
DENSE_RANK() OVER(PARTITION BY school ORDER BY sat_writing DESC) AS score_writing_dense_RANK
FROM tutorial.sat_scores;


 -- WAQ to RANK the students per teacher depending on the highest number of hrs_studied.
SELECT school, teacher, hrs_studied,
RANK() OVER(PARTITION BY teacher ORDER BY hrs_studied DESC) AS hrs_studied_RANK
FROM tutorial.sat_scores;

SELECT school, teacher, hrs_studied,
RANK() OVER(PARTITION BY teacher ORDER BY hrs_studied DESC) AS hrs_studied_RANK,
ROW_NUMBER() OVER(PARTITION BY teacher ORDER BY hrs_studied DESC) AS hrs_studied_ROW_NUMBER
FROM tutorial.sat_scores;


-- WAQ to display the top 3 ranker students per teacher depending on the highest number of hrs_studied.

--1) using CTE
WITH cte AS (
SELECT teacher, student_id, hrs_studied,
ROW_NUMBER() OVER (PARTITION BY teacher ORDER BY hrs_studied desc) hrs_studied_ROW_NUMBER
FROM tutorial.sat_scores)
SELECT * 
FROM cte 
WHERE hrs_studied_ROW_NUMBER <=3;

--2) using SUBQ
SELECT *
FROM (
      SELECT teacher, student_id, hrs_studied,
      ROW_NUMBER() OVER (PARTITION BY teacher ORDER BY hrs_studied desc) hrs_studied_row_number
      FROM tutorial.sat_scores
      ) subq 
WHERE subq.hrs_studied_ROW_NUMBER <=3;


-- WAQ to find the worst 5 students per school who got the minimum marks in sat_math.
SELECT *
FROM (
      SELECT *,
      RANK() OVER(PARTITION BY school ORDER BY sat_math ) AS sat_math_RANK
      FROM tutorial.sat_scores
      ) subq 
WHERE subq.sat_math_RANK <=5;


-- WAQ to divide the data into quartiles based on marks in sat_verbal.
SELECT *,
NTILE(4) OVER(ORDER BY sat_verbal) AS four_quarters
FROM tutorial.sat_scores;


-- For "Petersville HS" school, WAQ to arrange the students in the ascending order of hrs_studied. 
-- Also add a column to find the difference in hrs_studied from the students above.
-- Exclude the cases where hrs_studied is NULL.
SELECT *, hrs_studied - LAG(hrs_studied) OVER(ORDER BY hrs_studied) AS diff_in_hrs
FROM tutorial.sat_scores
WHERE school = 'Petersville HS' AND hrs_studied IS NOT NULL ;

