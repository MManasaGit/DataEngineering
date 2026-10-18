--https://www.hackerrank.com/challenges/contest-leaderboard/problem?h_r=next-challenge&h_v=zen

SELECT Hacker_Id,Name,SUM(Score) Score FROM
(
    SELECT H.Hacker_Id,H.Name,S.Challenge_Id,MAX(S.Score) Score
    FROM Submissions S, Hackers H
    WHERE S.Hacker_Id = H.Hacker_Id
    --AND H.Hacker_Id = '52878'
    GROUP BY H.Hacker_Id,H.Name,S.Challenge_Id
)TBL 
GROUP BY Hacker_Id,Name
HAVING  SUM(Score) <> 0
ORDER BY Score DESC,Hacker_Id