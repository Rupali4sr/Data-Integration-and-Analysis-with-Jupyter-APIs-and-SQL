CREATE DATABASE retail;
USE retail;
select *
from retail_orders_practice;

# Q1. Find top 10 highest revenue generating products
select  product_id, sum(sale_price) as sales
from retail_orders_practice
group by product_id
order by sales desc
limit 10;

# Q2. Find top 5 highest selling products in each region
with cte as (select  region, product_id, sum(sale_price) as sales
from retail_orders_practice
group by region, product_id) 
select * from(
select * 
, row_number() over (partition by region order by sales desc) as rn 
from cte) A
where rn<=5;

# Q3. Find month over month growth comparison for 2022 and 2023 sales eg: Jan 2022 vs Jan2023
with cte as (
select  year(order_date) as order_year, month(order_date) as order_month, sum(sale_price) as sales 
from retail_orders_practice
group by order_year, order_month
)
select order_month
,sum(case when order_year = 2022 then sales else 0 end) as sales_2022
, sum(case when order_year = 2023 then sales else 0 end) as sales_2023
from cte 
group by order_month
order by order_month;

# Q4. Foe each category which month have highest sales
with cte as 
(
select category, format(order_date, 'yyyyMM') as order_year_month
, sum(sale_price) as sales 
from retail_orders_practice
group by category, format(order_date, 'yyyyMM')
)
select * from
(
select * , row_number() over(partition by category order by sales desc) as rn
from cte
) a
where rn = 1;

# Q5. Which subcategory has highest growth profit over year

with cte as (
select sub_category, year(order_date) as order_year, sum(sale_price) as sales 
from retail_orders_practice
group by sub_category, order_year
),
cte2 as (
select sub_category
,sum(case when order_year = 2022 then sales else 0 end) as sales_2022
, sum(case when order_year = 2023 then sales else 0 end) as sales_2023
from cte 
group by sub_category
order by sub_category)
select *, (sales_2023-sales_2022)*100/sales_2022 from cte2
order by (sales_2023-sales_2022)*100/sales_2022 Desc
limit 1
;













