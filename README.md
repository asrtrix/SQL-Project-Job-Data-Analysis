
# Introduction

📊 Dive into the data job market! Focusing on data analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

🔍 SQL queries? Check them out here: [SQL Project](/SQL_Project/)

# Background

Driven by the need to optimize job searches for data analysts, this project focuses on identifying the most valuable skills to increase earning potential and career success.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used

To thoroughly investigate the data analyst job market, I utilized several key tools:

- **SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL**: The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code**: My go-to for database management and executing SQL queries.
- **Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis

I formulated each query in this project to investigate a specific aspect of the data engineer job market. I approached each question in the following manner:

### 1. Top-Paying Data Engineer Jobs

To identify the highest-paying roles, I filtered data engineer positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Engineer' AND 
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
ORDER BY 
    salary_year_avg DESC
LIMIT 10;
```

Here's the breakdown of top data engineer jobs in 2023:

- **Significant Earning Potential**: Salaries for top 10 data engineer roles exhibit a wide range, from $242,000 to $325,000, highlighting substantial earning potential within the field.

- **Industry-Wide Demand**: A diverse range of employers, including Engtal, Meta, and Twitch, offer high-paying data engineer positions, demonstrating strong demand across various sectors.

- **Varied Roles and Specializations**: Job titles exhibit significant diversity, ranging from Data Engineer to Director of Engineering, reflecting the wide range of roles and specializations available within the data engineering field.

### 2. Skills for Top-Paying Data Engineer Jobs

To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
WITH top_paying_jobs AS (
SELECT
    job_id,
    job_title,
    salary_year_avg,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Engineer' AND 
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
ORDER BY salary_year_avg DESC
LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC
```

Here's the breakdown of the most demanded skills for the top 10 highest paying data engineer jobs in 2023:

- **SQL Dominates**: SQL emerges as the most in-demand skill.

- **Python Close Second**: Python follows closely behind with strong demand.

- **AWS Highly Sought After**: AWS is also highly sought after. Other essential skills include Azure and Spark, each with varying levels of demand across the top-paying positions.

### 3. Most In-Demand Skills

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT 
    count(job_postings_fact.job_id) AS totalcount,
    skills
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Engineer' AND job_work_from_home = TRUE
GROUP BY 
    skills
ORDER BY totalcount DESC
LIMIT 5;
```
Here's the breakdown of the most demanded skills for data engineers in 2023:

- **Foundational Skills Remain Critical:** SQL remains an essential foundation, while Python has emerged as a critical language for data manipulation, transformation, and machine learning tasks, emphasizing the importance of strong programming and data processing skills for data engineers.

- **Cloud Computing and Big Data Expertise are Paramount:** Proficiency in cloud platforms like AWS and Azure, along with big data technologies like Spark, is crucial, highlighting the growing significance of cloud-based infrastructure and distributed computing in modern data engineering practices.

### 4. Skills with Higher Salaries

Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT 
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avgsalary,
    skills
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Engineer' AND 
    job_work_from_home = TRUE AND
    salary_year_avg IS NOT NULL
GROUP BY 
    skills
ORDER BY avgsalary DESC
LIMIT 25;
```
Here's a breakdown of the results for top paying skills for Data Engineer:

- **High Demand for Big Data & ML Skills**: Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.

- **Software Development & Deployment Proficiency**: Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.

- **Cloud Computing Expertise**: Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.

### 5. Optimal Skills for Job Market Value

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS totalcount,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avgsalary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Engineer'AND 
    salary_year_avg IS NOT NULL AND 
    job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avgsalary DESC,
    totalcount DESC
LIMIT 25;
```

Here's a breakdown of the most optimal skills for Data Engineer in 2023:

- **Cloud Infrastructure and Orchestration:** Kubernetes, Terraform, and AWS/Azure (implied by the mention of Aurora) are highly sought-after, with high salaries, indicating the crucial role of cloud infrastructure management and container orchestration in modern data engineering.

- **Big Data Processing and Stream Processing:** Spark, PySpark, and Kafka are in high demand with competitive salaries, emphasizing the importance of big data processing, stream processing, and distributed computing frameworks.

- **Data Manipulation and Analysis:** Numpy and Pandas are essential for data manipulation and analysis, demonstrating the ongoing need for strong data processing and analytical skills within the data engineering field.

- **NoSQL and Database Expertise:** Cassandra and Elasticsearch are in demand with competitive salaries, highlighting the importance of NoSQL databases and search/analytics capabilities within data engineering workflows.

- **Emerging Technologies:** Golang and Ruby, while mentioned less frequently, are associated with high salaries, indicating a growing interest in these languages for backend development, scripting, and automation tasks within the data engineering domain.

# What I Learned

Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

- 🧩 **Advanced Query Construction:** I mastered complex SQL queries, effectively joining tables and utilizing WITH clauses to create and manage temporary tables efficiently.
- 📊 **Data Aggregation Proficiency:** I gained expertise in data aggregation techniques, leveraging GROUP BY and aggregate functions such as COUNT() and AVG() to summarize and analyze data effectively.
- 💡 **Enhanced Analytical Abilities:** I honed my analytical skills by translating real-world questions into actionable and insightful SQL queries, demonstrating my ability to solve complex data problems.

# Conclusions

### Insights

From the analysis, several general insights emerged:

- **Top-Paying Data Engineer Jobs:** Remote data engineer roles exhibit a wide salary range, from $242,000 to $325,000, indicating significant earning potential within the field.

- **Skills for Top-Paying Data Engineer Jobs:** High-paying data engineer positions consistently require SQL proficiency, emphasizing its critical role in achieving high earning potential.

- **Most In-Demand Skills:** SQL, Python, and AWS are among the most in-demand skills for data engineers, highlighting the importance of foundational programming languages and cloud computing expertise.

- **Skills with Higher Salaries:** Skills related to big data technologies (PySpark, Couchbase), machine learning (DataRobot, Jupyter), and cloud infrastructure (Kubernetes, Terraform) are often associated with higher salaries, indicating a premium on advanced technical and cloud-based expertise.

- **Optimal Skills for Job Market Value:** Cloud infrastructure (Kubernetes, Terraform, AWS/Azure), big data processing (Spark, PySpark, Kafka), and core data engineering skills (Python, Pandas, Numpy) emerge as optimal skills for data engineers, demonstrating high demand and offering competitive salaries, maximizing job market value for those who possess them.

### Closing Thoughts

This project significantly improved my SQL proficiency and provided valuable insights into the data engineer job market. The findings from this analysis offer a valuable roadmap for prioritizing skill development and optimizing job search strategies. By focusing on high-demand, high-salary skills, aspiring data engineer can enhance their competitiveness in the job market. This exploration underscores the critical importance of continuous learning and adaptability to stay abreast of evolving trends within the dynamic field of data engineering.