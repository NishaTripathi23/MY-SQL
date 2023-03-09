use procedures_functions;
drop table products;
create table products
(
	product_code			varchar(20) primary key,
	product_name			varchar(100),
	price					float,
	quantity_remaining		int,
	quantity_sold			int
);

insert into products (product_code,product_name,price,quantity_remaining,quantity_sold)
	values ('P1', 'iPhone 13 Pro Max', 1000, 5, 195);
 
 drop table sales;
 
create table sales
(
	order_id			int auto_increment primary key,
	order_date			date,
	product_code		varchar(20) references products(product_code),
	quantity_ordered	int,
	sale_price			float
);

insert into sales (order_date,product_code,quantity_ordered,sale_price)
	values (str_to_date('10-01-2022','%d-%m-%Y'), 'P1', 100, 120000);
insert into sales (order_date,product_code,quantity_ordered,sale_price)
	values (str_to_date('20-01-2022','%d-%m-%Y'), 'P1', 50, 60000);
insert into sales (order_date,product_code,quantity_ordered,sale_price)
	values (str_to_date('05-02-2022','%d-%m-%Y'), 'P1', 45, 540000);



-- Initial version of the procedure (without checking if product exists)

Delimiter &&
create procedure pr_product_sales2 ()
begin
declare v_prod_code varchar(10);
declare v_price int;
    -- main block of our code
    -- 1. Fetch the product_code and price for each product from products table
    select product_code, price
    into v_prod_code, v_price
    from products
    where product_name = 'iPhone 13 Pro Max';

    -- 2. load new data to sales table
    insert into sales (order_date, product_code, quantity_ordered, sale_price)
        values (current_date, v_prod_code, 1, (1*v_price));

    -- 3. update the products table accordingly as per sale.
    update products
    set quantity_remaining = quantity_remaining - 1
    , quantity_sold = quantity_sold + 1
    where product_code = v_prod_code;

end &&

select * from products;
select * from sales;

call pr_product_sales2 ();

-- create function -- 

DELIMITER &&
create function fn_check_if_prod_exists2(p_product_name varchar (25), p_quantity int)
returns varchar(10)
Deterministic
begin
declare v_count int;
    select count(1)
    into v_count
    from products
    where product_name = p_product_name
    and quantity_remaining >= p_quantity;
    
    if v_count > 0 then
        return True;
    else
        return False;
    end if;
end &&

select fn_check_if_prod_exists2('iPhone 13 Pro Max', 6);

-- Procedure Version 2: Including the check if product exists or not

DELIMITER &&
create procedure pr_product_sales0()
begin
declare v_prod_code  varchar(10);
declare v_price int;
declare v_check varchar(10);
declare message varchar (50);
    -- main block of our code
    -- Check if product exists:
    select fn_check_if_prod_exists2('iPhone 13 Pro Max', 1)
   into v_check;
    if v_check = 'false' then set message = 'Product_not_available';
    else
        -- 1. Fetch the product_code and price for each product from products table
        select product_code, price
        into v_prod_code, v_price
        from products
        where product_name = 'iPhone 13 Pro Max';

        -- 2. load new data to sales table
        insert into sales (order_date, product_code, quantity_ordered, sale_price)
            values (current_date, v_prod_code, 1, (1*v_price));

        -- 3. update the products table accordingly as per sale.
        update products
        set quantity_remaining = quantity_remaining - 1
        , quantity_sold = quantity_sold + 1
        where product_code = v_prod_code;
    end if;
end &&

select * from products;
select * from sales;

call pr_product_sales0();