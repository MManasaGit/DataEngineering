  

/*
create table event_status ( event_time varchar(10), status varchar(10) );
insert into event_status values ('10:01','on');
insert into event_status values ('10:02','on');
insert into event_status values ('10:03','on');
insert into event_status values ('10:04','off');
insert into event_status values ('10:07','on');
insert into event_status values ('10:08','on');
insert into event_status values ('10:09','off');
insert into event_status values ('10:11','on');
insert into event_status values ('10:12','off');

If the event have continous time with difference of 1 sec then consider this as 1 event. Write a query to get the start time and end time of a event.

*/
with test 
as
(
select EVENT_TIME, [STATUS], lag(status,1,status) over (order by event_time) as prev_status 
from event_status
), 
final_cte as 
(
select EVENT_TIME, [STATUS], prev_status, 
sum( case when (status = 'on' and prev_status = 'off' ) 
then 1 else 0 end) over(order by event_time) as group_key from test
)
select min(event_time) start_time, max(event_time) end_time, count(group_key)-1 as times
from final_cte group by group_key order by start_time,end_time

--OR

SELECT MIN(event_time) MIN_Event, MAX(event_time) MAX_Event FROM 
(
	SELECT event_time, SUM(R) OVER(ORDER BY event_time) R FROM
	(
	SELECT event_time,CASE WHEN ISNULL(LAG([status]) OVER(ORDER BY event_time),'off') = 'Off'  
					   AND [status] = 'ON' THEN 1 ELSE 0 END r
	FROM event_status
	)TBL --GROUP BY R
)TBL1 GROUP BY R