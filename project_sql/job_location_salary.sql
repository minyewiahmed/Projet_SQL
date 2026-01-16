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
