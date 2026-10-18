/*
https://www.hackerrank.com/challenges/symmetric-pairs/problem?isFullScreen=false&h_r=next-challenge&h_v=zen

create table functions
(
	x int,
	y int
)

-------------------------

insert into functions values(20,20),(20,20),(20,21),(23,22),(22,23),(21,20)

---------------------------
insert into functions values
(86,86),
(27,27),
(45,45),
(95,95),
(11,11),
(18,8),
(85,85),
(2,2),
(77,77),
(91,91),
(15,15),
(84,84),
(51,51),
(32,32),
(35,35),
(8,8),
(92,92),
(67,67),
(62,62),
(33,33),
(13,13),
(15,11),
(18,18),
(3,3),
(38,38),
(80,80),
(34,34),
(6,6),
(72,72),
(14,12),
(44,44),
(4,22),
(90,90),
(47,47),
(78,78),
(23,3),
(42,42),
(56,56),
(79,79),
(55,55),
(65,65),
(17,17),
(64,64),
(4,4),
(28,28),
(19,19),
(17,9),
(36,36),
(25,25),
(81,81),
(60,60),
(48,48),
(5,5),
(88,88),
(7,19),
(21,21),
(29,29),
(52,52),
(9,17),
(9,9),
(13,13),
(16,10),
(1,1),
(31,31),
(46,46),
(7,7),
(58,58),
(23,23),
(87,87),
(83,83),
(66,66),
(93,93),
(24,2),
(98,98),
(53,53),
(20,6),
(61,61),
(20,20),
(96,96),
(99,99),
(73,73),
(2,24),
(14,14),
(71,71),
(5,21),
(22,4),
(75,75),
(6,20),
(97,97),
(41,41),
(26,26),
(22,22),
(8,18),
(74,74),
(40,40),
(21,5),
(94,94),
(76,76),
(49,49),
(11,15),
(59,59),
(89,89),
(68,68),
(24,24),
(37,37),
(12,12),
(63,63),
(43,43),
(16,16),
(100,100),
(39,39),
(25,1),
(69,69),
(54,54),
(50,50),
(30,30),
(10,10)

Find the symmetric values in the above given list where x1 = y2 and x2 = y1. Need to check this values through out the list

*/


SELECT f1.X, f1.Y FROM Functions f1
INNER JOIN Functions f2 ON f1.X=f2.Y AND f1.Y=f2.X
GROUP BY f1.X, f1.Y
HAVING COUNT(f1.X)>1 or f1.X<f1.Y
ORDER BY f1.X 

--OR

;WITH CTE 
AS
(
    SELECT X,Y,ROW_NUMBER() OVER(ORDER BY X) R FROM Functions
)
SELECT C.X,C.Y FROM 
CTE C, CTE C1
WHERE C.R <> C1.R
AND C.X = C1.Y
AND C.Y = C1.X
AND C.X <= C.Y
GROUP BY  C.X,C.Y
ORDER BY C.X

--This above two codes can be used to solve this problem like comparing the symmetric through out the table where as if we want 
--to make the comaprission of symmetric paris between current line and the very next line then below code can be used

;WITH CTE
AS
(
       SELECT ROW_NUMBER() OVER(ORDER BY X)R,X,Y FROM A
)
SELECT X,Y FROM
(
       SELECT *,LEAD(X,1) OVER(ORDER BY R) AS X2,
       LEAD(Y,1) OVER(ORDER BY R) AS Y2 FROM CTE
)R WHERE X = Y2 AND Y = X2 AND X <= Y