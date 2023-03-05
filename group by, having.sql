use  demo_test1;
-- 1) Find the average sales order price based on deal size --
select * from sales_order;

select avg(sales), deal_size
from sales_Order
group by deal_size

select round(avg(sales),2) as average_sale, deal_size
from sales_Order
group by deal_size

select round(avg(cast(sales as decimal)),2) as average_sale, deal_size
from sales_Order
group by deal_size

-- 2) Find total no of orders per each day. Sort data based on highest orders.
select * from sales_order;

select order_date, count(quantity_ordered) as num_orders
from sales_order
group by order_date
order by num_orders desc

select count(*) from sales_order
select count(1) from sales_order
select count(quantity_ordered) from sales_order

select * from customers;
select count(postal_code) from customers; -- 91 --
select count(*) from customers; -- 92 --

-- 3) Display the total sales figure for each quarter. Represent each quarter with their respective period.
select * from sales_order;

select qtr_id, round(sum(sales),2) as total_sales,
case 
when qtr_id = 1 then 'jan-mar'
when qtr_id = 2 then 'apr-jun'
when qtr_id = 3 then 'jul-sep'
when qtr_id = 4 then 'oct-dec'
else 'nothing'
end as Quarter_period
from sales_order
group by qtr_id, quarter_period;

-- 4) Identify how many cars, Motorcycles, trains and ships are available in the inventory.
-- Treat all type of cars as just "Cars".

select * from products;
select distinct product_line from products;

select product_line, count(*),
case
when product_line in('Classic Cars', 'Vintage Cars') then 'Cars'
else 'not_cars'
end as Cars
from products
where product_line <> 'Planes'
group by product_line;


select 
case
when product_line in('Classic Cars', 'Vintage Cars') then 'Cars'
else 'product_line'
end as Product_line,
product_line, count(*)
from products
where product_line in('Classic Cars', 'Vintage Cars', 'Motorcycles', 'Ships', 'Trains')
group by product_line;

select case when product_line in ('Classic Cars', 'Vintage Cars') then 'Cars'
            else product_line
       end as different_cars
, count(1)
from products
where product_line in ('Classic Cars', 'Vintage Cars', 'Motorcycles', 'Trains', 'Ships')
group by 
case 
when product_line in ('Classic Cars', 'Vintage Cars') then 'Cars'
            else product_line
       end ;
       
select product_line, count(1)
from products
where product_line in ('Motorcycles', 'Trains', 'Ships')
group by product_line
union all
select 'Cars' as prod, count(1)
from products
where product_line in ('Classic Cars', 'Vintage Cars');

 
 -- Identify the vehicles in the inventory which are short in number.
-- Shortage of vehicle is considered when there are less than 10 vehicles.
select * from products;
select count(*) as vehicles_in_the_inventory, product_line,
case
when 'vehicles_in_the_inventory' < 10 then 'shortage'
else 'sufficient'
end as vehicles
from products
group by product_line
order by vehicles_in_the_inventory; -- i am not getting the desired result

select product_line, count(*),
case
when count(*) < 10 then 'shortage'
else 'sufficient'
end as vehicles
from products
group by product_line
order by count(*); -- i got the result -- but it can be solved by using having clause -- 

select product_line , count(1)
from products
group by product_line
having count(1) < 10;


-- Assignments:
-- 6) Find the countries which have purchased more than 10 motorcycles. --
select * from customers;
select * from products;
select * from sales_order;

select c.country, p.product_line, count(p.product_line)
from sales_order s
join customers c on s.customer = c.customer_id
join products p on s.product = p.product_code
where p.product_line = 'Motorcycles'
group by p.product_line, c.country
having count(product_line) > 10
order by count(p.product_line) desc; -- this is my query --

select p.product_line, c.country, count(1)
    from Sales_order s
    join products p on p.product_code = s.product
    join customers c on c.customer_id = s.customer
    where p.product_line = 'Motorcycles'
    group by p.product_line, c.country
    having count(1) > 10
    order by 3 desc; -- this was in solution --
    
-- 7) Find the orders where the sales amount is incorrect. --



-- 8) Fetch the total sales done for each day. --
select * from sales_order;
select order_date, round(sum(sales),2) as total_sales
from sales_order
group by order_date
order by order_date;

-- 9) Fetch the top 3 months which have been doing the lowest sales. -- 


