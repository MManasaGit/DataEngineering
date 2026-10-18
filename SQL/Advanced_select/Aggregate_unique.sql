
/*
 create table  agg2( day date, sales_amount int);
 
 insert into   agg2 values ( to_date('2022-05-09', 'yyyy-mm-dd'),   340);
 insert into   agg2 values ( to_date('2022-06-09', 'yyyy-mm-dd'),   340);
 insert into   agg2 values ( to_date('2022-07-09', 'yyyy-mm-dd'),   340);
 insert into   agg2 values ( to_date('2022-08-09', 'yyyy-mm-dd'),   340);
 insert into   agg2 values ( to_date('2022-09-09', 'yyyy-mm-dd'),   340);
 insert into   agg2 values ( to_date('2022-10-09', 'yyyy-mm-dd'),   340);
 insert into   agg2 values ( to_date('2023-01-09', 'yyyy-mm-dd'),   340);
 insert into   agg2 values ( to_date('2023-02-09', 'yyyy-mm-dd'),   340);
 insert into   agg2 values ( to_date('2024-01-09', 'yyyy-mm-dd'),   340);
 insert into   agg2 values ( to_date('2024-02-09', 'yyyy-mm-dd'),   340);
 
 Write a query to find the running sum of sales_amount for each unique YEAR,MONTH Combination
 
*/



 SELECT YEAR([DAY]),DATENAME(MONTH,[DAY]),
 SUM(sales_amount) OVER(PARTITION BY YEAR([DAY]) ORDER BY YEAR([DAY]),DATENAME(MONTH,[DAY])
 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
 FROM agg2
 ORDER BY YEAR([DAY]),DATENAME(MONTH,[DAY])