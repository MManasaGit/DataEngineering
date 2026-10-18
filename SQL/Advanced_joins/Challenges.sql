--https://www.hackerrank.com/challenges/challenges/problem?isFullScreen=false

;WITH CTE
AS
(
    SELECT H.Hacker_Id,H.Name,COUNT(C.Challenge_Id) C
    FROM Challenges C, Hackers H
    WHERE C.Hacker_Id = H.Hacker_Id
    GROUP BY H.Hacker_Id,H.Name
),
CTE1 AS
(
    SELECT C FROM CTE 
    GROUP BY C 
    HAVING COUNT(C) = 1
)
SELECT Hacker_Id,Name,C FROM CTE WHERE C = (SELECT MAX(C) FROM CTE)
UNION
SELECT Hacker_Id,Name,C FROM CTE WHERE C IN (SELECT C FROM CTE1)
ORDER BY C DESC, Hacker_Id

