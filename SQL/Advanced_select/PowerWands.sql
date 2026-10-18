https://www.hackerrank.com/challenges/harry-potter-and-wands/problem?isFullScreen=false

select id,age,coins_needed,power from
(
    select w.id,p.age,w.coins_needed,w.power,Row_number() over(partition by p.age,w.power order by     coins_needed)r from wands w, wands_property p
    where w.code = p.code
    and is_evil = 0
    --and age = 318
)tbl
where r = 1
order by power desc, age desc