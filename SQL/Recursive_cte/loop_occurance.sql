
"""
Order Id Item   Qty
O1       A1      5
O2       A2      1
O3       A3      3
"""

/*
create table t
(Order_Id varchar(2), 
 Item varchar(2), Qty int);

insert into t(Order_Id,Item,Qty) 
values ('O1','A1',5);


insert into t(Order_Id,Item,Qty)
 values ('O2','A2',1);


insert into t(Order_Id,Item,Qty)
 values ('O3','A3',3);
--Write a query to repeat the Item based on the number of Qty. Example: Item A1 have Qty 5 then repeat the same like O1,A1,1 as 5 times.
*/

;with cte as
(
	select Order_Id,Item,Qty,1 as val from t
	union all
	select t.Order_Id,t.Item,c.Qty-1,val from  cte c, t
	where c.Order_Id = t.Order_id
	and c.qty > 1
)
select Order_Id,Item,val from cte 
order by item,qty desc

--OR

;with cte
as
(
	select order_id,item,1 as unit,qty from t
	union all
	select order_id,item,1 as unit,qty-1 from cte
	where qty > 1
)
select order_id,item,unit from cte
order by order_id