# Introduction

This SQL project was developed as part of the “SQL for Data Analystics” course by Luke Barousse. It focuses on analyzing the data analytics job market including :

- Top-paying data analyst roles

- Most in-demand technical skills

- The intersection between high-demand skills and high salaries

- Top locations that offer high salary for Data Analyst role

You will find SQL queries here : [project_sql folder](/project_sql/)

# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

Data hails from  [SQL Course](https://lukebarousse.com/sql). It's packed with insights on job titles, salaries, locations, and essential skills.
### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries for data analysts?
5. What are the most optimal skills to learn for data analyst?
6. what locations have the highest AVG_salary for data analyst?

# Tools I Used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** My go-to for database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.
# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
select 
    job_title,
    job_id,
    salary_year_avg,
    company_dim.name as company_name
FROM
    job_postings_fact
join company_dim on job_postings_fact.company_id = company_dim.company_id    
where
    job_title_short = 'Data Analyst' and  
    job_location = 'Anywhere' and
    salary_year_avg is not null
order by 
    salary_year_avg desc
limit 10
```
Here's the breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.
### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
```sql

WITH top_paying_jobs AS(
    select 
        job_title,
        job_id,
        salary_year_avg,
        company_dim.name as company_name
    FROM
        job_postings_fact
    join company_dim on job_postings_fact.company_id = company_dim.company_id    
    where
        job_title_short = 'Data Analyst' and  
        job_location = 'Anywhere' and
        salary_year_avg is not null
    order by 
        salary_year_avg desc
    limit 10
)
SELECT top_paying_jobs.*,
        skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
```
Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:
- **SQL** is leading with a bold count of 8.
- **Python** follows closely with a bold count of 7.
- **Tableau** is also highly sought after, with a bold count of 6.
Other skills like **R**, **Snowflake**, **Pandas**, and **Excel** show varying degrees of demand.

### 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```
Here's the breakdown of the most demanded skills for data analysts in 2023
- **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- **Programming** and **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 7291         |
| Excel    | 4611         |
| Python   | 4330         |
| Tableau  | 3745         |
| Power BI | 2609         |

*Table of the demand for the top 5 skills in data analyst job postings*

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```sql
SELECT
    skills_dim.skills,
    round(AVG(salary_year_avg),0) as AVG_Salary
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
where 
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY
     skills
ORDER BY
     AVG_Salary DESC
LIMIT 25 
```
Here's a breakdown of the results for top paying skills for Data Analysts:
- **High Demand for Big Data & ML Skills:** Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.
- **Software Development & Deployment Proficiency:** Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
- **Cloud Computing Expertise:** Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.

| Skills        | Average Salary ($) |
|---------------|-------------------:|
| pyspark       |            208,172 |
| bitbucket     |            189,155 |
| couchbase     |            160,515 |
| watson        |            160,515 |
| datarobot     |            155,486 |
| gitlab        |            154,500 |
| swift         |            153,750 |
| jupyter       |            152,777 |
| pandas        |            151,821 |
| elasticsearch |            145,000 |

*Table of the average salary for the top 10 paying skills for data analysts*

### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
WITH skills_demand AS( 
    SELECT
        skills_dim.skills,
        skills_dim.skill_id,
        count(skills_job_dim.job_id) as demand_count
    FROM 
        job_postings_fact
    INNER JOIN 
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN 
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    where 
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL
    GROUP BY 
        skills_dim.skill_id
    

), average_salary AS(
    SELECT
        skills_dim.skills,
        skills_dim.skill_id,
        round(AVG(salary_year_avg),0) as AVG_Salary
    FROM 
        job_postings_fact
    INNER JOIN 
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN 
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    where 
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
    
)
SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    AVG_Salary 
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
```

| Skills     | Demand Count | Average Salary ($) |
|------------|-------------:|-------------------:|
| sql        |        3,083 |             96,435 |
| python     |        1,840 |            101,512 |
| nosql      |          108 |            108,331 |
| scala      |           59 |            115,480 |
| java       |          135 |            100,214 |
| r          |        1,073 |             98,708 |
| shell      |           44 |            111,496 |
| sas        |          500 |             93,707 |
| go         |          288 |             97,267 |
| javascript |          153 |             91,805 |
| html       |           55 |             84,383 |
| css        |           30 |             85,317 |
| bash       |           19 |            105,075 |
| c++        |           68 |            105,696 |
| c#         |           71 |             97,248 |

*Table of the most optimal skills for data analyst sorted by salary*

Here's a breakdown of the most optimal skills for Data Analysts in 2023: 
- **High-Demand Programming Languages:** Python and SQL stand out for their high demand, with demand counts of 1,840 and 3,083 respectively. Despite their high demand, their average salaries are around $101,512 for Python and $96,435 for SQL, indicating that proficiency in these languages is highly valued but also widely available.
- **Cloud Tools and Technologies:** Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
- **Business Intelligence and Visualization Tools:** Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
- **Database Technologies:** The demand for skills in traditional and NoSQL databases (Oracle, SQL Server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.

### 6. Locations Based on Salary
Exploring the average salaries associated with different locations revealed which locations are the highest paying.
```sql
SELECT
    job_location,
    COUNT(*) AS job_demande,
    ROUND(AVG(salary_year_avg), 2) AS avg_yearly_salary
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
  AND salary_year_avg IS NOT NULL
  AND job_schedule_type = 'Full-time'
GROUP BY job_location
HAVING COUNT(*) >= 5
ORDER BY avg_yearly_salary DESC
LIMIT 10;
```
| Job Location             | Job Demand | Average Salary ($) |
|--------------------------|----------:|-----------------:|
| South San Francisco, CA  |          7 |          182,771 |
| Bethesda, MD             |         13 |          163,044 |
| Mountain View, CA        |         28 |          148,322 |
| San Mateo, CA            |         10 |          133,542 |
| Sunnyvale, CA            |          8 |          133,382 |
| San Jose, CA             |         29 |          130,452 |
| Palo Alto, CA            |         12 |          129,498 |
| St. Petersburg, FL       |          5 |          128,103 |
| Santa Clara, CA          |         11 |          125,027 |
| San Francisco, CA        |         70 |          123,193 |

*Table of the average salary for the top 10 paying skills for data analysts*

