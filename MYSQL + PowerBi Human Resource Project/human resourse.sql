CREATE DATABASE project_hr;

USE project_hr;

SELECT * FROM HR;

ALTER TABLE HR 
CHANGE COLUMN  嚜磨d emp_id VARCHAR(20) NULL;

DESCRIBE HR;

SET sql_safe_updates = 0;

UPDATE HR
SET birthdate = CASE
WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%Y/%m/%d'),'%Y-%m-%d')
WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%Y-%m-%d'),'%Y-%m-%d')
ELSE NULL
END;
 
 ALTER TABLE HR
 MODIFY COLUMN  birthdate date; 
 
 UPDATE HR
SET hire_date = CASE
WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'),'%Y-%m-%d')
WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%d-%m-%Y'),'%Y-%m-%d')
ELSE NULL
END;

ALTER TABLE HR
 MODIFY COLUMN  hire_date date; 
 
 UPDATE HR
 SET termdate = date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
 WHERE termdate IS NOT NULL AND termdate !='';
 
 UPDATE HR
 SET termdate = null
 WHERE termdate = '';
 
 ALTER TABLE HR
 ADD COLUMN age INT;
 
 UPDATE HR
 SET age = timestampdiff(YEAR,birthdate,curdate());
 
 SELECT * FROM HR;
 
 CREATE TABLE gender_counts (
    gender VARCHAR(255), 
    gender_count INT
);
    -- What is gender breakdown of employees in the company
    SELECT gender ,count(*) AS gender_count
    from HR 
    WHERE termdate IS NULL
    GROUP BY gender;
    
    INSERT INTO gender_counts (gender, gender_count)
    SELECT gender ,count(*) AS gender_count
    from HR 
    WHERE termdate IS NULL
    GROUP BY gender;
    
    -- what is the race breakdown of the employees in the company
     SELECT race ,count(*) AS race_count
    from HR 
    WHERE termdate IS NULL
    GROUP BY race;
    
 CREATE TABLE race_counts (
    race VARCHAR(255), 
    race_count INT
);

INSERT INTO race_counts (race, race_count)
SELECT race ,count(*) AS race_count
    from HR 
    WHERE termdate IS NULL
    GROUP BY race;
    
    -- What is the age distribution of employees in the company?
SELECT 
CASE
WHEN age >= 18 AND age <=24 THEN '18 - 24'
WHEN age >= 25 AND age <=34 THEN '25 - 34'
WHEN age >= 35 AND age <=44 THEN '35 - 44'
WHEN age >= 45 AND age <=54 THEN '45 - 54'
WHEN age >= 55 AND age <=64 THEN '55 - 64'
ELSE '65+'
END as age_group,
COUNT(*) AS age_group_count
FROM HR
WHERe termdate IS NULL 
GROUP BY age_group
ORDER BY age_group;

 CREATE TABLE age_groups (
    age_group INT, 
    age_group_count INT
);

Alter table age_groups 
modify column age_group varchar(20);

INSERT INTO age_groups (age_group,age_group_count )
SELECT 
CASE
WHEN age >= 18 AND age <=24 THEN '18 - 24'
WHEN age >= 25 AND age <=34 THEN '25 - 34'
WHEN age >= 35 AND age <=44 THEN '35 - 44'
WHEN age >= 45 AND age <=54 THEN '45 - 54'
WHEN age >= 55 AND age <=64 THEN '55 - 64'
ELSE '65+'
END as age_group,
COUNT(*) AS age_group_count
FROM HR
WHERe termdate IS NULL 
GROUP BY age_group
ORDER BY age_group;

Select * from HR;

-- how many employees work at Headquaters vs Remote?
SELECT location , COUNT(*) AS count_location
FROM HR 
WHERE termdate IS NULL
GROUP BY location;

 CREATE TABLE location_counts (
    loction VARCHAR (60), 
    count_location INT
);
ALTER TABLE location_counts
CHANGE column loaction location VARCHAR(60);

INSERT INTO location_counts ( location, count_location)
SELECT location , COUNT(*) AS count_location
FROM HR 
WHERE termdate IS NULL
GROUP BY location;

-- How does the gender distribution vary across department and jobtitle?
SELECT gender, department, jobtitle,
COUNT(*) AS gender_distribution_count
FROM HR
WHERE termdate is null
group by gender, department, jobtitle
order by gender, department, jobtitle;

CREATE TABLE gender_distribution_counts (
     gender VARCHAR (60), 
    department VARCHAR (100),
    jobtitle VARCHAR (100),
    gender_distribution_count INT 
);

INSERT INTO  gender_distribution_counts (
     gender , 
    department,
    jobtitle ,
    gender_distribution_count 
) 
SELECT gender, department, jobtitle,
COUNT(*) AS gender_distribution_count
FROM HR
WHERE termdate is null
group by gender, department, jobtitle
order by gender, department, jobtitle;
 
SELECT * FROM  gender_distribution_counts;

SELECT * FROM HR;

-- what is the distribution of employees across location_state?
SELECT location_state ,
COUNT(*) AS total_employee
FROM HR
WHERE termdate IS NULL
GROUP BY location_state;

CREATE TABLE employee_distribution_across_state(
location_state varchar(100),
total_employee INT );

INSERT INTO employee_distribution_across_state(
location_state ,
total_employee )
SELECT location_state ,
COUNT(*) AS total_employee
FROM HR
WHERE termdate IS NULL
GROUP BY location_state;


SELECT year(termdate) - year(hire_date) AS length_of_employement
FROM HR
WHERE termdate is not null and termdate <=curdate();

-- what is the average length of the employement who have been terminated?
SELECT ROUND(AVG(year(termdate) - year(hire_date)),0) AS length_of_employement
FROM HR
WHERE termdate is not null and termdate <=curdate();

-- What is the tenure distribution for each department
SELECT department,
ROUND(avg(datediff(termdate,hire_date)/365),0) AS avg_tenure
FROM HR
WHERE termdate is NOT NULL AND termdate <=curdate()
GROUP BY department; 

-- which department has the higher turnover rate?
select department,
COUNT(*) AS Total_count,
COUNT( case
wHEN termdate is not null and termdate <= curdate() THEn 1
end) as terminated_count,
ROUND((COUNT( case
wHEN termdate is not null and termdate <= curdate() THEn 1
end)/count(*))*100,2) as termination_rate
from HR
group by department
order by termination_rate DESC;

-- what is the distribution of employees across location_city?
SELECT location_city ,
COUNT(*) AS total_employee
FROM HR
WHERE termdate IS NULL
GROUP BY location_city;

select * from HR;
