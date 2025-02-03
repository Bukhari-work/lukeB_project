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