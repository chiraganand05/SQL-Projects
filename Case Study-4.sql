--In this case study i'm using exported data 'dc_bikeshare_q1_2012' FROM 'mode.com' in 'MySQL Workbench' 

--Using : OVER Clause, PARTITION BY Clause, ROWS BETWEEN, RANK Function, DENSE_RANK Function, ROW_NUMBER Function, NTILE Function


-- WAQ to return all the records FROM table dc_bikeshare_q1_2012
SELECT * FROM dc_bikeshare_q1_2012;

-- 1.
SELECT start_terminal,duration_seconds,
       avg(duration_seconds) OVER(PARTITION BY start_terminal) AS avg_duration_seconds
FROM dc_bikeshare_q1_2012
where start_time < '2012-01-08'; 

-- 2.
SELECT 
		start_terminal, 
    count(id) OVER(PARTITION BY start_terminal) AS total_ride
FROM dc_bikeshare_q1_2012
where start_time < '2012-01-08';

-- 3.
SELECT start_terminal, duration_seconds, 
       sum(duration_seconds) OVER(PARTITION BY start_terminal ORDER BY start_time ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS total_duration
FROM dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08' ;


--Using RANK function

-- 1.
SELECT start_terminal, duration_seconds, start_time,
       RANK() OVER(PARTITION BY start_terminal ORDER BY start_time) AS rank
FROM dc_bikeshare_q1_2012 ;

-- 2.
SELECT *
FROM (
      SELECT start_terminal, duration_seconds, start_time,
      rank() OVER (PARTITION BY start_terminal ORDER BY duration_seconds DESC) AS rank
      FROM dc_bikeshare_q1_2012
      WHERE start_time<'2012-01-08'
) subq
WHERE subq.rank<=5;

--WAQ to rank all the rides per terminal on asc order of duration taken per ride before '2012-01-08'.
SELECT start_terminal, duration_seconds, start_time,
rank() OVER (PARTITION BY start_terminal ORDER BY start_time) AS rank
FROM dc_bikeshare_q1_2012
WHERE start_time<'2012-01-08';


-- Using DENSE_RANK function

SELECT *
FROM (
      SELECT start_terminal, duration_seconds, start_time,
      dense_rank() OVER (PARTITION BY start_terminal ORDER BY duration_seconds DESC) AS rank
      FROM dc_bikeshare_q1_2012
      WHERE start_time<'2012-01-08'
) subq
WHERE subq.rank<=5;


--Using ROW_NUMBER function

SELECT start_terminal, duration_seconds, start_time,
      row_number() OVER (PARTITION BY start_terminal ORDER BY duration_seconds DESC) AS row_number
FROM dc_bikeshare_q1_2012
WHERE start_time<'2012-01-08'


--Using NTILE function

-- 1. 
SELECT start_terminal, start_time, duration_seconds,
NTILE(4) OVER(ORDER BY duration_seconds DESC) AS percentile
FROM dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08';

-- 2.
SELECT start_terminal, start_time, duration_seconds,
NTILE(4) OVER(PARTITION BY start_terminal ORDER BY duration_seconds DESC) AS percentile
FROM dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08';
