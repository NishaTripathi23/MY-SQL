-- ways to identify duplicate values;
select expr1, expr2, count(*)
from table_name
group by expr1, expr2
having count(*) > 1

-- Scenario 1: Data duplicated based on SOME of the columns 
create database duplicates;
use duplicates;

drop table if exists cars;
create table if not exists cars
(
    id      int,
    model   varchar(50),
    brand   varchar(40),
    color   varchar(30),
    make    int
);
insert into cars values (1, 'Model S', 'Tesla', 'Blue', 2018);
insert into cars values (2, 'EQS', 'Mercedes-Benz', 'Black', 2022);
insert into cars values (3, 'iX', 'BMW', 'Red', 2022);
insert into cars values (4, 'Ioniq 5', 'Hyundai', 'White', 2021);
insert into cars values (5, 'Model S', 'Tesla', 'Silver', 2018);
insert into cars values (6, 'Ioniq 5', 'Hyundai', 'Green', 2021);

select * from cars;

-- Requirement: Delete duplicate data from cars table. Duplicate record is identified based on the model and brand name.
select brand, model, count(*)
from cars
group by brand, model
having count(*) > 1

-- solutions to remove duplicate data --
-- SOLUTION 1: Delete using Unique identifier --
select * from cars;

delete from cars
where id in (select max(id)
              from cars
			  group by brand, model
              having count(*) > 1); -- this will not work in MY SQL workbench --

delete from cars
where id in (select max(id)
              from cars
              group by model, brand
              having count(1) > 1); -- this will not work in MY SQL workbench --
              
-- in My SQL workbench you need to use self join --
-- self join --
select * from cars;
delete c1 from cars c1
join cars c2 on c1.model = c2.model and c1.brand = c2.brand
where c1.id > c2.id;

set sql_safe_updates = 0
select * from cars;

delete c1 from cars c1            
join cars c2 on c1.model = c2.model and c1.brand = c2.brand
where c1.id < c2.id;
select * from cars;
