Select repo_name from `bigquery-public-data.github_repos.sample_repos` as sample
where repo_name in(
select distinct(t.repo_name) from
((SELECT repo_name FROM `bigquery-public-data.github_repos.languages`
CROSS JOIN UNNEST (`bigquery-public-data.github_repos.languages`.language)
where name = "Java" or name = "java")) as t
INNER JOIN `bigquery-public-data.github_repos.files` as q
on t.repo_name = q.repo_name and path = 'pom.xml'
where t.repo_name in
(select distinct(m.repo_name)
from `bigquery-public-data.github_repos.files`as m
where REGEXP_CONTAINS(m.path,".*/test/.*")) and t.repo_name in (
SELECT sr.repo_name FROM `bigquery-public-data.github_repos.sample_repos` as sr
where sr.watch_count>=100 ORDER BY sr.watch_count DESC
))
order by sample.watch_count DESC
