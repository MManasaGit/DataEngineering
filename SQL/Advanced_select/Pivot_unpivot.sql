--UNPIVOT
select [name],[sub],[marks] from
(
select * from studnt
)tbl
unpivot
(
marks for sub in ([eng],[maths],[sci])
)pvt
----------------------------------------------

Declare @coalesce varchar(max)
Declare @sqlserver varchar(max)

select 
@coalesce = coalesce(@coalesce+'],[','')+[name] from sys.all_columns 
where object_id = object_id('studnt') and [name] <> 'name'

print(@coalesce)

set @sqlserver  = '
select [name],[marks],[sub] from
(
	select * from studnt
)tbl
unpivot
(
marks for sub in(['+@coalesce+'])
)pvt'

exec(@sqlserver)

----------------------------------------

select [name],'eng' as sub,eng from studnt
union all
select [name],'maths' as maths,[maths] from studnt
union all
select [name],'sci' as sci,[sci] from studnt


--------------------------------------------------------------------------
--PIVOT 

CREATE TABLE TAB
(
	PLANT INT,
	[MONTH] VARCHAR(10),
	[VALUE] INT
)

INSERT INTO TAB VALUES(101,'JAN',20),(101,'FEB',40),(101,'MAR',50),
(102,'JAN',30),(102,'FEB',10),(102,'MAR',20),
(103,'JAN',50),(103,'FEB',50),(103,'MAR',50)

SELECT PLANT,MIN(JAN) JAN,MIN(FEB) FEB,MIN(MAR) MAR FROM
(
	SELECT PLANT,
	CASE WHEN [MONTH] = 'JAN' THEN [VALUE] ELSE NULL END AS JAN,
	CASE WHEN [MONTH] = 'FEB' THEN [VALUE] ELSE NULL END AS FEB,
	CASE WHEN [MONTH] = 'MAR' THEN [VALUE] ELSE NULL END AS MAR
	FROM TAB
)TBL GROUP BY PLANT

--OR

DECLARE @COALESCE VARCHAR(MAX)
DECLARE @SQLSERVER NVARCHAR(MAX)

SELECT @COALESCE = COALESCE(@COALESCE+'],[','')+[MONTH] FROM 
(
	SELECT DISTINCT [MONTH] FROM TAB
)TBL

SET @SQLSERVER = '
SELECT PLANT,['+@COALESCE+'] FROM
(
	SELECT PLANT,[MONTH],[VALUE] FROM TAB
)TBL
PIVOT
(
	MAX([VALUE]) FOR[MONTH] IN(['+@COALESCE+'])
)PVT'

EXEC(@SQLSERVER)