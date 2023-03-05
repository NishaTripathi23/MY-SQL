-- JOINS
INNER JOIN / JOIN
LEFT OUTER JOIN / LEFT JOIN
RIGHT OUTER JOIN / RIGHT JOIN
FULL OUTER JOIN / FULL JOIN
NATURAL JOIN
CROSS JOIN
SELF JOIN

INNER JOIN --> Returns matching records
LEFT JOIN  --> INNER JOIN + Returns records present only in LEFT table (based on the join condition).
RIGHT JOIN --> INNER JOIN + Returns records present only in RIGHT table (based on the join condition).
FULL JOIN  --> INNER JOIN + LEFT JOIN + RIGHT JOIN

-- JOINS
INNER JOIN / JOIN
LEFT OUTER JOIN / LEFT JOIN
RIGHT OUTER JOIN / RIGHT JOIN
FULL OUTER JOIN / FULL JOIN
NATURAL JOIN
CROSS JOIN
SELF JOIN

INNER JOIN --> Returns matching records
LEFT JOIN  --> INNER JOIN + Returns records present only in LEFT table (based on the join condition).
RIGHT JOIN --> INNER JOIN + Returns records present only in RIGHT table (based on the join condition).
FULL JOIN  --> INNER JOIN + LEFT JOIN + RIGHT JOIN


create database NT_joins;
use NT_joins;

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
insert into paintings values (19,'Sunset',10,2300);
insert into paintings values (20,'Sea Front',11,1600);

insert into artists values (1,'Thomas','Black');
insert into artists values (2,'Kate','Smith');
insert into artists values (3,'Natali','Wein');
insert into artists values (4,'Francesco','Benelli');
insert into artists values (5,'Nicholas','Smith');
insert into artists values (6,'Perl','Hoon');

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

-- 1) Fetch names of all the artists along with their painting name.
  --  If an artist does not have a painting yet, display as "NA"
  
select * from artists;
select * from collectors;
select * from paintings;
select * from sales;

select concat(a.first_name, ' ', a.last_name) as full_name,
case
    when p.name is null then 'NA'
    else p.name
    end as painting_name
from paintings p
right join artists a on p.artist_id = a.id;

select concat(a.first_name, ' ', a.last_name) as full_name,
case
    when p.name is null then 'NA'
    else p.name
    end as painting_name
from artists a
right join paintings p on a.id = p.artist_id;

select concat(a.first_name, ' ', a.last_name) as full_name,
coalesce(p.name, 'NA') as painting_name
from artists a
left join paintings p on a.id = p.artist_id;

-- 2) Find collectors who did not purchase any paintings.
select * from paintings;
select * from collectors;
select * from sales;

select c.first_name, c.last_name, s.collector_id
from sales s
right join collectors c on s.collector_id = c.id
where s.collector_id is null;

-- 3) Find how much each artist made from sales. And how many paintings did they sell.
select * from artists;
select * from sales;
select a.id, a.first_name, a.last_name, sum(sales_price), count(s.artist_id)
from artists a
join sales s on a.id = s.artist_id
group by a.id;

-- Display all the available paintings and all the artist. If a painting was sold then mark them as "Sold".
  --  and if more than 1 painting of an artist was sold then display a "**" beside their name.
select * from paintings;
select * from artists;
select * from sales;

select p.*, a.*
from paintings p 
left join artists a on p.artist_id = a.id
union  
select p.*, a.*
from paintings p 
right join artists a on p.artist_id = a.id
union
select p.*
from paintings p
left join sales s on s.painting_id = p.id;

-- 3) Find how much each artist made from sales. And how many paintings did they sell.
    select first_name, sum(sales_price) , count(1)
    from sales s
    join artists a on a.id = s.artist_id
    group by first_name ;


    select first_name, sum(sales_price) , count(1)
    from sales s
    natural join artists a
    group by first_name ;

    -- alter table artists rename column id to artist_id;
alter table artists
rename column id to artist_id;

-- for natural join, the column name should be same -- 


6) Using CROSS Join:

select * 
from artists a
cross join sales s;

    select p.name as painting_name, a.first_name
    from paintings p
    cross join (select * from artists where first_name='Kate') a ;

    table 1     table 2
    row 1       row 1
    row 2       row 2
    row 3       row 3

-- Non ANSI way of joining tables.
select * from paintings,sales;

-- ANSI way of joining tables.
select * from paintings cross join sales;


6) Using CROSS Join:

    select p.name as painting_name, a.first_name
    from paintings p
    cross join (select * from artists where first_name='Kate') a ;

    table 1     table 2
    row 1       row 1
    row 2       row 2
    row 3       row 3

-- Non ANSI way of joining tables.
select * from paintings,sales;

-- ANSI way of joining tables.
select * from paintings cross join sales;

create table table_1
(id int);

create table table_2
(id int);

insert into table_1 values (1),(1),(1),(2),(3),(3),(3);
insert into table_2 values (1),(1),(2),(2),(4),(null);

select * from table_1;
select * from table_2;

select * from table_1, table_2;

select *
from table_1 t1
join table_2 t2 on  t1.id = t2.id;

select *
from table_1 t1
join table_2 t2 on  t1.id = t2.id;

select *
from table_1 t1
left join table_2 t2 on  t1.id = t2.id;

select *
from table_1 t1
right join table_2 t2 on  t1.id = t2.id;