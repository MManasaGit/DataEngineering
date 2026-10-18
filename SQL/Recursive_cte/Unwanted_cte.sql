--Get max and min sal from emp table for each dept


DROP TABLE EMP
CREATE TABLE EMP
(
	EMPID INT,
	DEPTID INT,		
	EMPSAL MONEY
)

INSERT INTO EMP VALUES (1,101,3828),(2,101,3098),(3,101,388),
(4,102,328),(5,102,3829),(6,102,828),
(7,103,928),(8,103,8998),(9,103,7628),
(10,104,928),(11,104,298),(12,104,192)


;with maxc as
(
	select * from employees where SALARY in
	(
		select max(SALARY) from employees group by DEPARTMENT_ID
	)
),
minc as
(
	select * from employees where SALARY in 
	(
		select min(salary) from employees group by DEPARTMENT_ID
	)
) 

--the above have a lot of unwanted logic and below code can be used instead

SELECT DEPTID,MIN(EMPSAL) MIN_SAL,MAX(EMPSAL) MAX_SAL
FROM EMP
GROUP BY DEPTID


-----------------------------------------------------------------------------



 https://www.hackerrank.com/challenges/full-score/problem?isFullScreen=false

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
--The difference is that to find the count of the hacker_id who achieved maximum score we have used row_number with partition by clause.
--Partition by clause will actually get the row number for each hacker_id and we used group by clause to get the max number group by each hacker_id
--Thus, we have retrieved number of hacker ids who have score maximum marks for more that one time used row_number <> 1
--All the above can be achieved just by using the group by hacker id having count(hacker)
--We can use group and having clause instead of row_number() partition by if and only if we are having one column to group by or partition by else we must use row_number()


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