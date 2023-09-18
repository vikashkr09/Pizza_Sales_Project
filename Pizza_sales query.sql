use pizza_db;

select * from pizza_sales;
-- PIZZA SALES SQL QUERIES

-- 1.Total Revenue:
SELECT SUM(total_price) AS Total_Revenue FROM pizza_sales;
 
-- 2.Average Order Value
SELECT (SUM(total_price) / COUNT(DISTINCT order_id)) AS Avg_order_Value FROM pizza_sales;
 
-- 3. Total Pizzas Sold
SELECT SUM(quantity) AS Total_pizza_sold FROM pizza_sales;
 
-- 4. Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_Orders FROM pizza_sales;
 
-- 5. Average Pizzas Per Order
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2))
AS Avg_Pizzas_per_order
FROM pizza_sales;
 
-- B. Daily Trend for Total Orders
-- 1.Firstly change the date format from dd-mm-yyyy to YYYY-MM-DD
SELECT * FROM pizza_sales WHERE STR_TO_DATE(order_date, '%d-%m-%Y') IS NULL;
SET SQL_SAFE_UPDATES=0 ;
UPDATE pizza_sales
SET order_date = STR_TO_DATE(order_date, '%d-%m-%Y')
WHERE STR_TO_DATE(order_date, '%d-%m-%Y') IS NOT NULL;
-- 2, Then change column datatype
ALTER TABLE pizza_sales
MODIFY COLUMN order_date date;
-- 3.Finally Daily Trend For Total Orders 
SELECT DAYNAME(order_date) AS order_day, COUNT(DISTINCT order_id) AS total_orders 
FROM pizza_sales
GROUP BY DAYNAME(order_date);
 
-- Hourly Trend  for hours 
SELECT EXTRACT(HOUR FROM order_time) AS order_hours, COUNT(DISTINCT order_id)
AS total_orders
FROM pizza_sales
GROUP BY EXTRACT(HOUR FROM order_time)
ORDER BY EXTRACT(HOUR FROM order_time);
 
-- D. % of Sales by Pizza Category
SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_category;
 
-- E. % of Sales by Pizza Size
SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size;
 

-- F. Total Pizzas Sold by Pizza Category
SELECT pizza_category, SUM(quantity) as Total_Quantity_Sold
FROM pizza_sales
WHERE MONTH(order_date) = 2
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC;
 
-- G. Top 5 Best Sellers by Total Pizzas Sold
SELECT  pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC
LIMIT 5;

-- H. Bottom 5 Best Sellers by Total Pizzas Sold
SELECT  pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold ASC
LIMIT 5;






















