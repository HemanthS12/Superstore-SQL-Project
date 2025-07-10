-- Order Analysis Project
-- Dataset: Superstore Orders (10,000+ records)
-- Objective: Use advanced SQL techniques to analyze customer behavior, order patterns, and high-value insights.
-- Techniques: Aggregations, Grouping, Subqueries, Filtering

-- 1) Average Order Value
-- For each Order ID, calculate total sales and then take the average
select AVG(total_sales) as avg_order_value
from
(
select order_id, SUM(sales) as total_sales 
from orders
group by order_id
) as orders_agg;

-- 2) Orders with High Value (> 2x average)
-- Identify and list orders whose sales were more than twice the average order value.
select order_id, SUM(sales) as high_value_sales
from orders
group by order_id
having SUM(sales) > 
(
select 2 * AVG(total_sales) as avg_order_value
from
(
select order_id, SUM(sales) as total_sales 
from orders
group by order_id
) as orders_agg
);

-- 3) Customers With Above-Average Order Frequency
-- Identify customers who placed more orders than the average number of orders placed by all customers.
-- Return customer_id, customer_name, and total_orders.
select customer_id, customer_name, count(distinct order_id) as total_orders
from orders
group by customer_id, customer_name
having count(distinct order_id) >
(
select AVG(order_count) as avg_orders
from
(
select customer_id, count(distinct order_id) as order_count
from orders
group by customer_id
) as customer_orders
);

-- 4) Days with the Highest Number of Orders
-- Identify the day(s) with the most number of orders placed. Return order_date and total_orders.
select order_date, count(distinct order_id) as total_orders
from orders
group by order_date
having count(distinct order_id) = 
(
select max(order_count)
from 
(
select order_date, count(distinct order_id) as order_count
from orders
group by order_date
) as daily_orders
);