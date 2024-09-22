--In this case study I'm using two tables exported from 'mode.com' in 'MySQL Workbench'
-- 1. 'college_football_players'
-- 2. 'college_football_teams'

-- WAQ to return all the records from both tables
SELECT * FROM college_football_players;
SELECT * from college_football_teams;


--Using JOINS 
1.
SELECT p.player_name, p.school_name, t.conference 
FROM college_football_players AS p
INNER join college_football_teams AS t
ON p.school_name = t.school_name ;

2
SELECT t.conference, COUNT(p.player_name) AS "total no of players"
FROM college_football_players AS p
INNER join college_football_teams AS t
ON p.school_name = t.school_name
GROUP BY t.conference 
ORDER BY "total no of players" DESC ;

3
SELECT t. division, avg(p.height) AS avg_height_of_player
FROM college_football_players AS p
INNER JOIN college_football_teams AS t
ON p.school_name = t.school_name
GROUP BY t.division;

4
SELECT t.conference, avg(p.weight) AS avg_weight_of_player
FROM college_football_players AS p
INNER join college_football_teams AS t
ON p.school_name = t.school_name
GROUP BY t.conference
HAVING avg(p.weight) > 210
ORDER BY avg(p.weight) DESC;


5
SELECT t.conference, SUM(p.weight)/sum(p.height) AS BMI
FROM college_football_players AS p
INNER join college_football_teams AS t
ON p.school_name = t.school_name
GROUP BY t.conference
ORDER BY BMI DESC;

-- Using CASE statement for table 'college_football_players'
1.
SELECT player_name, year, 
      CASE WHEN year in ('JR','SR') THEN player_name
      ELSE 'none' END AS jr_sr_player
FROM college_football_players;

2.
SELECT player_name, weight,
      CASE 
          WHEN weight > 250  THEN 'over 250'
          WHEN weight > 200  THEN '210-250'
          WHEN weight > 175  THEN '176-200'
      ELSE '175 or below' END AS weight_info
FROM college_football_players;

3.
SELECT 
      CASE WHEN weight > 250 THEN 'over 250'
      WHEN weight > 200 THEN '201 - 250'
      WHEN weight > 175 THEN '176 - 200'
      ELSE '175 or below' END AS player_weight_group,
      COUNT(1) as count
FROM college_football_players
GROUP BY 1
ORDER BY 2 DESC;

4.
SELECT 
      CASE WHEN year = 'FR' THEN 'FR'
      WHEN year = 'SO' THEN 'SO'
      WHEN year = 'JR' THEN 'JR'
      WHEN year = 'SR' THEN 'SR'
      ELSE 'No year data' END AS year_Group,
      COUNT(1) AS count
FROM college_football_players
GROUP BY 1
ORDER BY 2 DESC;

5.
SELECT *
FROM college_football_players ;

SELECT player_name, state,
      CASE WHEN state = 'CA' THEN 'YES'
            ELSE 'NONE' END AS from_California
FROM college_football_players
ORDER BY 3 DESC;

6.
SELECT 
      CASE WHEN state = 'CA' THEN 'YES'
            ELSE 'NONE' END AS from_California,
      count (1) AS count
FROM college_football_players
GROUP BY 1
ORDER BY 2;

7.
SELECT player_name, state,
      CASE WHEN state LIKE 'C%' THEN 'YES'
            ELSE 'NONE' END AS from_California
FROM college_football_players
ORDER BY 3 desc;

8.
SELECT 
      CASE WHEN school_name < 'n' THEN 'A-M'
      WHEN school_name >= 'n' THEN 'N-Z'
      END AS school_group,
      COUNT(1) AS Total_players
  FROM college_football_players
  GROUP BY 1;

9.
SELECT
      CASE WHEN state IN ('CA','OR','WA') THEN 'Category_A'
           WHEN state = 'TX'  THEN 'Category_B'
           ELSE 'Others' END AS categories,
      COUNT(1) AS players
FROM college_football_players
WHERE weight>300
GROUP BY 1
ORDER BY 1 ASC;



