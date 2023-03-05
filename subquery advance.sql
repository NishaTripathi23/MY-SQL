create database demo_test2;
use demo_test2;

drop table paintings;
drop table artists;
drop table collectors;
drop table sales;


create table paintings
(
    id              int,
    name            varchar(40),
    artist_id       int,
    listed_price    float
);

create table artists
(
    id              int,
    first_name      varchar(40),
    last_name       varchar(40)
);

create table collectors
(
    id              int,
    first_name      varchar(40),
    last_name       varchar(40)
);

create table sales
(
    id                  int,
    sale_date           date,
    painting_id         int,
    artist_id           int,
    collector_id        int,
    sales_price         float
);


insert into paintings values (11,'Miracle',1,300);
insert into paintings values (12,'Sunshine',1,700);
insert into paintings values (13,'Pretty woman',2,2800);
insert into paintings values (14,'Handsome man',2,2300);
insert into paintings values (15,'Barbie',3,250);
insert into paintings values (16,'Cool painting',3,5000);
insert into paintings values (17,'Black square #1000',3,50);
insert into paintings values (18,'Mountains',4,1300);

insert into artists values (1,'Thomas','Black');
insert into artists values (2,'Kate','Smith');
insert into artists values (3,'Natali','Wein');
insert into artists values (4,'Francesco','Benelli');

insert into collectors values (101,'Brandon','Cooper');
insert into collectors values (102,'Laura','Fisher');
insert into collectors values (103,'Christina','Buffet');
insert into collectors values (104,'Steve','Stevenson');

insert into sales values (1001,'2021-11-01',13,2,104,2500);
insert into sales values (1002,'2021-11-10',14,2,102,2300);
insert into sales values (1003,'2021-11-10',11,1,102,300);
insert into sales values (1004,'2021-11-15',16,3,103,4000);
insert into sales values (1005,'2021-11-22',15,3,103,200);
insert into sales values (1006,'2021-11-22',17,3,103,50);

-- SUBQUERY: Subquery is a query inside a query. Also referred to as inner query.
-- Types of subquery:
-- Scalar subquery
    -- > Returns 1 row and 1 column
-- Multirow subquery:
    -- > a) Returns multiple rows and 1 column
    -- > b) Returns multiple rows and multiple column
-- Correlated subquery
    -- > a subquery which depends on the outer query.
    
    -- Order of execution in SQL:
-- SELECT      -- 6
-- FROM        -- 1
-- JOIN        -- 2
-- WHERE       -- 3
-- GROUP BY    -- 4
-- HAVING      -- 5
-- ORDER BY    -- 7
-- LIMIT       -- 8
    
-- 1) Fetch paintings that are priced higher than the average painting price.
select * from paintings;

select *
from paintings
where listed_price > (select avg(listed_price) from paintings) -- this is an example of scalar query --

-- 2) Fetch all collectors who purchased paintings.
select * from collectors;
select * from sales;

select *
from collectors
where id in (select collector_id from sales);

select distinct c.*
from collectors c
join sales s on s.collector_id = c.id

-- 3) Fetch the total amount of sales for each artist who has sold at least one painting.
-- Display artist name and total sales amount
select * from artists
Select * from sales;
select a.id, a.first_name, a.last_name
from sales s
join artists a on s.artist_id = a.id

select a.*, x.total_amt
from artists a
join  (select artist_id, sum(sales_price) total_amt
       from sales s
       group by artist_id) x
    on x.artist_id = a.id;
    
-- 4) Fetch the total amount of sales for each artist who has sold either 1 or 2 paintings only.
-- Display also the no of paintings sold.
select * from artists;
select * from sales;


select s.artist_id, a.first_name, a.last_name, sum(sales_price), count(1)
from sales s
join artists a on s.artist_id = a.id
group by s.artist_id, a.first_name, a.last_name
having count(1) between 1 and 2

select s.artist_id, a.first_name, a.last_name, sum(sales_price), count(s.artist_id)
from sales s
join artists a on s.artist_id = a.id
group by s.artist_id, a.first_name, a.last_name
having count(s.artist_id) between 1 and 2

5) Find the names of the artists who had zero sales.
select *
from artists a
where not exists (select artist_id from sales s
                  where s.artist_id = a.id);
                  
-- 6) Suppose you insert the below 2 records to the artists table. Write a query to identify the duplicate artists.
    insert into artists values (5,'Kate','Smith');
    insert into artists values (6,'Natali','Wein');

select * from artists;
select concat(first_name, ' ', last_name) as full_name, count(*)
from artists
group by full_name
having count(*) > 1;

select first_name, last_name
from artists
group by  first_name, last_name

ASSIGNMENTS:
7) How would you delete the duplicate records in artists table?
select * from artists;

delete from artists
where id in (
              select id
              from artists
              group by first_name, last_name
              having count(*) > 1
              ); -- this will not work in My SQL workbench

-- self join --
select * from artists;

delete a1 from artists a1
join artists a2 on a1.first_name = a2.first_name 
and a1.last_name = a2.last_name
where a1.id > a2.id;

select * from artists;
             
delete a from artists a
join artists b
where a.id > b.id
and a.first_name = b.first_name
and a.last_name = b.last_name;

-- using window function: -- creates Windows/Partitions
select *
, row_number() over()  as single_part
, row_number() over(partition by first_name order by first_name)  as rn_with_partitions
from artists;

delete from artists
where id in (select id
            from (select *
                , row_number() over(partition by first_name, last_name )  as rn
                from artists) x
            where rn > 1);
            
-- Imagine a table with 1M records and 10k duplicate records. How to delete faster?
    insert into artists values (2,'Kate','Smith');
    insert into artists values (3,'Natali','Wein');
-- Option 1:
select * from artists; -- 6 records
select * from artists_bkp; -- 4 records

create table artists_bkp as
select distinct * from artists;

truncate table artists;

insert into artists
select * from artists_bkp;

drop table artists_bkp;
select * from artists;
-- option 2 --

create table artists_bkp as
select distinct * from artists;

drop table artists;
alter table artists_bkp rename to artists;
select * from artists; -- not recommended --

8) For each collector, calculate the number of paintings purchased