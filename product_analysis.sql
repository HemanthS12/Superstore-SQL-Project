-- Product Analysis Project
-- Dataset: Superstore Orders (10,000+ records)
-- Objective: Analyze product-level performance to uncover high-volume items, underperformers, and segment-based trends.
-- Techniques: Aggregations, Filtering, Subqueries

-- 1) Best-Selling Product per Category
-- For each category, find the product with the highest total quantity sold.
select pq.category, pq.product_id, pq.total_quantity_sold
from
(
select category, product_id, sum(quantity) as total_quantity_sold
from orders 
group by category, product_id
) as pq
inner join
(
select category, MAX(total_quantity_sold) as highest_quantity_sold
from
(
select category, product_id, sum(quantity) as total_quantity_sold
from orders
group by category, product_id
) as A
group by category
) as join_details
on pq.total_quantity_sold = join_details.highest_quantity_sold and pq.category = join_details.category

-- 2) Low Revenue Products
-- List products that sold in more than 5 orders but generated less than ₹500 total revenue.
select product_id, count(order_id) as order_count, sum(sales) as total_sales
from orders
group by product_id
having count(distinct order_id) > 5 and sum(sales) < 500

-- 3) Products That Were Never Bought in the 'Corporate' Segment
-- Show Product ID and Product Name.
select distinct product_id, product_name
from orders
where product_id not in
(
select distinct product_id
from orders
where segment = 'Corporate'
)