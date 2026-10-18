/*
CREATE TABLE  int_orders  (
   order_number     int   NOT NULL,
   order_date     date   NOT NULL,
   cust_id     int   NOT NULL,
   salesperson_id     int   NOT NULL,
   amount     float   NOT NULL
) ;


INSERT INTO  int_orders  VALUES (30, to_date('1995-07-14','yyyy-mm-dd'), 9, 1, 460);
 
INSERT into  int_orders  VALUES (10, to_date('1996-08-02','yyyy-mm-dd'), 4, 2, 540);

INSERT INTO  int_orders  VALUES (40, to_date('1998-01-29','yyyy-mm-dd'), 7, 2, 2400);

INSERT INTO  int_orders  VALUES (50, to_date('1998-02-03','yyyy-mm-dd'), 6, 7, 600);

INSERT into  int_orders  VALUES (60, to_date('1998-03-02','yyyy-mm-dd'), 6, 7, 720);

INSERT into  int_orders  VALUES (70, to_date('1998-05-06','yyyy-mm-dd'), 9, 7, 150);

INSERT into  int_orders  VALUES (20, to_date('1999-01-30','yyyy-mm-dd'), 4, 8, 1800);




select * from Production.Products p2
*/

--get the min unitprice of each categoryid
--WAY -1
SELECT productid,productname,supplierid,p1.categoryid,p1.unitprice,discontinued,p1.categoryid,
p1.unitprice
FROM Production.Products p1,
(
	SELECT categoryid,MIN(unitprice) OVER(PARTITION BY categoryid ORDER BY categoryid) unitprice
	FROM Production.Products p2
)p2 WHERE p1.categoryid = p2.categoryid and p1.unitprice = p2.unitprice
GROUP BY productid,productname,supplierid,p1.categoryid,p1.unitprice,discontinued,p1.categoryid,
p1.unitprice

--WAY -2
;WITH cte
AS
(
	SELECT *,ROW_NUMBER() OVER(PARTITION BY categoryid ORDER BY unitprice)R
	FROM Production.Products p2
)
SELECT * FROM cte
WHERE R = 1

--WAY -3 

SELECT * FROM Production.Products p1 
WHERE  unitprice IN
(
	SELECT MIN(unitprice) FROM Production.Products P2
	WHERE p1.categoryid = P2.categoryid
)

--OR

SELECT * FROM Production.Products p1 
WHERE  
(
	SELECT COUNT(unitprice) FROM Production.Products P2
	WHERE p2.categoryid = p1.categoryid AND P2.unitprice <= p1.unitprice
) = 1


---DIFFERENCE BETWEEN ABOVE 3 WAYS
--WAY - 1
--VERY COSTLY AS IT USED WINDOW FUNCTION, JOINS AND GROUP BY 
--WAY - 2
--COMPARITIVELY LESS COSTLY AS IT HAVE ONLY ONE WINDOW FUNCTION AND A CTE BUT NO GROUP BY AND JOINS
--WAY -3
--VERY LESS COST AS IT HAVE NOT GROUP BY , NO JOIN, NO WINDOW FUNCTION

--------------------------------------------

--2. get the highest value of amount for each salesperson_id
--WAY -1
;WITH cte
as
(
	SELECT order_number,order_date,cust_id,salesperson_id,amount,
	ROW_NUMBER() OVER(PARTITION BY salesperson_id ORDER BY amount DESC)r FROM int_orders
)
SELECT * FROM cte WHERE r = 1

--WAY - 2

SELECT order_number,order_date,cust_id,salesperson_id,amount FROM int_orders i1
WHERE amount IN
(
	SELECT MAX(amount) FROM int_orders i2 WHERE i1.salesperson_id = i2.salesperson_id
)

-- OR
SELECT order_number,order_date,cust_id,salesperson_id,amount FROM int_orders i1 
WHERE
(
	SELECT COUNT(amount) FROM int_orders i2 WHERE i1.salesperson_id = i2.salesperson_id
	AND i2.amount >= i1.amount
) = 1
