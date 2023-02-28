-- DB_NAME : BANKING
CREATE DATABASE BANKING;
USE BANKING;
SELECT * FROM BRANCH;
SELECT * FROM PRODUCTS;
SELECT * FROM CUSTOMERS;
SELECT * FROM ACCOUNTS;
SELECT * FROM TRANSACTIONS;
SELECT * FROM EMPLOYEES;

DROP TABLE EMPLOYEES;
DROP TABLE BRANCH;
DROP TABLE PRODUCTS cascade;
DROP TABLE TRANSACTIONS;
DROP TABLE ACCOUNTS;
DROP TABLE CUSTOMERS;


CREATE TABLE BRANCH
(
	BRANCH_NAME	 	VARCHAR(50),
	BRANCH_CODE		VARCHAR(10),
	LOCATION		VARCHAR(100)
);

DROP TABLE PRODUCTS;
CREATE TABLE PRODUCTS
(
	PROD_ID	 		VARCHAR(10),
	PROD_NAME		VARCHAR(20) unique,
	PROD_DESC		VARCHAR(200)
);

insert into products values ('P1','Savings','');
insert into products values ('P2','LOAN','');

rollback;
commit;

drop table customers cascade;
rollback;

CREATE TABLE CUSTOMERS
(
	CUSTOMER_ID		VARCHAR(20) primary key,
	FIRST_NAME		VARCHAR(40) not null,
	LAST_NAME		VARCHAR(40) ,
	PHONE_NO		INT unique,
	ADDRESS			VARCHAR(100),
	DOB				DATE,
	IS_ACTIVE		varchar(10) check (IS_ACTIVE in ('active', 'inactive'))
);

insert into customers (customer_id, first_name, last_name, phone_no, address, dob, is_active)
values ('C1', 'Mohan', 'Kumar', 990045, 'Bangalore', '1990-05-07', 'active');

insert into customers
values ('C2', 'James', 'Xavier', null, 'Chennai', '1995-05-07', 'active');

insert into customers (customer_id, first_name, last_name, is_active)
values ('C3', 'Mohan', 'Kumar', 'active');

insert into customers (customer_id, first_name, last_name, is_active)
values ('C4', 'David', null, 'active');

insert into customers (customer_id, first_name, last_name, is_active)
values ('C20', 'Stephen', null, 'active');

insert into customers (customer_id, first_name, last_name, phone_no, address, dob, is_active)
values ('C5', 'Adil', null, 99001122, 'Bangalore', '1990-05-07', 'active');

insert into customers (customer_id, first_name, last_name, phone_no, address, dob, is_active)
values ('C6', 'Ali', null, 990011223, 'Bangalore', '1990-05-07', 'active');

insert into customers (customer_id, first_name, last_name, phone_no, address, dob, is_active)
values ('C7', 'TFQ', null, 9900112233, 'Bangalore', '1990-05-07', 'active');

insert into customers (customer_id, first_name, last_name, phone_no, address, dob, is_active)
values ('C8', 'Libinus', '', 9900112299, 'Bangalore', '1990-05-07', 'active');


alter table customers 
MODIFY phone_no  bigint;








select * from CUSTOMERS;
commit;

insert into customers (customer_id, first_name, last_name, phone_no, address, dob, is_active)
values ('C30', 'Shiva', '', 99001100, 'Bangalore', '1990-05-07', 'active');

insert into customers (customer_id, first_name, last_name, phone_no, address, dob, is_active)
values ('C31', 'Vikram', '', 99001200, 'Bangalore', '1990-05-07', 'active');

rollback;

create table test(name varchar(10));





select * from information_schema.tables where table_schema in ('public', 'dev');

select * from products;
insert into products values ('P2', 'Loan', '');


drop TABLE ACCOUNTS cascade;
DROP TABLE ACCOUNTS;
CREATE TABLE ACCOUNTS
(
	ACC_NO			INT,
	ACC_TYPE		VARCHAR(30) references products(prod_name),
	CUST_ID			VARCHAR(20) references customers(customer_id),
	BALANCE			FLOAT,
    CONSTRAINT PK_ACC PRIMARY KEY(ACC_NO, ACC_TYPE)
);

insert into accounts values (12345, 'Savings', 'C1', 9000);
insert into accounts values (1234, 'Savings', 'C2', 2000);
insert into accounts values (1234567, 'Savings', 'C20', 2000);

select * from accounts;

commit;
rollback;


drop TABLE TRANSACTIONS;
CREATE TABLE TRANSACTIONS
(
	TRNS_ID			INT AUTO_INCREMENT,
	TRNS_TYPE		VARCHAR(20) ,
	TRNS_DATE		DATE,
	ACC_NO			INT ,
    ACC_TYPE        VARCHAR(30),
	AMOUNT			FLOAT,
	STATUS			VARCHAR(10) default 'Success',
    constraint pk_trns primary key(trns_id,TRNS_TYPE),
    constraint fk_acc_no foreign key(ACC_NO, ACC_TYPE) references accounts(ACC_NO, ACC_TYPE)
);

insert into TRANSACTIONS (TRNS_TYPE, TRNS_DATE, ACC_NO, ACC_TYPE, AMOUNT, STATUS)
VALUES ('Online Payment', current_date, 12345, 'SAVINGS', 100, 'Success');

insert into TRANSACTIONS values (1,'Online Payment', current_date, 12345, 'SAVINGS', 100, 'Success');

insert into TRANSACTIONS values (1,'Withdrawal', current_date, 12345, 'SAVINGS', 50, 'Success');

insert into TRANSACTIONS values (1,'test', current_date, 12345, 'SAVINGS', 50, 'Success');

insert into TRANSACTIONS values (1,'ATM Withdrawal', current_date, 90098, 50, 'Success');


insert into TRANSACTIONS (trns_id, trns_type, trns_date, acc_no, ACC_TYPE, amount, status)
values (2,'Online Payment', current_date, 12345, 'SAVINGS', 100, 'Failre');

insert into TRANSACTIONS (trns_id, trns_type, trns_date, acc_no, ACC_TYPE, amount)
values (3,'Online Payment', current_date, 12345, 'SAVINGS', 100);

insert into TRANSACTIONS (trns_id, trns_type, trns_date, acc_no, ACC_TYPE, amount, status )
values (4,'Online Payment', current_date, 12345, 'SAVINGS', 100, default);

insert into TRANSACTIONS (trns_id, trns_type, trns_date, acc_no, ACC_TYPE, amount)
values (6,'Online Payment', current_date, 12345, 'SAVINGS', 100);
commit;

select * from TRANSACTIONS;


CREATE TABLE EMPLOYEES
(
	EMP_ID			VARCHAR(20),
	FIRST_NAME		VARCHAR(40),
	LAST_NAME		VARCHAR(40),
	SALARY			FLOAT ,
	BRANCH_CODE		VARCHAR(10)
);
insert into employees values ('E1', 'Mohan', 'Kumar', 500, null);
insert into employees values ('E2', 'James', 'Xavier', 200, null);
insert into employees values ('E3', 'David', 'Smith', 300, null);
insert into employees values ('E4', 'Ali', 'Abdaal', 400, null);

SELECT * FROM employees;

create table test (id serial, name varchar(10));
insert into test (name) values ('TFQ');
select * from test;

create table test1 (id INT PRIMARY KEY AUTO_INCREMENT, name varchar(10));
insert into test1 (name) values ('TFQ');
select * from test1;

-- UPDATE DML command
select * from TRANSACTIONS;

SET AUTO COMMIT = 0;

BEGIN TRANSACTION;
update transactions
set amount = 100
where trns_id = 1;
COMMIT;
ROLLBACK;

START TRANSACTION;

update transactions
set amount = 999, trns_date = '2020-01-01'
where trns_id = 1;

-- DELETE command:
select * from TRANSACTIONS;
ROLLBACK;
delete from transactions;

delete from transactions
where trns_id = 1; -- DELETE WILL REMOVE ALL THE RECORDS OR IT CAN DELETE SPECIFIC DATA -- 

-- TRUNCATE DDL command:
truncate table transactions; -- WHERE CLAUSE DOES NOT WORK IN TRUNCATE -- IN TRUNCATE ALL THE DATAS ARE DELETED -- 
-- TRUNCATE IS FASTER THAN DELETE -- 
-- rollback; -- similar to undo. Removes the uncommitted transactions from the current session.
-- commit; -- permanently saves the changes to the DB.

SELECT * FROM ACCOUNTS;

-- SAVEPOINT command--
insert into TRANSACTIONS (trns_type,TRNS_DATE,acc_no,acc_type,amount,status)
values ('Online Payment', current_date, 12345,'Savings', 100, 'Success');

insert into TRANSACTIONS (trns_type,TRNS_DATE,acc_no,acc_type,amount,status)
values ('Online Payment', current_date, 12345,'Loan', 500, 'Failure');

savepoint after_2_trns;

insert into TRANSACTIONS (trns_type,TRNS_DATE,acc_no,acc_type,amount,status)
values ('Online Payment', current_date, 12345,'Loan', 200, default);

savepoint after_all_trns;
