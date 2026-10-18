

--Find the time of response for every query

;with cte
as
(
	select *,ROW_NUMBER() OVER(PARTITION BY customer_event_id order by date_of_action)r
	from query_text
	--order by customer_event_id
)
select customer_event_id,cast(secn as time) time_taken into #temp  from
(
	SELECT *,
		cast(
			concat(
				DATEDIFF(MINUTE,t,date_of_action)/60,':',
				DATEDIFF(MINUTE,t,date_of_action)%60,':',
				DATEDIFF(SECOND,t,date_of_action)%60
				)
			 as time
			 ) 
		AS secn FROM
	(
		SELECT *,LAG(date_of_action) OVER(PARTITION BY customer_event_id ORDER BY date_of_action)t
		FROM cte
		where customer_event_id in 
		(	
			select distinct customer_event_id from cte
			where r > 1
		)and r < 3 
	)tbl where t is not null
)tbl1
--select dateadd(minute,+36,DATEADD(HOUR,+7,cast('2022-06-07 06:49:51.4000000' as datetime2)))

------------------------------------

--Average time taken for response up to date in hrs
;with cte
as
(
	select *,ROW_NUMBER() OVER(PARTITION BY customer_event_id order by date_of_action)r
	from query_text
	--order by customer_event_id
)
select ROUND(AVG(hrs),2) from
(
	SELECT *,DATEDIFF(MINUTE,t,date_of_action)/60.0 Hrs FROM
	(
		SELECT *,LAG(date_of_action) OVER(PARTITION BY customer_event_id ORDER BY date_of_action)t
		FROM cte
		where customer_event_id in 
		(	
			select distinct customer_event_id from cte
			where r > 1
		)and r < 3 
	)tbl --where t is not null
)tbl1

----------------------------------------

--Agent with maximum queries attended

;with cte 
as
(
	select *,ROW_NUMBER() OVER(PARTITION BY customer_event_id,agent_id order by date_of_action)r
	from query_text
)
select  from cte
where r = 2