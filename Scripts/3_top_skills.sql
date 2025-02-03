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