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