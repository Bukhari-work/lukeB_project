/*
1. What are the top-paying jobs for my role?
- top 15 high paying data-analyst job that is available in Indonesia.
- focuses on job postings with salaries available.

Why?
- Highlight the top paying opportunities for Data Analyst.
*/
select
    job_id,
    job_title,
    cd."name" as company_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
from
    job_postings_fact jpf
    left join company_dim cd on cd.company_id = jpf.company_id
where
    job_title_short = 'Data Analyst'
    and job_location ilike '%Indonesia%'
    and salary_year_avg is not null
order by
    salary_year_avg desc
limit
    15;
