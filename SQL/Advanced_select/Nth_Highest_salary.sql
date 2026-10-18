
declare @n int = 6 --th highest salary

select * from jio where salary in 
(
select top(1) salary from
(
	select top(@n) salary from jio group by salary order by salary desc
)tbl order by salary
)