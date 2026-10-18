--1.

/*
-- Example case create statement:
CREATE TABLE benefactors (
  id INTEGER PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);
CREATE TABLE donations (
  id INTEGER PRIMARY KEY,
  amount INTEGER NOT NULL,
  year INTEGER NOT NULL,
  benefactorId INTEGER,
  FOREIGN KEY (benefactorId) REFERENCES benefactors(id)
);
INSERT INTO benefactors(id, name) VALUES(1, 'Phil');
INSERT INTO benefactors(id, name) VALUES(2, 'Nicholas');
INSERT INTO benefactors(id, name) VALUES(3, 'William');
INSERT INTO donations(id, amount, year, benefactorId) VALUES(1, 2000, 2014, 1);
INSERT INTO donations(id, amount, year, benefactorId) VALUES(2, 2800, 2015, 1);
INSERT INTO donations(id, amount, year, benefactorId) VALUES(3, 900, 2015, 1);
INSERT INTO donations(id, amount, year, benefactorId) VALUES(4, 1200, 2015, 2);
INSERT INTO donations(id, amount, year, benefactorId) VALUES(5, 3200, 2015, null);
INSERT INTO donations(id, amount, year, benefactorId) VALUES(6, 4000, 2015, null);
INSERT INTO donations(id, amount, year, benefactorId) VALUES(7, 2400, 2016, 2);


Write a query to get the names and sum of amount donated per each person for 2015. If the donatee name is not known then we can say them as Anonymous and get the sum of such records.
If a person have not donated that year then we need to make sure that we has 0 amount and if don't have any anonymous then we don't need to get the anonymus amount name

-- Expected output (rows in any order):
-- Name        Amount
-- --------------------
-- Phil         3700
-- Nicholas     1200
-- Anonymous	7200		
-- William      0
*/


SELECT B.id,B.[name],[year],[amount]--ISNULL(B.[name],'Anonymus'),SUM(amount)
FROM benefactors B LEFT OUTER JOIN donations D
ON B.id = D.benefactorId
AND [YEAR] = 2015


--DIFFERENCE BETWEEN 'WHERE' AND 'AND' IN OUTER JOINS
--IN THE ABOVE QUERY THE FROM/JOIN ALONG WITH 'ON' WILL EXECUTE 1ST ACCORDING TO THE EXECUTION ORDER
--AND CLAUSE WILL BE A PART OF ON AND WILL GIVE PERFECT FUNCTIONLAITY AS WE EXPECTED FROM LEFT JOIN
--NOW WHERE CLAUSE WILL EXECUTE ON TOP OF THE DATA AFTER EXECUTING ON CLAUSE
--WHICH MEANS IT WILL GET THE MATCHING RECORDS AND THEN WILL FILTER [YEAR] = 2015
--BUT HERE THE ISSUE IS THE UNMATCHED RECORDS OF THE LEFT TABLES WILL HAVE NULLS IN THE RIGHT TABLE COLUMNS
--THESE NULLS ARE NOT EQUAL TO THE 2015 AND SO THESE COLUMNS WILL NOT BE SHOWN UP IN FINAL RESULT SET
--WHERE AS AND WILL 1ST GET THE DATA FROM RIGHT TABLE WHICH MATCHES THE ON CALUSE CONDITION ALONG WITH AND CALUSE
--WHICH MEANS ALL THE CONTRIBUTOR ID THAT MATCHES WITH CONTRIBUTORS AND YEAR = 2015 WILL BE JOINED WITH THE LEFT TABLE


SELECT B.id,B.[name],[year],[amount]--ISNULL(B.[name],'Anonymus'),SUM(amount)
FROM benefactors B LEFT OUTER JOIN donations D
ON B.id = D.benefactorId
WHERE [YEAR] = 2015


--------------------------------------------

SELECT B.id,B.[name],[year],[amount]--ISNULL(B.[name],'Anonymus'),SUM(amount)
FROM benefactors B FULL OUTER JOIN donations D
ON B.id = D.benefactorId
AND [YEAR] = 2015

--ON/AND WILL GET ALL THE RECORDS RIGHT TABLE AND MATCH THEM WITH THE RECORDS OF LEFT TABLE IF THE ON/AND MATCHES
--THE RECORDS WHICH DOES NOT SATISFY THE ABOVE CONDITION WILL WILL BE GIVEN WITH NULL VALUES

SELECT B.id,B.[name],[year],[amount]--ISNULL(B.[name],'Anonymus'),SUM(amount)
FROM benefactors B FULL OUTER JOIN donations D
ON B.id = D.benefactorId
WHERE [YEAR] = 2015

-- As neither of the above can give me the required output i have choosed the below answer


SELECT ISNULL(b.[name],'Anonymus') [name],
ISNULL(SUM(CASE WHEN [YEAR] = 2015 THEN AMOUNT END),0) Charity_amount
FROM benefactors B full OUTER JOIN donations D
ON B.id = D.benefactorId
GROUP BY b.id,b.[name]

--2.

/* 
create table users
(
user_id integer,
name varchar(20),
join_date date
);

insert into users
values (1, 'Jon', CAST('2-14-20' AS date)), 
(2, 'Jane', CAST('2-14-20' AS date)), 
(3, 'Jill', CAST('2-15-20' AS date)), 
(4, 'Josh', CAST('2-15-20' AS date)), 
(5, 'Jean', CAST('2-16-20' AS date)), 
(6, 'Justin', CAST('2-17-20' AS date)),
(7, 'Jeremy', CAST('2-18-20' AS date));

create table events
(
user_id integer,
type varchar(10),
access_date date
);

insert into events values
(1, 'Pay', CAST('3-1-20' AS date)), 
(2, 'Music', CAST('3-2-20' AS date)), 
(2, 'P', CAST('3-12-20' AS date)),
(3, 'Music', CAST('3-15-20' AS date)), 
(4, 'Music', CAST('3-15-20' AS date)), 
(1, 'P', CAST('3-16-20' AS date)), 
(3, 'P', CAST('3-22-20' AS date));

Q: Get the Number of uniqueusers (Total number of user who have access music), users who have subscribed to prime video after watching the Music 
with in 30 days of join date, rate of subscription (subscribed users/unique users)*100 and round the answer by two decimal points.

UNIQUE_USERS	SUB	UNIQUE_USERS
3	            1	33.33

*/

SELECT DISTINCT COUNT(u.[user_id]) UNIQUE_USERS,
COUNT(CASE WHEN DATEDIFF(DAY,join_date,access_date) < 30 THEN u.[user_id]  END) SUB,
CAST(1.0*COUNT(CASE WHEN DATEDIFF(DAY,join_date,access_date) < 30 THEN u.[user_id]  END)/COUNT(u.[user_id])*100 AS DECIMAL(5,2))
UNIQUE_USERS
FROM users u LEFT OUTER JOIN [events] e
ON u.[user_id] = e.[user_id]
AND e.[type] = 'p' --USE WHERE AND CHECK RESULTS FOR INSTANCE
WHERE u.[user_id] IN 
(
	SELECT DISTINCT [user_id]
	FROM [events]
	WHERE [type] = 'MUSIC'
) 


--We can see the above difference only for Outer joins where as for Inner and self join we will not see difference between where and 'and'



SELECT s.hacker_id, h.name
FROM submissions s
INNER JOIN challenges c
ON s.challenge_id = c.challenge_id
INNER JOIN difficulty d
ON d.difficulty_level = c.difficulty_level
AND s.score = d.score
INNER JOIN hackers h
ON h.hacker_id = s.hacker_id
GROUP BY s.hacker_id, h.name
HAVING count(h.name) > 1
ORDER BY count(h.name) DESC, s.hacker_id ASC

-- OR THE BELOW ARE SAME

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