-- List the total sales by region and customer. Your output should be sorted by region name and customer code.

select region.reg_name, a.cus_code, sum(a.sale_units * a.sale_price) as total_sales from
(select customer.reg_id, sales.cus_code, sales.sale_units, sales.sale_price
from dwdaysalesfact as sales
join dwcustomer as customer
on customer.cus_code = sales.cus_code) as a
join dwregion as region
on a.reg_id = region.reg_id
group by region.reg_name, a.cus_code
order by region.reg_name, a.cus_code asc;


-- Repeat #1 but produce the output using ROLLUP with region name and customer code.

select region.reg_name, a.cus_code, sum(a.sale_units * a.sale_price) as total_sales from
(select customer.reg_id, sales.cus_code, sales.sale_units, sales.sale_price
from dwdaysalesfact as sales
join dwcustomer as customer
on customer.cus_code = sales.cus_code) as a
join dwregion as region
on a.reg_id = region.reg_id
group by rollup (region.reg_name, a.cus_code)
order by region.reg_name, a.cus_code asc;


-- Repeat #1 but product the output using CUBE with region name and customer code.

select region.reg_name, a.cus_code, sum(a.sale_units * a.sale_price) as total_sales from
(select customer.reg_id, sales.cus_code, sales.sale_units, sales.sale_price
from dwdaysalesfact as sales
join dwcustomer as customer
on customer.cus_code = sales.cus_code) as a
join dwregion as region
on a.reg_id = region.reg_id
group by cube (region.reg_name, a.cus_code)
order by region.reg_name, a.cus_code asc;


-- List the total sales by customer code, month, and product code; sort by customer code and month.

select sales.cus_code, time.tm_month, sales.p_code, sum(sales.sale_units*sales.sale_price) as 
total_sales
from dwdaysalesfact as sales
join dwtime as time
on time.tm_id = sales.tm_id
group by sales.cus_code, time.tm_month, sales.p_code
order by sales.cus_code, time.tm_month asc;


-- Show all purchases (total sales) in September to show which customer bought the most product in September. Show customer code, customer name and total sales; sort all output by total sales with the highest sales on top.

select a.cus_code, cust.cus_fname, cust.cus_lname, sum(a.sale_units * a.sale_price) as total_sales 
from
(select sales.cus_code, sales.sale_units, sales.sale_price
from dwdaysalesfact as sales
join dwtime as time
on time.tm_id = sales.tm_id
where time.tm_month = 9) as a
join dwcustomer as cust
on cust.cus_code = a.cus_code
group by a.cus_code,  cust.cus_fname, cust.cus_lname
order by total_sales desc;


-- List the total sales by month and product category. Your output should be sorted by month and product category.

select a.tm_month, prod.p_category, sum(a.sale_units * a.sale_price) as total_sales from
(select sales.sale_units, sales.sale_price, month.tm_month, sales.p_code
from dwdaysalesfact as sales
join dwtime as month
on sales.tm_id = month.tm_id) as a
join dwproduct as prod
on prod.p_code = a.p_code
group by a.tm_month, prod.p_category
order by a.tm_month, prod.p_category asc;


-- List the number of product sales (number of rows) and total sales by month. Your output should be sorted by month and should show one row per month.

select month.tm_month, count(*) as prod_sales,  sum(sales.sale_units * sales.sale_price) as 
total_sales 
from dwdaysalesfact as sales
join dwtime as month
on sales.tm_id = month.tm_id
group by month.tm_month
order by month.tm_month asc;


-- Show product category, product code, product description and units sold (sum). Which product is the best seller based on units sold? a) Show units sold for September, b) Show units sold for October.

select sales.p_code, prod.p_category, prod.p_descript, sum(sales.sale_units) as units_sold
from dwdaysalesfact as sales
join dwproduct as prod
on prod.p_code = sales.p_code
group by sales.p_code, prod.p_category, prod.p_descript
order by units_sold desc;


select a.p_code, prod.p_category, prod.p_descript, sum(a.sale_units) as units_sold from
(select sales.sale_units, sales.p_code
from dwdaysalesfact as sales
join dwtime as time
on time.tm_id = sales.tm_id
where time.tm_month = 9) as a
join dwproduct as prod
on prod.p_code = a.p_code
group by a.p_code, prod.p_category, prod.p_descript
order by units_sold desc;


select a.p_code, prod.p_category, prod.p_descript, sum(a.sale_units) as units_sold from
(select sales.sale_units, sales.p_code
from dwdaysalesfact as sales
join dwtime as time
on time.tm_id = sales.tm_id
where time.tm_month = 10) as a
join dwproduct as prod
on prod.p_code = a.p_code
group by a.p_code, prod.p_category, prod.p_descript
order by units_sold desc;


-- List the number of product sales (number of rows) and total sales by month, product category, and product. Your output should be sorted by month, product category and product.

select a.tm_month, prod.p_category, a.p_code, count(*) as prod_sales, sum(a.sale_units * 
a.sale_price) as total_sales from
(select sales.sale_units, sales.sale_price, month.tm_month, sales.p_code
from dwdaysalesfact as sales
join dwtime as month
on sales.tm_id = month.tm_id) as a
join dwproduct as prod
on prod.p_code = a.p_code
group by a.tm_month, prod.p_category, a.p_code
order by a.tm_month, prod.p_category, a.p_code asc;


-- List the top 5 vendors based on the total sales of their products. Show both the vendors' names and the total sales of their product. Sort by total sales.

select vend.v_name, sum(a.sale_units * a.sale_price) as total_sales from
(select sales.sale_units, sales.sale_price, sales.p_code, prod.v_code
from dwdaysalesfact as sales
join dwproduct as prod
on sales.p_code = prod.p_code) as a
join dwvendor as vend
on vend.v_code = a.v_code
group by vend.v_name
order by total_sales desc
limit 5;


--List the products that have not been sold in the year 2015. Show the product code, the product description and the product category.

select p_code, p_descript, p_category from dwproduct 
where p_code not in (
select distinct p_code from dwdaysalesfact )
order by p_code;


-- Find the top-selling products in each region based on the number of units sold. Show the region names, product description sand total units sold. Order by region name and total units sold (from largest to smallest).

select reg.reg_name, b.p_descript, sum(b.sale_units) as total_units_sold from
(select a.sale_units, a.reg_id, a.p_code, prod.p_descript from
(select sales.cus_code, sales.p_code, sales.sale_units, cust.reg_id
from dwdaysalesfact as sales
join dwcustomer as cust
on sales.cus_code = cust.cus_code) as a
join dwproduct as prod
on prod.p_code = a.p_code) as b
join dwregion as reg
on b.reg_id = reg.reg_id
group by reg.reg_name, b.p_descript
order by total_units_sold desc;
