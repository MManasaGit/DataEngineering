Question :https://www.hackerrank.com/challenges/full-score/problem?isFullScreen=false

select CAST(h.hacker_id as varchar(max))+'  '+name from 
(
select hacker_id,max(r) r from 
(
    select hacker_id,row_number() over(partition by hacker_id order by hacker_id)r from
    (
        select distinct s.submission_id,s.hacker_id,s.Challenge_id,s.Score,c.Difficulty_level,d.score     as max_score from
        Submissions s, Challenges c, Difficulty d
        where s.Challenge_Id = c.Challenge_id
        and c.difficulty_level = d.difficulty_level
    )tbl where score = max_score
)tbl1 group by  hacker_id
)tbl2,Hackers h 
where h.hacker_id = tbl2.hacker_id
and r <>1
order by r desc,h.hacker_id

--The above and below query gives the same output. 
--The difference is that to find the count of the hacker_id who achived maximum score we have used row_number with partition by clause.
--Partition by clause will actually get the row number for each hacker_id and we used group by caluse to get the max number group by each hacker_id
--Thus, we have retrived number of hacker ids who have score maximum marks for more that one time used row_number <> 1
--All the above can be achived just by using the group by hacker id having count(hackerId) > 1 caluse as shown below

SELECT s.hacker_id, h.name
FROM submissions s
INNER JOIN challenges c
ON s.challenge_id = c.challenge_id
INNER JOIN difficulty d
ON d.difficulty_level = c.difficulty_level
INNER JOIN hackers h
ON h.hacker_id = s.hacker_id
WHERE s.score = d.score
GROUP BY s.hacker_id, h.name
HAVING count(h.name) > 1
ORDER BY count(h.name) DESC, s.hacker_id ASC