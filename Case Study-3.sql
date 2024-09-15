## In this case study we are using exported data 'kag_conversion_data' from 'mode.com' in 'MySQL Workbench'

--WAQ to display all the records in the table kag_conversion_data
  SELECT * FROM kag_conversion_data;

--WAQ to count the total number of records in the dataset. 
  SELECT COUNT(*) AS "total record" FROM kag_conversion_data;

--WAQ to count the distinct number of fb_campaign_id
  SELECT COUNT(distinct(fb_campaign_id)) AS "total fb campaign id" 
  FROM kag_conversion_data;

--WAQ to find the maximum spent, average interest, AND minimum impressions for ad_id
  SELECT ad_id, MAX(spent), AVG(interest), MIN(impressions) 
  FROM kag_conversion_data GROUP BY ad_id;

--WAQ to find the maximum spent, average interest, AND minimum impressions for ad_id
  SELECT *, (spent/impressions) AS "spent per impression"
  FROM kag_conversion_data ;

--WAQ to count the ad_campaign for each age group.  
  SELECT age, count(xyz_campaign_id) AS "total id count"
  FROM kag_conversion_data
  GROUP BY age;
  
--WAQ to count the ad_campaign for each age group. 
  SELECT gender, avg(spent) AS avg_spent
  FROM kag_conversion_data
  GROUP BY gender;
  
--WAQ to find the total approved conversion per xyz campaign id. Arrange the total conversion in descending order.
  SELECT xyz_campaign_id, sum(approved_conversion) AS total_approved_conversion
  FROM kag_conversion_data
  GROUP BY xyz_campaign_id
  ORDER BY total_approved_conversion DESC;

--WAQ to show the fb_campaign_id AND total interest per fb_campaign_id. Only show the campaign which hAS more than 300 interests.
  SELECT fb_campaign_id, sum(interest) AS total_interest
  FROM kag_conversion_data 
  GROUP BY fb_campaign_id 
  having sum(interest) > 300
  ORDER BY total_interest DESC ;
  
--WAQ to find the age AND gender segment with maximum impression to interest ratio. Return three columns - age, gender, impression_to_interest.
  SELECT age, gender, (sum(impressions)/sum(interest))  AS impression_to_interest_ratio
  FROM kag_conversion_data
  GROUP BY gender, age
  ORDER BY impression_to_interest_ratio DESC
  limit 1;

--Write a query to find the top 2 xyz_campaign_id AND gender segment with the maximum total_unapproved_conversion (total_conversion - approved_conversion)
  SELECT xyz_campaign_id, gender, (sum(total_conversion)-sum(approved_conversion)) AS total_unapproved_conversion 
  FROM kag_conversion_data 
  GROUP BY 1, 2
  ORDER BY 3 DESC 
  LIMIT 2;

