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