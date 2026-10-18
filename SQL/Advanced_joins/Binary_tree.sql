/*You are given a table, BST, containing two columns: N and P, where N represents the value of a node in Binary Tree, and P is the parent of N.



Write a query to find the node type of Binary Tree ordered by the value of the node. Output one of the following for each node:

Root: If node is root node.
Leaf: If node is leaf node.
Inner: If node is neither root nor leaf node.
Sample Input



Sample Output

1 Leaf
2 Inner
3 Leaf
5 Root
6 Leaf
8 Inner
9 Leaf 

https://www.hackerrank.com/challenges/binary-search-tree-1/problem?isFullScreen=false --for problem in real time practice
*/

select * from 
(
select n,case when c is null then 'Leaf' 
    when c is not null and p is not null then 'Inner'
    else 'Root' end r from
(
    select p.*,n.n as c from bst p left outer join bst n
    on p.n = n.p
)tbl 
)tbl1
group by n,r
order by n