--In this case study i'm using exported data 'crunchbase_companies' from 'mode.com' in 'MySQL Workbench'

SELECT * FROM crunchbase_companies;


SELECT * FROM crunchbase_companies 
WHERE country_code IS NOT NULL;

SELECT * FROM crunchbase_companies WHERE founded_year<2015 AND funding_total_usd >=1000000; 


SELECT name FROM crunchbase_companies WHERE funding_rounds BETWEEN 3 AND 6; 


SELECT * FROM crunchbase_companies WHERE country_code in ('IN','USA','GBR'); 
SELECT * FROM crunchbase_companies WHERE country_code not in ('IN','USA','GBR'); 


SELECT * FROM crunchbase_companies WHERE status in ('operating','acquired'); 


--Starting with S
SELECT * FROM crunchbase_companies 
WHERE name LIKE 'S%';

--Ending with S
SELECT * FROM crunchbase_companies 
WHERE name LIKE '%S';

--Containing S
SELECT * FROM crunchbase_companies 
WHERE name LIKE '%S%';


SELECT COUNT(name) AS num_companies 
  FROM crunchbase_companies 
  WHERE category_code='biotech' AND founded_year>2000 AND (funding_total_usd>1000000 OR (funding_rounds>1 AND status='ipo'));



SELECT (companies.quarter,acquisitions.quarter) AS quarter,
       companies.companies_founded
   FROM
           ( SELECT founded_quarter as quarter,
            COUNT(permalink) AS companies_founded
            FROM crunchbase_companies
            WHERE founded_year >= 2012
            GROUP BY 1) companies
   JOIN 
           ( SELECT acquired_quarter AS quarter,
            COUNT(distinct company_permalink) AS companies_acquired
            FROM crunchbase_acquisitions
            WHERE acquired_year >= 2012
            GROUP BY 1) acquisitions
     ON companies.quarter = acquisitions.quarter
   ORDER BY 1;


