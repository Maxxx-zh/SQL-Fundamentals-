-- Start ##

SELECT *
FROM recent_grads

--  First Query ##

select * from recent_grads;

-- The LIMIT Clause ##

SELECT *
FROM recent_grads
LIMIT 5;

--  Selecting Specific Columns ##

SELECT Major , ShareWomen
FROM recent_grads

--

SELECT name , tagline , contributed_by
FROM beers
LIMIT 10;

--  Filtering Rows Using WHERE ##

SELECT Major ,  ShareWomen
FROM recent_grads
WHERE ShareWomen < 0.5

--  Expressing Multiple Filter Criteria Using 'AND' ##

SELECT Major , Major_category , Median,ShareWomen
FROM recent_grads
WHERE ShareWomen > 0.5  AND Median > 50000

--  Returning One of Several Conditions With OR ##

SELECT Major,Median,Unemployed
FROM recent_grads
WHERE Median >= 10000
OR Men > Women
LIMIT 20;

--  Grouping Operators with Parentheses ##

SELECT Major,Major_category,ShareWomen,Unemployment_rate
FROM recent_grads
WHERE Major_category = 'Engineering' 
AND (ShareWomen > 0.5 
     OR Unemployment_rate < 0.051 )

--  Ordering Results Using ORDER BY ##

SELECT Major, ShareWomen, Unemployment_rate
FROM recent_grads
WHERE ShareWomen > 0.3 
AND Unemployment_rate < 0.1
ORDER BY ShareWomen DESC

--  Practice Writing a Query ##

SELECT Major_category, Major, Unemployment_rate
FROM recent_grads
WHERE Major_category IN ('Engineering' , 'Physical Sciences')
ORDER BY Unemployment_rate ;


------------------------------------------------------------------------------------------------



--  A Simple Question ##

SELECT MIN(Unemployment_rate)
FROM recent_grads

--  Aggregate Functions ##

SELECT SUM(Total)
FROM recent_grads

--  Order of Execution ##

SELECT COUNT(Major)
FROM recent_grads
WHERE ShareWomen < 0.5

-- Missing Values ##

SELECT COUNT(*),COUNT(Unemployment_rate)
FROM recent_grads

--  Combining Multiple Aggregation Functions ##

SELECT AVG(Total) , MIN(Men) , MAX(Women)
FROM recent_grads

--  Customising the Results ##

SELECT COUNT(*) AS 'Number of Majors' , MAX(Unemployment_rate) AS 'Highest Unemployment Rate'
FROM recent_grads

-- Counting Unique Values ##

SELECT COUNT(DISTINCT Major) AS 'unique_majors' ,
        COUNT(DISTINCT Major_category) AS 'unique_major_categories',
        COUNT(DISTINCT Major_code) AS 'unique_major_codes'
FROM recent_grads

-- String Functions and Operations ##

SELECT 'Major: ' || LOWER(Major) AS 'Major',Total,Men,Women,Unemployment_rate,LENGTH(Major) AS 'Length_of_name'
FROM recent_grads
ORDER BY Unemployment_rate DESC;

-- Performing Arithmetic in SQL ##

SELECT Major , Major_category , P75th - P25th  AS 'quartile_spread'
FROM recent_grads
ORDER BY quartile_spread
LIMIT 20;



----------------------------------------------------------------


--  If/Then in SQL ##

SELECT CASE
WHEN Sample_size < 200 THEN 'Small'
WHEN Sample_size >=200 AND Sample_size < 1000 THEN 'Medium'
WHEN Sample_size >=1000 THEN 'Large'
END AS Sample_category
FROM recent_grads

--  Dissecting CASE ##

SELECT Major , Sample_size , 
CASE
WHEN Sample_size < 200 THEN 'Small'
WHEN Sample_size >= 200 AND Sample_size < 1000  THEN 'Medium'
ELSE 'Large'
END AS Sample_category
FROM recent_grads

--  Calculating Group-Level Summary Statistics ##

SELECT Major_category , SUM(Total) AS Total_graduates
FROM recent_grads
GROUP BY Major_category

--  GROUP BY Visual Breakdown ##

SELECT Major_category , AVG(ShareWomen) AS Average_women
FROM recent_grads
GROUP BY Major_category

--  Multiple Summary Statistics by Group ##

SELECT Major_category , SUM(Women) AS Total_women , AVG(ShareWomen) AS Mean_women , SUM(Total) * AVG(ShareWomen) AS Estimate_women
FROM recent_grads
GROUP BY Major_category

--  Multiple Group Columns ##

SELECT Major_category , Sample_category , AVG(ShareWomen) AS Mean_women , SUM(Total) AS Total_graduates
FROM new_grads
GROUP BY Major_category , Sample_category

--  Querying Virtual Columns With the HAVING Statement ##

SELECT Major_category , AVG(Low_wage_jobs)/AVG(Total) AS Share_low_wage
FROM new_grads
GROUP BY Major_category
HAVING Share_low_wage > .1

--  Rounding Results With the ROUND() Function ##

SELECT ROUND(ShareWomen,4) AS Rounded_women , Major_category
FROM new_grads
LIMIT 10

--  Nesting functions ##

SELECT Major_category, ROUND(AVG(College_jobs) / AVG(Total),3) AS Share_degree_jobs
FROM new_grads
GROUP BY Major_category
HAVING Share_degree_jobs < .3

--  Casting ##

SELECT Major_category,CAST(SUM(Women) AS FLOAT)/CAST(SUM(Total) AS FLOAT) AS SW
FROM new_grads
GROUP BY Major_category
ORDER BY SW



----------------------------------------------------------------

-- Writing More Complex Queries ##

SELECT Major , ShareWomen
FROM recent_grads
WHERE ShareWomen > 0.5225502029537575

-- Subqueries ##

SELECT Major , Unemployment_rate
FROM recent_grads
WHERE Unemployment_rate < (
    SELECT AVG(Unemployment_rate)
    FROM recent_grads)

-- Subquery in SELECT ##

SELECT CAST(COUNT(*) AS FLOAT) /
       CAST((SELECT COUNT(*)
          FROM recent_grads
       ) AS FLOAT) AS proportion_abv_avg
  FROM recent_grads
 WHERE ShareWomen > (SELECT AVG(ShareWomen)
                       FROM recent_grads
                    );

-- The IN Operator ##

SELECT Major_category , Major
FROM recent_grads
WHERE Major_category IN ('Business','Humanities & Liberal Arts','Education')

-- Returning Multiple Results in Subqueries ##

SELECT Major_category, Major
  FROM recent_grads
 WHERE Major_category IN('Business', 'Humanities & Liberal Arts','Education');

-- Building Complex Subqueries ##

SELECT AVG(CAST(Sample_size AS FLOAT) / CAST(Total AS FLOAT)) AS avg_ratio
FROM recent_grads

-- Practice Integrating A Subquery With The Outer Query ##

SELECT Major , Major_category , (SELECT CAST(Sample_size AS FLOAT) / CAST(Total AS FLOAT)) AS ratio
FROM recent_grads
WHERE ratio > (SELECT AVG(CAST(Sample_size AS FLOAT) / CAST(Total AS FLOAT)) AS avg_ratio
FROM recent_grads)
