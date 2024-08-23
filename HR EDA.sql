SELECT * FROM project.hr;
use project;
ALTER TABLE hr
CHANGE COLUMN  ï»¿id emp_id VARCHAR (30) NULL;

SELECT birthdate,
CASE
      WHEN birthdate LIKE '%/%' THEN DATE_FORMAT(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
      WHEN birthdate LIKE '%-%' THEN DATE_FORMAT(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
      ELSE NULL
      END AS DATEE
 FROM hr;    
 
SET SQL_SAFE_UPDATES = 0;
UPDATE hr 
set birthdate =CASE
      WHEN birthdate LIKE '%/%' THEN DATE_FORMAT(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
      WHEN birthdate LIKE '%-%' THEN DATE_FORMAT(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
      ELSE NULL
      END ;
SELECT * FROM hr;

ALTER TABLE hr
MODIFY COLUMN birthdate DATE;
DESCRIBE hr;

SELECT hire_date, CASE
      WHEN hire_date LIKE '%/%' THEN DATE_FORMAT(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
      WHEN hire_date LIKE '%-%' THEN DATE_FORMAT(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
      ELSE NULL
      END 
 FROM hr;     


SET SQL_SAFE_UPDATES=0;
UPDATE hr
SET hire_date =CASE
      WHEN hire_date LIKE '%/%' THEN DATE_FORMAT(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
      WHEN hire_date LIKE '%-%' THEN DATE_FORMAT(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
      ELSE NULL
      END ;
      
SELECT hire_date from hr;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;
DESCRIBE hr;


UPDATE hr
SET termdate = date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate !='';
SELECT * FROM hr;

ALTER TABLE hr
MODIFY COLUMN termdate DATE;


ALTER TABLE hr
ADD COLUMN age int;
UPDATE hr
SET age = timestampdiff(YEAR,birthdate,CURDATE());

-- QUESTIONS

-- 1. What is the Gender Breakdown of Employees in the company?
SELECT gender, count(*)
FROM hr
WHERE age >=18
GROUP BY gender;
-- 2. What is the Race/ethnicity breakdown of employees in the company?
SELECT race, count(*) as count
FROM hr
WHERE age >=18
GROUP BY race
ORDER BY count(*) desc;

-- 3. what is the age distribution of employees in the company?
SELECT 
min(age),
max(age)
FROM hr;

SELECT CASE 
WHEN age >=18 AND age<=24 THEN '18-24'
WHEN age >=25 AND age<=34 THEN '25-34'
WHEN age >=35 AND age<=44 THEN '35-44'
WHEN age >=45 AND age<=54 THEN '45-54'
WHEN age >=55 AND age<=64 THEN '55-64'
ELSE '65+'
END AS age_group,
COUNT(*)
FROM hr
WHERE age >= 18
GROUP BY age_group
ORDER BY age_group;


SELECT CASE 
WHEN age >=18 AND age<=24 THEN '18-24'
WHEN age >=25 AND age<=34 THEN '25-34'
WHEN age >=35 AND age<=44 THEN '35-44'
WHEN age >=45 AND age<=54 THEN '45-54'
WHEN age >=55 AND age<=64 THEN '55-64'
ELSE '65+'
END AS age_group,gender,
COUNT(*)
FROM hr
WHERE age >= 18
GROUP BY age_group,gender
ORDER BY age_group,gender desc;

-- 4. How many employees work at the Headquarters versus remote locations?
SELECT location, COUNT(*)
FROM HR
where age >= 18
GROUP BY location;

-- 5. What is the average length of employment for employees wgo have been terminated
SELECT ROUND(AVG(datediff(termdate, hire_date))/365,0) AS avg_year_employment FROM HR
WHERE termdate <=curdate() and age >= 18;


-- 6. How does the gender distribution vary across departments
SELECT department, gender,count(*)
from hr 
where age>=18
GROUP BY department, gender
order by department;

-- 7 what is the distriution of job titles acros the company
SELECT jobtitle, count(*) as count
from hr
where age>=18
group by jobtitle
order by count desc;

-- 8. Which department has the highest turnover rate?
SELECT department,
total_count,
terminated_count,
terminated_count/total_count AS termination_rate 
FROM(
SELECT department,
count(*) AS total_count,
SUM( CASE WHEN termdate<>'0000-00-00' AND termdate <=curdate() then 1 else 0 END) AS terminated_count
FROM hr
where age >=18
group by department) AS subquery
ORDER BY termination_rate desc;


-- 10. How has the company's employee count changed over time based on hire and term dates



-- 9. what is the distribution of employees across locations by city and state?

SELECT location_state,COUNT(*) AS COUNT
FROM hr
WHERE age >=18
GROUP BY location_state
ORDER BY COUNT DESC;
SELECT * FROM HR;

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT year,
hires,
terminations,
hires-terminations AS net_change,
ROUND((hires-terminations)/hires*100,2) AS net_change_percenthrhr
FROM (SELECT 
          YEAR(hire_date) AS year,
          COUNT(*) AS hires,
          SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END ) AS terminations
          FROM hr
          WHERE age >= 18
          GROUP BY YEAR(hire_date) )AS subquery
          
ORDER BY year DESC;

















