/*
1. What are the top-paying jobs for my role?
- top 15 high paying data-analyst job that is available remotely.
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
left join company_dim cd on
	cd.company_id = jpf.company_id
where
	job_title_short = 'Data Analyst'
	and job_location ilike '%Indonesia%'
	and salary_year_avg is not null
order by
	salary_year_avg desc
limit 15;

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

/*
3. What are the most in-demand skills for my role?
 - display the top 10 skills by their demand for data analyst.

Why?
- helps us curate skills to learn (again) :)
*/

with data_analyst_jobs as (
select
	skill_id,
	count(skill_id) as skill_count
from
		job_postings_fact jpf
inner join skills_job_dim sjd on
	sjd.job_id = jpf.job_id
where
		job_title_short = 'Data Analyst'
	and job_location ilike '%indonesia%'
group by
	skill_id
)
select
	daj.skill_id,
	skills as skill_name,
	skill_count,
	"type"
from
	data_analyst_jobs daj
inner join skills_dim sd on
	sd.skill_id = daj.skill_id
order by
	skill_count desc ;

-- alternative
SELECT
    sd.skills AS skill_name,
    COUNT(*) AS skill_count,
    sd.type
FROM
    job_postings_fact jpf
INNER JOIN
    skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN
    skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Analyst'
    AND jpf.job_location ILIKE '%indonesia%'
GROUP BY
    sd.skills, sd."type"
ORDER BY
    skill_count DESC;

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

/*
5. What are the most optimal skills to learn?
	a. Optimal: High Demand AND High Paying
- target skills in high deman and associated with nice salary.
- concentrate on jobs located in Indonesia.

 Why?
 - So we can better curate skills we should learn
*/

with skills_salary as (
	select
		sd.skill_id,
		skills as skill_name,
		round(
			avg(salary_year_avg),
			0
		)as monetary
	from
		job_postings_fact jpf
	inner join skills_job_dim sjd on
		sjd.job_id = jpf.job_id
	inner join skills_dim sd on
		sd.skill_id = sjd.skill_id
	where
		-- job_location ilike '%Indonesia%'
		job_title_short = 'Data Analyst'
		and salary_year_avg is not null
	group by
		sd.skill_id
),
skills_demand as (
	select
		sd.skill_id,
		skills as skill_name,
		count(sjd.job_id) as demand_count
	from
		job_postings_fact jpf
	inner join skills_job_dim sjd on
		sjd.job_id = jpf.job_id
	inner join skills_dim sd on
		sd.skill_id = sjd.skill_id
	where
		-- job_location ilike '%Indonesia%'
		job_title_short = 'Data Analyst'
		and salary_year_avg is not null
	group by
		sd.skill_id
)
select
	ss.skill_id,
	ss.skill_name,
	demand_count,
	monetary
from
	skills_salary ss
inner join skills_demand sd on
	sd.skill_id = ss.skill_id
order by ss.skill_id;


-- alternative
select
	sd.skill_id,
	skills as skill_name,
	count(sd.skill_id) as demand_count,
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
