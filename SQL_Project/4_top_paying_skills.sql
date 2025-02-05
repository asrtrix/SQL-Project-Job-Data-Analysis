/*
Question 4: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Engineer remote positions.
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Engineer and helps 
  identify the most financially rewarding skills to acquire or improve.
*/

SELECT 
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avgsalary,
    skills
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Engineer' AND 
    job_work_from_home = TRUE AND
    salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY avgsalary DESC
LIMIT 25
