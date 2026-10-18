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

select ISNULL(be.[name],'Anonymous') [name],ISNULL(sum(amount),'0') amount from
benefactors be full outer join
(
	select * from
	donations do where [YEAR] = 2015
)tbl
on be.id = tbl.benefactorId
group by [name]

--or


SELECT ISNULL(b.[name],'Anonymus') [name],
ISNULL(SUM(CASE WHEN [YEAR] = 2015 THEN AMOUNT END),0) Charity_amount
FROM benefactors B full OUTER JOIN donations D
ON B.id = D.benefactorId
GROUP BY b.id,b.[name]