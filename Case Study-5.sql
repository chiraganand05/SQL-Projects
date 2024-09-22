--In this Case Study i'm using exported data 'crunchbase_companies' from 'mode.com' in 'MySQL Workbench'

--WAQ to display all the records in the table crunchbase_companies
SELECT * FROM crunchbase_companies;

--WAQ to display all the records where country code is not null
SELECT * FROM crunchbase_companies 
WHERE country_code IS NOT NULL;

--WAQ to display all the records where the founded year is before 2015 and funding is at least 1000000
SELECT * FROM crunchbase_companies WHERE founded_year<2015 AND funding_total_usd >=1000000; 

--WAQ to calculate the average funding_total_usd per company for the companies founded in the software, education, and analytics category
SELECT category_code, AVG(funding_total_usd) AS avg_funding FROM crunchbase_companies WHERE category_code IN('software','education','analytics') GROUP BY 1;

--WAQ to display all the records where country code is 'IN', 'USA', 'GBR'
SELECT * FROM crunchbase_companies WHERE country_code in ('IN','USA','GBR'); 
SELECT * FROM crunchbase_companies WHERE country_code not in ('IN','USA','GBR'); 

-- WAQ to display all the record where status is operating and acquired
SELECT * FROM crunchbase_companies WHERE status in ('operating', 'acquired'); 

--Starting with S
SELECT * FROM crunchbase_companies 
WHERE name LIKE 'S%';

--Ending with S
SELECT * FROM crunchbase_companies 
WHERE name LIKE '%S';

--Containing S
SELECT * FROM crunchbase_companies 
WHERE name LIKE '%S%';

--WAQ to find the number of companies who are founded after 2000 and either have more than 1Mn funding or have ipo and secured more than 1 round of funding
SELECT COUNT(name) AS num_companies 
  FROM crunchbase_companies 
  WHERE category_code='biotech' AND founded_year>2000 AND (funding_total_usd>1000000 OR (funding_rounds>1 AND status='ipo'));


--
SELECT (companies.quarter, acquisitions.quarter) AS quarter,
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


