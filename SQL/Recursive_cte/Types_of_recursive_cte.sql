
--Hirarchy of an employee
;with cte
as
(
	select emp_id,emp_name,mgr_id from rec_cte where emp_id = 1
	union all
	select e.emp_id,e.emp_name,e.mgr_id from rec_cte e, cte c
	where e.emp_id = c.mgr_id
)
select e.emp_id,e.emp_name,m.emp_name as mgr_id from cte e left outer join cte m
on e.mgr_id = m.emp_id
--------------------
--get the manager of each employee
--Self Join
select e.emp_id,e.emp_name,m.emp_name as mgr_id from rec_cte e left outer join rec_cte m
on e.mgr_id = m.emp_id

--------------------
--get the 

with cte
as
(
	select order_id,Item,Qty,1 AS Qty1 from t
	union all
	select t.order_id,t.Item,t.Qty - 1 Qty,1 AS Qty1 from CTE t
	where Qty > 1
)
select order_id,Item,Qty1 from cte order by Order_Id,Qty