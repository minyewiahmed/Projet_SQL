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
    AVG_Salary,
    
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id