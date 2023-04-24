{\rtf1\ansi\ansicpg1252\cocoartf2709
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww8060\viewh18000\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 \'97 How many invoices are there? List the invoice numbers and the invoice dates.\
\
Select count(distinct inv_number) from invoice;\
\
Select inv_number, inv_date from invoice\
Group by inv_number;\
\
\
\'97 How many customers are there? List the customer codes and names\
\
Select count(distinct cus_code) from customer;\
\
Select cus_code, cus_fname, cus_lname from customer\
Group by cus_code;\
\
\
\'97 List vendor numbers and vendor names. Show vendor count per state.\
\
Select v_code, v_name from vendor\
Group by v_code;\
\
Select v_state, count(v_code) as count from vendor\
Group by v_state;\
\
\
\'97based on price, what is the most expensive product? How much quantity on hand is available for the most expensive product?\
\
Select p_code, p_descript, p_price from product\
Order by p_price desc\
Limit 1;\
\
Select p_qoh from product\
Where p_code = \'9289-WRE-Q\'92;\
\
\
\'97 Display the product description, quantity on hand, and price for all products that have a discount greater than 5%\
\
Select p_descript, p_qoh p_price from product\
Where p_discount > 0.05;\
\
\
\'97 generate a listing of products offered by each vendor. List the vendor name, product code, and product name. Sort by vendor name and product code.\
\
Select v.v_name, p.p_code, p.p_descript from vendor as v\
Join product as p\
On p.v_code = v.v_code\
Group by v.v_name, p.p_code;\
\
\
\'97 what is the average discount (rounded to the nearest cent) given by each vendor\
\
Select v.v_name, round(avg(p.p_discount),2) as avg_disc from vendor as v\
Join product as p\
On p.v_code = v.v_code\
Group by v.v_name;\
\
\
\'97 what is the vendor with most \'91products on hand\'92 for a particular product?\
What is the vendor with most \'91products on hand\'92 for all its products combined? List both the vendor name and the number of products. Is it the same vendor in both cases?\
\
Select v.v_name, p.p_code, max(p.p_qoh) as max_qoh from vendor as v\
Join product as p\
On v.v_code = p.v_code\
Group by p.p_code\
Order by max_qoh desc\
Limit 1;\
\
Select v.v_name, sum(p.p_qoh) as total_qoh from vendor as v\
Join product as p\
On v.v_code = p.v_code\
Group by v.v_name\
Order by total_qoh desc;\
\
\
\'97 generate a listing of customer purchases, including the subtotals for each of the invoice line numbers; sort output by customer code, invoice number and the line_number\
\
Select i.cus_code, l.inv_number, l.line_number, sum(l.line_price * l.line_units) as subtotal from invoice as i\
Join line as l\
On i.inv_number = l.inv_number\
Group by i.cus_code, l.inv_number, l.line_number\
Order by i.cus_code l.inv_number, l.line_number;\
\
\
\'97 list the total amount spent by each customer who made purchases during the current invoice cycle\'96 that is, for the customers who appear in the INVOICE table; sort by customer code\
\
Select i.cus_code, sum(l.line_units * l.line_price) from invoice as i\
Join line as l\
On i.inv_number = l.inv_number\
Group by i.cus_code\
Order by i.cus_code asc;\
\
\
\'97 find a listing of customers who did not make purchases during the invoicing period; sort by customer code\
\
Select * from customer\
Where cus_code not in (\
Select cus_code from invoice)\
Order by cus_code;\
\
\
\'97 create a query to produce a summary of the value of products currently in inventory\
\
Select sum(p_qoh * p_price) as total_value from product\
Where p_qoh > 0;\
\
\
\
\
\
\
}