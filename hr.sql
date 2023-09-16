select * from human_resources;

-- 1. What is the gender breakdown of employees in the company?
select gender, count(*) as count from human_resources
where age >=18 and termdate is null
group by gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
select race, count(*) as count from human_resources
where age >=18 and termdate is null
group by race
order by count desc;

-- 3. What is the age distribution of employees in the company?

SELECT age_group, gender, COUNT(*) AS count
FROM (
    SELECT 
        CASE
            WHEN age >= 18 AND age <= 24 THEN '18-24'
            WHEN age >= 25 AND age <= 34 THEN '25-34'
            WHEN age >= 35 AND age <= 44 THEN '35-44'
            WHEN age >= 45 AND age <= 54 THEN '45-54'
            WHEN age >= 55 AND age <= 64 THEN '55-64'
            ELSE '65+'
        END AS age_group, gender
    FROM human_resources
    WHERE age >= 18 AND termdate IS NULL
) grouped_data
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. How many employees work at headquarters versus remote locations?
select location, count(*) as count
from human_resources
WHERE age >= 18 AND termdate IS NULL
group by location;

-- 5. What is the average length of employment for employees who have been terminated?
select
    round(avg((termdate - hire_date)/365)) as avg_len_employment
from human_resources
where termdate <= sysdate and termdate is not null and age>=18;

-- 6. How does the gender distribution vary across departments and job titles?
select department, gender, count(*) as count
from human_resources
WHERE age >= 18 AND termdate IS NULL
group by department, gender
order by department;

-- 7. What is the distribution of job titles across the company?
select jobtitle, count(*) as count
from human_resources
WHERE age >= 18 AND termdate IS NULL
group by jobtitle
order by jobtitle;

-- 8. Which department has the highest turnover rate?
select department,
total_count, terminated_count, round(terminated_count/total_count,4) as termination_rate
from (
select department, count(*) as total_count,
SUM(CASE WHEN termdate is not null AND termdate <= sysdate THEN 1 ELSE 0 END) as terminated_count
from human_resources where age >= 18
group by department) 
order by termination_rate desc;


-- 9. What is the distribution of employees across locations by city and state?
select location_state, count(*) as count
from human_resources
WHERE age >= 18 AND termdate IS NULL
group by location_state
order by count desc;

-- 10. How has the company's employee count changed over time based on hire and term dates?
select
year, hires, terminations, 
hires-terminations as net_change,
round((hires-terminations)/hires*100, 2) as net_change_percent
from
(
select 
EXTRACT(YEAR FROM hire_date) as year,
count(*) as hires,
SUM(CASE WHEN termdate is not null and termdate <= sysdate THEN 1 ELSE 0 END) as terminations
from human_resources where age >= 18 
group by EXTRACT(YEAR FROM hire_date)
)
order by year asc;

-- 11. What is the tenure distribution for each department?
select department, round(avg((termdate - hire_date)/365),0) as avg_tenure
from human_resources
where termdate <= sysdate and termdate is not null and age>=18
group by department;