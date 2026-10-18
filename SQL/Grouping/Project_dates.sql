  /* https://www.hackerrank.com/challenges/sql-projects/problem?h_r=next-challenge&h_v=zen
You are given a table, Projects, containing three columns: Task_ID, Start_Date and End_Date. It is guaranteed that the difference between the End_Date and the Start_Date is equal to 1 day for each row in the table.



If the End_Date of the tasks are consecutive, then they are part of the same project. Samantha is interested in finding the total number of different projects completed.

Write a query to output the start and end dates of projects listed by the number of days it took to complete the project in ascending order. If there is more than one project that have the same number of completion days, then order by the start date of the project.

Sample Input



Sample Output

2015-10-28 2015-10-29
2015-10-30 2015-10-31
2015-10-13 2015-10-15
2015-10-01 2015-10-04

Explanation

The example describes following four projects:

Project 1: Tasks 1, 2 and 3 are completed on consecutive days, so these are part of the project. Thus start date of project is 2015-10-01 and end date is 2015-10-04, so it took 3 days to complete the project.
Project 2: Tasks 4 and 5 are completed on consecutive days, so these are part of the project. Thus, the start date of project is 2015-10-13 and end date is 2015-10-15, so it took 2 days to complete the project.
Project 3: Only task 6 is part of the project. Thus, the start date of project is 2015-10-28 and end date is 2015-10-29, so it took 1 day to complete the project.
Project 4: Only task 7 is part of the project. Thus, the start date of project is 2015-10-30 and end date is 2015-10-31, so it took 1 day to complete the project.
*/
--Ans
;with cte
as
(
    select *,sum(case when start_date <> end_date1 then 1 else 0 end) over(order by start_date) as gp from
    (
        select *,lag(end_date) over (order by start_date) end_date1
        from projects
    )tbl
)
select start_date,end_date from
(
    select min(start_date) as start_date,max(end_date) end_date, count(gp)-1 as dd--datediff(day,min(start_date),max(end_date)) dd
    from cte group by gp
)tbl
order by dd,start_date

--OR


SELECT MIN(Start_Date), MAX(End_Date) FROM
(
    SELECT Start_Date,End_Date,SUM(C) OVER(ORDER BY Start_Date,End_Date) R FROM
    (
        SELECT Task_id,Start_Date,End_Date,
        CASE WHEN ISNULL(LAG(End_Date,1) OVER(ORDER BY Start_Date,End_Date),GETDATE()) =  Start_Date  THEN 0 ELSE 1 END AS C 
        FROM  Projects
    )TBL
)TBL1
GROUP BY R
ORDER BY DATEDIFF(DAY,MIN(Start_Date),MAX(End_Date)), MIN(Start_Date)

