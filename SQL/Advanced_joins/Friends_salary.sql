/*https://www.hackerrank.com/challenges/placements/problem?isFullScreen=false*/

;with cte
as
(
    select s.*,p.salary,f.friend_id
    from students s, packages p,friends f
    where s.id = p.id
    and f.id = s.id
)
select name from 
(
    select c.name,c.salary,m.salary as f_salary from cte c, cte m
    where c.friend_id = m.id 
)tbl
where f_salary > salary
order by f_salary

--OR

;WITH CTE 
AS
(
    SELECT S.Id,S.Name,P.Salary,F.Friend_Id
    FROM Students S, Friends F, Packages P
    WHERE S.Id  = F.Id
    AND F.Id = P.Id
)
SELECT CTE.Name FROM CTE, CTE C2
WHERE CTE.Friend_Id = C2.Id
AND CTE.Salary < C2.Salary
ORDER BY C2.Salary 