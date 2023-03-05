create database interview_questions;
use interview_questions;

create table comments_and_translations
(
	id				int,
	comment			varchar(100),
	translation		varchar(100)
);

insert into comments_and_translations values
(1, 'very good', null),
(2, 'good', null),
(3, 'bad', null),
(4, 'ordinary', null),
(5, 'cdcdcdcd', 'very bad'),
(6, 'excellent', null),
(7, 'ababab', 'not satisfied'),
(8, 'satisfied', null),
(9, 'aabbaabb', 'extraordinary'),
(10, 'ccddccbb', 'medium');

select * from comments_and_translations;
select id,
case
when translation is not null then translation
else comment
end as output
from comments_and_translations;

select coalesce(translation, comment) as output
from comments_and_translations;

CREATE TABLE source
    (
        id      int,
        name    varchar(1)
    );

DROP TABLE target;
CREATE TABLE target
    (
        id      int,
        name    varchar(1)
    );

INSERT INTO source VALUES (1, 'A');
INSERT INTO source VALUES (2, 'B');
INSERT INTO source VALUES (3, 'C');
INSERT INTO source VALUES (4, 'D');

INSERT INTO target VALUES (1, 'A');
INSERT INTO target VALUES (2, 'B');
INSERT INTO target VALUES (4, 'X');
INSERT INTO target VALUES (5, 'F');

select s.id,
case
when s.id = 3 then 'new in source'
when s.id = 4 then 'mismatch'
else 'nothing'
end as comment
from source s
left join target t on s.id = t.id
where s.id in(3,4)
union all
select t.id,
case
when t.id = 5 then 'new in target'
else 'nothing'
end as comment
from source s
right join target t on s.id = t.id
where t.id = 5;

/* There are 10 IPL team. write an sql query such that each team play with every other team just once. */

drop table teams;
create table teams
    (
        team_code       varchar(10),
        team_name       varchar(40)
    );

insert into teams values ('RCB', 'Royal Challengers Bangalore');
insert into teams values ('MI', 'Mumbai Indians');
insert into teams values ('CSK', 'Chennai Super Kings');
insert into teams values ('DC', 'Delhi Capitals');
insert into teams values ('RR', 'Rajasthan Royals');
insert into teams values ('SRH', 'Sunrisers Hyderbad');
insert into teams values ('PBKS', 'Punjab Kings');
insert into teams values ('KKR', 'Kolkata Knight Riders');
insert into teams values ('GT', 'Gujarat Titans');
insert into teams values ('LSG', 'Lucknow Super Giants');

select * from teams;

select team.team_name as team, opponent.team_name as opponent,
row_number() over(partition by team.team_name) as rn
from teams as team
join teams as opponent on team.team_name > opponent.team_name
