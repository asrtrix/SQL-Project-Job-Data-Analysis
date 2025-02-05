/*
Question 5: What are the most optimal skills to learn (basically the ones which are in high demand and a high paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Engineer roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
  offering strategic insights for career development in data engineering
*/

WITH skills_demand AS(
    SELECT 
        skills_dim.skill_id,
        count(skills_job_dim.job_id) AS totalcount,
        skills_dim.skills
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Engineer' AND 
        job_work_from_home = TRUE AND
        salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
), average_salary AS(
    SELECT
        skills_job_dim.skill_id, 
        ROUND(AVG(salary_year_avg),0) AS avgsalary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Engineer' AND 
        job_work_from_home = TRUE AND
        salary_year_avg IS NOT NULL
    GROUP BY skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    totalcount,
    avgsalary
FROM skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
ORDER BY
    totalcount DESC,
    avgsalary DESC,
LIMIT 25;

--rewriting the above query more consisely
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS totalcount,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avgsalary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Engineer'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avgsalary DESC,
    totalcount DESC
LIMIT 25;



