/*
4. What are the top skills based on salary for my role?
- look at the average salary associated with each skill for data analyst
- focus on roles with available salary data.

Why?
To see the monetary value of the skills :D
Reveals how different skills impact salary levels.
Which helps identify the most financially rewarding skills.
*/

select
	sd.skill_id,
	skills as skill_name,
	round(
		avg(salary_year_avg),
		0
	) as monetary
from
	job_postings_fact jpf
inner join skills_job_dim sjd on
	sjd.job_id = jpf.job_id
inner join skills_dim sd on
	sd.skill_id = sjd.skill_id
where
	job_work_from_home = true
	and job_title_short = 'Data Analyst'
	and salary_year_avg is not null
group by
	sd.skill_id
having
	count(sd.skill_id) > 10
order by
	monetary desc,
	demand_count desc;