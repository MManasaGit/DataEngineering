/*Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation. The output column headers should be Doctor, Professor, Singer, and Actor, respectively.

create table occupation
(
	[name] varchar(120),
	occupation varchar(120)
)

insert into occupation values
('samantha','doctor'),
('jilia','actor'),
('maria','actor'),
('meera','singer'),
('ashley','proffeser'),
('Kitty','proffeser'),
('christeen','proffeser'),
('jane','actor'),
('janne','Doctor'),
('priya','singer')


Sample Output

Jenny    Ashley     Meera  Jane
Samantha Christeen  Priya  Julia
NULL     Ketty      NULL   Maria
Explanation

The first column is an alphabetically ordered list of Doctor names.
The second column is an alphabetically ordered list of Professor names.
The third column is an alphabetically ordered list of Singer names.
The fourth column is an alphabetically ordered list of Actor names.
The empty cell data for columns with less than the maximum number of names per occupation (in this case, the Professor and Actor columns) are filled with NULL values.

Pivoting on two dimension like only on 2 columns instead of 3 columns, due to this reason we call it as slicing. Here the normal pivot syntax will not work.

*/



;WITH CTE 
AS
(
    select ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Occupation,Name) as Rank, 
    case when Occupation='Doctor' then Name else null end as doctor, 
    case when Occupation='Professor' then Name else null end as prof, 
    case when Occupation='Singer' then Name else null end as singer, 
    case when Occupation='Actor' then Name else null end as actor from Occupations
    
)
SELECT MIN(doctor),MIN(prof),MIN(singer),MIN(actor) FROM CTE
GROUP BY RANK

--OR (THE ABOVE CAN BE CONSIDERED AS THE PIVOT WITH PIVOT KEY WORD)

SELECT doctor,professor,singer,actor FROM
(
    SELECT [name],occupation,ROW_NUMBER() OVER(PARTITION BY occupation ORDER BY [name],occupation) R FROM occupations
)TBL
PIVOT
(
    MAX([name]) FOR[occupation] IN([professor],[actor],[singer],[doctor])
)PVT