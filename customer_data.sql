select * from customer

-- order level summary level
create view order_summary as
select order_id,customer_id,
min(order_date)as order_date,
sum(sales)as total_sales,
sum(profit)as total_profit,
sum(quantity)as total_quantity
from customer
group by order_id,customer_id

-- customer_level_summary

create view customer_summary as
select customer_id,
count(Distinct order_id) as total_orders,
sum(sales) as total_sales,
sum(profit) as total_profit
from customer
group by customer_id;


-- loss-making product
select sub_category,sum(profit) as total_profit
from customer
group by sub_category
having sum(profit)<0
order by total_profit;

-- discount-impact-analysis

select discount,
avg(profit) as avg_profit,
sum(sales)as total_sales
from customer
group by discount
order by discount,

-- Top 5 Customers (Using Window Function)
select * from (
select customer_id,sum(sales)as total_sales,
rank() over(order by sum(sales)desc)rank
from customer
group by customer_id
)ranked
where rank <=5

-- monthly growth rate
select year,month,sum(sales)as monthly_sales,
lag(sum(sales))over(order by year,month) as previous_month,
(sum(sales) - lag(sum(sales)) over (order by year,month)) /
lag(sum(sales)) over (order by year,month)*100 as growth_percent
from customer 

group by year,month
order by year,month

-- region performance
create view region_performance as 
select region,
sum(sales) as total_sales,
sum(profit)as total_profit from customer
group  by region

-- monthly trend
create view monthly_trends as 
select month_name ,
sum(sales) as totle_sales,
sum(profit) as total_profit
from customer
group by month_name ;

-- category_profit
create view category_profit as
select category ,sum(profit)as total_profit,
sum(sales) as totle_sales
from customer
group by category

-- ship_mode_performance
create view ship_mode as 
select ship_mode,
sum(sales) as totle_sales
from customer
group by ship_mode

			-- data quality check

-- duplicate check
select order_id,product_id,product_name, count(*)
from customer
group by order_id,product_id,product_name
having count(*)>1;

-- outlier detection

select *from customer
where discount>0.5

-- kpi table
create view kpi_summary as
select 
sum(sales) as total_sales,
sum(profit) as total_profit,
count(distinct order_id) as total_orders,
count(distinct customer_id) as total_customer,
avg(discount) as avg_discount
from customer