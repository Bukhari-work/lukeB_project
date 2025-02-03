/*
 2. What are the skills required for the top-paying jobs?
 - use the top 15 jobs from the previous query.
 - add the specific skills

Why?
- helps us curate skills to learn :) 
*/

with top_paying_jobs as (
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
left join company_dim cd on
		cd.company_id = jpf.company_id
where
		job_title_short = 'Data Analyst'
	and job_location ilike '%Indonesia%'
	and salary_year_avg is not null
order by
		salary_year_avg desc
limit 15
)
select
	tpj.job_id, 
	job_title,
	company_name,
	salary_year_avg,
	skills
from
	top_paying_jobs tpj
inner join skills_job_dim sjd on
	sjd.job_id = tpj.job_id
inner join skills_dim sd on
	sd.skill_id = sjd.skill_id
order by salary_year_avg desc;