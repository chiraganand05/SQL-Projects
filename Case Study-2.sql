-- In this case study, we use "tutorial" database and "oscar_nominees" table from mode.com


-- WRQ to display all the records in the table tutorial.oscar_nominees
SELECT  * FROM  tutorial.oscar_nominees;

-- WAQ to find the distinct values in the ‘year’ column 
SELECT  distinct year FROM  tutorial.oscar_nominees; 

--WAQ to filter the records FROM  year 1999 to year 2006
SELECT  * FROM  tutorial.oscar_nominees WHERE  year between 1999 AND 2006;

--WAQ to filter the records for either year 1991 or 1998
SELECT  * FROM  tutorial.oscar_nominees WHERE  year=1991 or year=1998;
SELECT  * FROM  tutorial.oscar_nominees WHERE  year in(1991, 1998);

--WAQ to return the winner movie name for the year of 1997
SELECT  movie as "winner movie" FROM  tutorial.oscar_nominees WHERE  year=1997 and winner='true';

--WAQ to return the winner in the ‘actor in a leading role’ and ‘actress in a leading role’ category for the year of 1994,1980, and 2008
SELECT  nominee as winner, category 
FROM  tutorial.oscar_nominees 
WHERE  category in ('actor in a leading role', 'actress in a leading role') 
and winner = 'true' 
and year in (1994, 1980, 2008);

--WAQ to return the name of the movie starting FROM  letter ‘a’
SELECT  movie FROM  tutorial.oscar_nominees WHERE  lower(movie) LIKE ('a%');

--WAQ to return the name of movies containing the word ‘the’
SELECT  movie FROM  tutorial.oscar_nominees WHERE  lower(movie) like ('%the%');

--WAQ to return all the records WHERE  the nominee name starts with “c” and ends with “r”
SELECT  * FROM  tutorial.oscar_nominees WHERE  lower(nominee) like ('c%') and lower(nominee) like ('%r');
SELECT  * FROM  tutorial.oscar_nominees WHERE  lower(nominee) like ('c%r');

--WAQ to return all the records WHERE  the movie was released in 2005 and movie name does not start with ‘a’ and ‘c’ and nominee was a winner
SELECT  * FROM  tutorial.oscar_nominees WHERE  year = 2005 and lower(movie) not like ('a%') and lower(movie) not like ('c%') and winner = true;

--Write a query to return all the movies which have won oscars both in the actor and actress category
select distinct movie
from oscar_nominees 
where (winner='true' and category like '%actor%')
and movie in(select movie from oscar_nominees where category like '%actress%' and winner='true');

--WAQ to return the name of nominees who got more nominations than ‘Akim Tamiroff’. Solve this using CTE
WITH nominees AS (
                 SELECT  nominee,
                 COUNT(*) as nomination_count
                 FROM  tutorial.oscar_nominees
                 GROUP BY  1
                 ORDER BY  2 DESC
                 )
SELECT  nominee
FROM  nominees
WHERE  nomination_count > ( SELECT  COUNT(*) FROM  tutorial.oscar_nominees WHERE  nominee IN ('Akim Tamiroff') );


--WAQ to find the nominee name with the highest number of oscar wins. Solve using CTE.
WITH wins AS (
    SELECT  nominee,
      COUNT(*) as num_wins
    FROM  tutorial.oscar_nominees
    WHERE  winner = 'true'
    GROUP BY  1
    ORDER BY  2 DESC
    )
    
    SELECT  nominee, num_wins
    FROM  wins
    WHERE  num_wins = (SELECT  MAX(num_wins) FROM  wins);


--WAQ to find the nominee name with the second highest number of oscar wins. Solve using CTE.
WITH wins AS (
    SELECT  nominee,
    COUNT(*) as num_wins
    FROM  tutorial.oscar_nominees
    WHERE  winner = 'true'
    GROUP BY  1
    ORDER BY  2 DESC
    )
SELECT  nominee, num_wins
FROM  wins
WHERE  num_wins = (SELECT  MAX(num_wins) FROM  wins WHERE  num_wins < (SELECT  MAX(num_wins) FROM  wins) );


--WAQ to create three columns per nominee
--Number of wins, Number of loss, Total nomination 
SELECT  nominee,
       SUM(CASE WHEN winner = 'true' THEN 1 ELSE 0 END) AS NUMBER_OF_WINS ,
       SUM(CASE WHEN winner = 'false' THEN 1 ELSE 0 END) AS NUMBER_OF_LOSSES ,
       COUNT(*) AS TOTAL_NOMNIEES
FROM  tutorial.oscar_nominees
GROUP BY  1
ORDER BY  4;





