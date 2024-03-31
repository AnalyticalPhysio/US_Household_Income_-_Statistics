-- Performing Data Cleaning on US Household Income and US Household Income Statistics Dataset

SELECT * 
FROM USHouseholdIncome;

SELECT * 
FROM us_household_income_statistics;

-- 1. Finding the number (COUNT) of id in both Dataset

SELECT COUNT(id)
FROM USHouseholdIncome;

SELECT COUNT(id)
FROM us_household_income_statistics;

-- 2. Finding the Duplicates in US Household Income Dataset

SELECT id, COUNT(id)
FROM USHouseholdIncome
GROUP BY id
HAVING COUNT(id) > 1;

SELECT *
FROM ( SELECT row_id, id,
	   ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
	   FROM USHouseholdIncome) duplicates
WHERE row_num > 1;
    
-- 3. DELETING the Duplicates in US Household Income Dataset
    
DELETE FROM USHouseholdIncome
WHERE row_id IN(
SELECT row_id
FROM ( SELECT row_id, id,
	   ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
	   FROM USHouseholdIncome) duplicates
WHERE row_num > 1);

-- 4. Finding the Duplicates in US Household Income Statistics Dataset

SELECT id, COUNT(id)
FROM us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1;       

-- 5. Standardising the 'State_Name' Column in US Household Income Dataset

SELECT DISTINCT State_Name
FROM USHouseholdIncome
ORDER BY 1;

UPDATE USHouseholdIncome
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE USHouseholdIncome
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

-- 6. Replacing the NULL value in the 'Place' Column by 'Autaugaville' in US Household Income Dataset

SELECT *
FROM USHouseholdIncome
WHERE Place IS NULL
ORDER BY 1;

SELECT * 
FROM USHouseholdIncome
WHERE County = 'Autauga County' 
AND City = 'Vinemont';

UPDATE USHouseholdIncome
SET Place = 'Autaugaville'
WHERE County = 'Autauga County' 
AND City = 'Vinemont';

-- 7. Standardising the 'Type' Column in US Household Income Dataset

SELECT Type, COUNT(Type)
FROM USHouseholdIncome
GROUP BY Type;

UPDATE USHouseholdIncome
SET Type = 'Borough'
WHERE Type = 'Boroughs';

-- 8. Finding whether 'Aland' and 'Awater' column have zero values OR blank values OR no values in US Household Income Dataset

SELECT ALand, AWater
FROM USHouseholdIncome
WHERE  (ALand = 0 OR  ALand = '' OR  ALand IS NULL)
AND (AWater = 0 OR AWater = '' OR AWater IS NULL);

-- Performing Exploratory Data Analysis (EDA) on US Household Income and US Household Income Statistics Dataset

SELECT * 
FROM USHouseholdIncome;

-- 1. Which are the top 10 largest States having more land and water? Order the output by AWater.

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM USHouseholdIncome
WHERE ALand <> 0
OR AWater <> 0
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10;

-- 2. Performing Inner Join on both the Dataset

SELECT u.State_Name, County, Type,`Primary`, Mean, Median 
FROM USHouseholdIncome u
INNER JOIN us_household_income_statistics s
  ON u.id = s.id;

-- 2.1 What is the avergae household income in the top 5 States?

SELECT u.State_Name, ROUND(AVG(Mean),1)
FROM USHouseholdIncome u
INNER JOIN us_household_income_statistics s
  ON u.id = s.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 5;

-- 2.2 Looking at the average income with respect to 'Type' along with total count for each 'Type'

SELECT Type, COUNT(Type) as Count, ROUND(AVG(Mean),1) as Average_Income
FROM USHouseholdIncome u
INNER JOIN us_household_income_statistics s
  ON u.id = s.id
WHERE Mean <> 0
GROUP BY Type
HAVING COUNT(Type) > 100
ORDER BY 3 Desc;

-- 2.3 Top 5 State and City with higher Average Income than Median Income 

SELECT u.State_Name, City, ROUND(AVG(Mean),1) as Average_Income, ROUND(AVG(Median),1) as Average_Median_Income
FROM USHouseholdIncome u
INNER JOIN us_household_income_statistics s
  ON u.id = s.id
GROUP BY u.State_Name, City
HAVING Average_Income > Average_Median_Income
ORDER BY Average_Income DESC
LIMIT 5;


