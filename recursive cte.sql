-- RECURSIVE SQL QUERIES

-- Syntax:

with recursive cte as
    (base query -- the starting point
     union / union all
     recursive part of the query -- which use the result from cte
     include a termination condition
    )
select *
from cte;


-- Q1: Display number from 1 to 10 without using any in built functions.

with recursive cte as
    (select 1 as n
    union
    select (n + 1) as n
    from cte
    where n < 10)
select *
from cte;

 -- Display even number from 1 to 20 without using any in built functions.

with recursive cte as
(select 2 as n
union
select (n+2) as n
from cte
where n<20)
select *
from cte;

 -- Display odd number from 1 to 30 without using any in built functions.
 with recursive cte as
 (select 1 as n
 union
 select (n+2) as n
 from cte
 where n<29)
 select * 
 from cte;

create database recursive_topic;

use recursive_topic;

CREATE TABLE emp_details
    (
        id           int PRIMARY KEY,
        name         varchar(100),
        manager_id   int,
        salary       int,
        designation  varchar(100)
    );
INSERT INTO emp_details VALUES (1,  'Shripadh', NULL, 10000, 'CEO');
INSERT INTO emp_details VALUES (2,  'Satya', 5, 1400, 'Software Engineer');
INSERT INTO emp_details VALUES (3,  'Jia', 5, 500, 'Data Analyst');
INSERT INTO emp_details VALUES (4,  'David', 5, 1800, 'Data Scientist');
INSERT INTO emp_details VALUES (5,  'Michael', 7, 3000, 'Manager');
INSERT INTO emp_details VALUES (6,  'Arvind', 7, 2400, 'Architect');
INSERT INTO emp_details VALUES (7,  'Asha', 1, 4200, 'CTO');
INSERT INTO emp_details VALUES (8,  'Maryam', 1, 3500, 'Manager');
INSERT INTO emp_details VALUES (9,  'Reshma', 8, 2000, 'Business Analyst');
INSERT INTO emp_details VALUES (10, 'Akshay', 8, 2500, 'Java Developer');
commit;

-- Q2: Find the hierarchy of employees under a given manager "Asha".

select * from emp_details;

Asha --> Michael --> Satya, Jia, David
Asha --> Arvind
select * from emp_details;

select e.id, e.name, m.manager_id
from emp_details e
join emp_details m on e.manager_id = m.id;  -- this will give only who is the manager of whom, but it will not create the hierarchy --

with recursive manager as
    (select id as employee_id, name as employee_name, manager_id
     from emp_details 
     where name = 'Asha'
    union
     select e.id as employee_id, e.name as employee_name, e.manager_id
     from emp_details e
     join manager on  e.manager_id = manager.employee_id 
    )
select *
from manager;

with recursive cte as
    (select id as emp_id, name as emp_name, manager_id, 1 as level
     from emp_details where name = 'Asha'
    union
     select e.id as emp_id, e.name as emp_name, e.manager_id, (level+1) as level
     from emp_details e
     join cte on cte.emp_id = e.manager_id
    )
select *
from cte;


-- 1st iteration:
select id as emp_id, name as emp_name, manager_id, 1 as level
from emp_details where name = 'Asha'

-- 2nd iteration:

select e.id as employee_id, e.name as employee_name, e.manager_id
     from emp_details e
     join (select id as employee_id, name as employee_name, manager_id
     from emp_details 
     where name = 'Asha') manager 
     on  e.manager_id = manager.employee_id 

select e.id as emp_id, e.name as emp_name, e.manager_id, (level+1) as level
from emp_details e
join (  select id as emp_id, name as emp_name, manager_id, 1 as level
        from emp_details where name = 'Asha'
     ) cte
        on cte.emp_id = e.manager_id

-- 3rd iteration:

select e.id as employee_id, e.name as employee_name, e.manager_id
     from emp_details e
     join (select e.id as employee_id, e.name as employee_name, e.manager_id
     from emp_details e
     join (select id as employee_id, name as employee_name, manager_id
     from emp_details 
     where name = 'Asha') manager 
     on  e.manager_id = manager.employee_id) manager 
     on  e.manager_id = manager.employee_id 


select e.id as emp_id, e.name as emp_name, e.manager_id, (level+1) as level
from emp_details e
join (  select e.id as emp_id, e.name as emp_name, e.manager_id, (level+1) as level
        from emp_details e
        join (select id as emp_id, name as emp_name, manager_id, 1 as level
             from emp_details where name = 'Asha') cte
                on cte.emp_id = e.manager_id
     ) cte
                    on cte.emp_id = e.manager_id

-- 4th iteration:

select e.id as employee_id, e.name as employee_name, e.manager_id
     from emp_details e
     join (select e.id as employee_id, e.name as employee_name, e.manager_id
     from emp_details e
     join (select e.id as employee_id, e.name as employee_name, e.manager_id
     from emp_details e
     join (select id as employee_id, name as employee_name, manager_id
     from emp_details 
     where name = 'Asha') manager 
     on  e.manager_id = manager.employee_id) manager 
     on  e.manager_id = manager.employee_id ) manager
     on  e.manager_id = manager.employee_id 


select e.id as emp_id, e.name as emp_name, e.manager_id, (level+1) as level
from emp_details e
join (  select e.id as emp_id, e.name as emp_name, e.manager_id, (level+1) as level
        from emp_details e
        join (  select e.id as emp_id, e.name as emp_name, e.manager_id, (level+1) as level
                from emp_details e
                join (select id as emp_id, name as emp_name, manager_id, 1 as level
                     from emp_details where name = 'Asha') cte
                        on cte.emp_id = e.manager_id
             ) cte
                            on cte.emp_id = e.manager_id
     ) cte on cte.emp_id = e.manager_id


-- What if someone has 2 managers:
insert into emp_details values (6,) -- cannot do since id is PK

-- Questions re-qrite above query to display only emp_id, emp_name and manager_name

select * from emp_details;
with recursive cte as
    (select emp.id as employee_id, emp.name as employee_name, mng.name as manager
     from emp_details emp
     join emp_details mng on emp.manager_id = mng.id
     where emp.name = 'Asha'
    union all
     select e.id as employee_id, e.name as employee_name, cte.employee_name as manager
     from emp_details e
     join cte on cte.employee_id = e.manager_id
    )
select *
from cte;



/* Q3: Find the hierarchy of managers for a given employee "David"*/
select * from emp_details;

with recursive hie as
(select emp.id as employee_id, emp.name as employee_name, emp.manager_id
from emp_details emp
where emp.name = 'David'
union all
select emp.id as employee_id, emp.name as employee_name, emp.manager_id
from emp_details emp
join hie h on h.manager_id = emp.id)
select *
from hie;

-- I iteration --
select emp.id as employee_id, emp.name as employee_name, emp.manager_id
from emp_details emp
where emp.name = 'David'

-- II iteration --
select emp.id as employee_id, emp.name as employee_name, emp.manager_id
from emp_details emp
join (select emp.id as employee_id, emp.name as employee_name, emp.manager_id
from emp_details emp
where emp.name = 'David') h 
on h.manager_id = emp.id

-- III iteration --
select emp.id as employee_id, emp.name as employee_name, emp.manager_id
from emp_details emp
join (select emp.id as employee_id, emp.name as employee_name, emp.manager_id
from emp_details emp
join (select emp.id as employee_id, emp.name as employee_name, emp.manager_id
from emp_details emp
where emp.name = 'David') h 
on h.manager_id = emp.id) h 
on h.manager_id = emp.id

-- IV iteration --
select emp.id as employee_id, emp.name as employee_name, emp.manager_id
from emp_details emp
join (select emp.id as employee_id, emp.name as employee_name, emp.manager_id
from emp_details emp
join (select emp.id as employee_id, emp.name as employee_name, emp.manager_id
from emp_details emp
join (select emp.id as employee_id, emp.name as employee_name, emp.manager_id
from emp_details emp
where emp.name = 'David') h 
on h.manager_id = emp.id) h 
on h.manager_id = emp.id) h 
on h.manager_id = emp.id

-- V iteration --
select emp.id as employee_id, emp.name as employee_name, emp.manager_id
from emp_details emp
join (select emp.id as employee_id, emp.name as employee_name, emp.manager_id
from emp_details emp
join (select emp.id as employee_id, emp.name as employee_name, emp.manager_id
from emp_details emp
join (select emp.id as employee_id, emp.name as employee_name, emp.manager_id
from emp_details emp
join (select emp.id as employee_id, emp.name as employee_name, emp.manager_id
from emp_details emp
where emp.name = 'David') h 
on h.manager_id = emp.id) h 
on h.manager_id = emp.id) h 
on h.manager_id = emp.id) h 
on h.manager_id = emp.id  -- the recursive cte terminates here --



with recursive cte as
    (select emp.id as emp_id, emp.name as emp_name, emp.manager_id
     from emp_details emp
     where emp.name = 'David'
    union all
     select e.id as emp_id, e.name as emp_name, e.manager_id
     from emp_details e
     join cte on cte.manager_id = e.id
    )
select *
from cte;


-- Re-write the above query to display the emp_name and manager -- this query needs to be modified.
select * from emp_details;
with recursive hie as
(select emp.id as employee_id, emp.name as employee_name, emp.manager_id, mng.name as manager_name
from emp_details emp
join emp_details mng on emp.manager_id = mng.id
where emp.name = 'David'
union all
select e.id as employee_id, e.name as employee_name, e.manager_id, m.name as manager_name
from emp_details e
join hie h on h.manager_id = e.id
left join emp_details m on e.manager_id = m.id)
select * 
from hie;

with recursive cte as
    (select emp.id as emp_id, emp.name as emp_name, emp.manager_id, mng.name as manager_name
     from emp_details emp
     join emp_details mng on emp.manager_id = mng.id
     where emp.name = 'David'
    union all
     select e.id as emp_id, e.name as emp_name, e.manager_id, m.name as manager_name
     from emp_details e
     join cte on cte.manager_id = e.id
     left join emp_details m on e.manager_id = m.id
    )
select *
from cte;



with recursive cte as
    (select e.id as Emp_Id, e.name as Emp_Name, e.manager_id, m.name as Manager_Name -- 1 as level
    from emp_details e
    Join emp_details m on e.id = m.Manager_id where m.name = 'David'
    union all
     select e.id as emp_id, e.name as emp_name, e.manager_id, 'none'::varchar as manager_name
     from emp_details e
     join cte on cte.manager_id = e.id
     --join emp_details m on e.manager_id = m.id
    )
select *
from cte;

/* ************************************************************************** */
-- RECURSIVE SQL Query syntax in Other RDBMS:
/* Q3: Find the hierarchy of managers for a given employee "David"*/
-- PostgreSQL
with recursive managers as
	(select id as emp_id, name as emp_name, manager_id
	 , designation as emp_role, 1 as level
	 from emp_details e where id=7
	 union
	 select e.id as emp_id, e.name as emp_name, e.manager_id
	 , e.designation as emp_role, level+1 as level
	 from emp_details e
	 join managers m on m.manager_id = e.id)
select *
from managers;

-- Oracle
with  managers (emp_id, emp_name, manager_id, designation, lvl) as
	(select id as emp_id, name as emp_name, manager_id
	 , designation as emp_role, 1 as lvl
	 from emp_details e where id=7
	 union all
	 select e.id as emp_id, e.name as emp_name, e.manager_id
	 , e.designation as emp_role, lvl+1 as lvl
	 from emp_details e
	 join managers m on m.manager_id = e.id)
select *
from managers;

-- MSSQL (Microsoft SQL Server)
with  managers (emp_id, emp_name, manager_id, designation, lvl) as
	(select id as emp_id, name as emp_name, manager_id
	 , designation as emp_role, 1 as lvl
	 from emp_details e where id=7
	 union all
	 select e.id as emp_id, e.name as emp_name, e.manager_id
	 , e.designation as emp_role, lvl+1 as lvl
	 from emp_details e
	 join managers m on m.manager_id = e.id)
select *
from managers;

-- MySQL
with recursive managers as
	(select id as emp_id, name as emp_name, manager_id
	 , designation as emp_role, 1 as level
	 from emp_details e where id=7
	 union
	 select e.id as emp_id, e.name as emp_name, e.manager_id
	 , e.designation as emp_role, level+1 as level
	 from emp_details e
	 join managers m on m.manager_id = e.id)
select *
from managers;
/* ************************************************************************** */

with recursive cte as 
(select 1 as n
union
select (n+1) as n
from cte
where n < 10)
select *
from cte

-- Q2: Find the hierarchy of employees under a given manager "Shripadh".
select * from emp_details;
with recursive manager as
    (select id as employee_id, name as employee_name, manager_id
     from emp_details 
     where name = 'Asha'
    union
     select e.id as employee_id, e.name as employee_name, e.manager_id
     from emp_details e
     join manager on  e.manager_id = manager.employee_id 
    )
select *
from manager;

with recursive cte as
    (select id as emp_id, name as emp_name, manager_id, 1 as level
     from emp_details where name = 'Asha'
    union
     select e.id as emp_id, e.name as emp_name, e.manager_id, (level+1) as level
     from emp_details e
     join cte on cte.emp_id = e.manager_id
    )
select *
from cte;

with recursive hierarchy as                                                     
(select id as employee_id, name as employee_name, manager_id
from emp_details
where name = 'Shripadh'
union
select e.id as employee_id, e.name as employee_name, e.manager_id
from emp_details e
join hierarchy h on e.manager_id = h.employee_id)
select *
from hierarchy;

-- I iteration --
select id as employee_id, name as employee_name, manager_id
from emp_details
where name = 'Shripadh'

-- II iteration --
select e.id as employee_id, e.name as employee_name, e.manager_id
from emp_details e
join (select id as employee_id, name as employee_name, manager_id
from emp_details
where name = 'Shripadh') hierarchy
on e.manager_id = hierarchy.employee_id

-- III iteration --
select e.id as employee_id, e.name as employee_name, e.manager_id
from emp_details e
join (select e.id as employee_id, e.name as employee_name, e.manager_id
from emp_details e
join (select id as employee_id, name as employee_name, manager_id
from emp_details
where name = 'Shripadh') hierarchy
on e.manager_id = hierarchy.employee_id) hierarchy
on e.manager_id = hierarchy.employee_id

-- IV iteration -- 
select e.id as employee_id, e.name as employee_name, e.manager_id
from emp_details e
join (select e.id as employee_id, e.name as employee_name, e.manager_id
from emp_details e
join (select e.id as employee_id, e.name as employee_name, e.manager_id
from emp_details e
join (select id as employee_id, name as employee_name, manager_id
from emp_details
where name = 'Shripadh') hierarchy
on e.manager_id = hierarchy.employee_id) hierarchy
on e.manager_id = hierarchy.employee_id) hierarchy
on e.manager_id = hierarchy.employee_id

-- V iteration --
select e.id as employee_id, e.name as employee_name, e.manager_id
from emp_details e
join (select e.id as employee_id, e.name as employee_name, e.manager_id
from emp_details e
join (select e.id as employee_id, e.name as employee_name, e.manager_id
from emp_details e
join (select e.id as employee_id, e.name as employee_name, e.manager_id
from emp_details e
join (select id as employee_id, name as employee_name, manager_id
from emp_details
where name = 'Shripadh') hierarchy
on e.manager_id = hierarchy.employee_id) hierarchy
on e.manager_id = hierarchy.employee_id) hierarchy
on e.manager_id = hierarchy.employee_id) hierarchy  
on e.manager_id = hierarchy.employee_id

-- re-qrite above query to display only emp_id, emp_name and manager_name

select * from emp_details;

with recursive hierarchy as
    (select emp.id as emp_id, emp.name as emp_name, mng.name as manager
     from emp_details emp
     join emp_details mng on emp.manager_id = mng.id
     where emp.name = 'Shripadh'
union all
select e.id as emp_id, e.name as emp_name, hierarchy.emp_name as manager
     from emp_details e
     join hierarchy on hierarchy.emp_id = e.manager_id
    )
select *
from hierarchy;

with recursive cte as
    (select emp.id as emp_id, emp.name as emp_name, mng.name as manager
     from emp_details emp
     join emp_details mng on emp.manager_id = mng.id
     where emp.name = 'Asha'
    union all
     select e.id as emp_id, e.name as emp_name, cte.emp_name as manager
     from emp_details e
     join cte on cte.emp_id = e.manager_id
    )
select *
from cte;