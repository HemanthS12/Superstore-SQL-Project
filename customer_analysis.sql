-- Customer Analysis Project
-- Dataset: Superstore Orders (10,000+ records)
-- Objective: Understand customer behavior in terms of purchase frequency, value, and distribution.
-- Techniques: Aggregations, Subqueries, Filtering

-- 1) Top Customers by Total Sales
-- List top 5 customers who spent the most overall.
select top 5 customer_id, customer_name, SUM(sales) as total_sales
from orders
group by customer_id, customer_name
order by total_sales desc;

-- 2) Customers Who Placed Only One Order
-- Show Customer_id, Customer Name for such customers.
select customer_id, customer_name
from orders
group by customer_id, customer_name
having count(distinct order_id) = 1;

-- 3) Customers Who Purchased More Units Than the Average Total Quantity
-- Compare each customer's total orders with the average across all customers and show only those who placed more than average.
select customer_id, SUM(quantity) as total_orders
from orders
group by customer_id
having SUM(quantity) >
(
select round(AVG(total_orders), 0) as avg_quantity
from 
(
select customer_id, SUM(quantity) as total_orders
from orders
group by customer_id
) as customer_order_avg_unit
);

-- 4) Customers With Order Count Above Average
select customer_id, customer_name, COUNT(distinct order_id) as total_orders
from orders
group by customer_id, customer_name
having COUNT(distinct order_id) >
(
select AVG(order_count) 
from
(
select customer_id, customer_name, COUNT(distinct order_id) as order_count
from orders
group by customer_id, customer_name
) as customer_order_summary
);