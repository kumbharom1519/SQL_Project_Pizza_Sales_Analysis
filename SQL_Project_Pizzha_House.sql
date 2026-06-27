CREATE DATABASE PROJECT_Pizza;
USE PROJECT_Pizza;


CREATE TABLE orders(
order_id INT PRIMARY KEY NOT NULL,
order_date DATE NOT NULL,
order_time TIME NOT NULL );


CREATE TABLE order_details(
order_details_id INT PRIMARY KEY NOT NULL,
order_id INT NOT NULL,
pizza_id TEXT NOT NULL,
quantity INT NOT NULL);

SELECT * FROM pizzas;
SELECT * FROM pizza_types;
SELECT * FROM orders;
SELECT * FROM order_details;


-- BASIC ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Retrieve the total number of orders placed.
SELECT COUNT(order_id) AS Total_Orders FROM orders;

-- Calculate the total revenue generated from pizza sales.
SELECT ROUND(SUM(p.price * o.quantity),2) AS Total_Amount 
FROM pizzas p
JOIN order_details o
ON p.pizza_id = o.pizza_id;

-- Identify the highest-priced pizza.
SELECT pt.name, p.size, p.price FROM pizza_types pt  		-- (Method 1)
JOIN pizzas p 
ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC 
LIMIT 1;

SELECT pt.name, p.size, p.price,							-- (Method 2 - Just to check ranks)
	RANK() OVER(ORDER BY p.price DESC) AS Highest_Price
FROM pizza_types pt 
JOIN pizzas p 
ON pt.pizza_type_id = p.pizza_type_id;

SELECT pt.name, p.size, p.price,							-- (Method 3 - Tried using FIRST_VALUE WFunction & LIMIT)
	FIRST_VALUE(p.price) OVER(ORDER BY p.price DESC) AS Highest_Price
FROM pizza_types pt 
JOIN pizzas p 
ON pt.pizza_type_id = p.pizza_type_id
LIMIT 1;

-- Identify the most common pizza size ordered.
SELECT p.size, COUNT(od.quantity) AS Quantity_Ordered
FROM order_details od
JOIN pizzas p 
ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY Quantity_Ordered DESC
LIMIT 1;

-- List the top 5 most ordered pizza types along with their quantities.
SELECT pt.name, SUM(od.quantity) AS Total_Quantity_Ordered    			-- (Joined 3 Tables here)
FROM pizza_types pt 
JOIN pizzas p 
	ON pt.pizza_type_id = p.pizza_type_id 
JOIN order_details od 
	ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY Total_Quantity_Ordered DESC
LIMIT 5;


-- INTERMEDIATE:----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT pt.category, SUM(od.quantity) AS Total_Quantity 			  -- (If category actually meant to be category; 3 Tables Joined)
FROM pizza_types pt 
JOIN pizzas p 
	ON pt.pizza_type_id = p.pizza_type_id 
JOIN order_details od 
	ON od.pizza_id = p.pizza_id
GROUP BY pt.category;


SELECT pt.name, p.size, SUM(od.quantity) AS Total_Quantity_Ordered -- (If category meant to be like this, then this works; 3 Tables Joined)
FROM pizza_types pt 
JOIN pizzas p 
	ON pt.pizza_type_id = p.pizza_type_id 
JOIN order_details od 
	ON od.pizza_id = p.pizza_id
GROUP BY pt.name, p.size
ORDER BY name;

-- Determine the distribution of orders by hour of the day.
SELECT HOUR(order_time) AS Hour_of_the_Day, COUNT(order_id) FROM orders
GROUP BY Hour_of_the_Day
ORDER BY Hour_of_the_Day ASC;

-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT category AS Category_Name, COUNT(name) AS Types_we_offer FROM pizza_types		-- (No need of JOIN here)
GROUP BY category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT o.order_date, SUM(od.quantity) AS Total_Orders,								-- (All 3 columns visible at a time)
	ROUND(AVG(SUM(od.quantity)) OVER() ,2)AS Average_Overall_For_Total_Orders  
FROM orders o 
JOIN order_details od 
ON o.order_id = od.order_id
GROUP BY o.order_date;


SELECT ROUND(AVG(Total_Orders),2) FROM  				-- (Using SubQuery - But Results AVG directly)
(
	SELECT o.order_date, SUM(od.quantity) AS Total_Orders
	FROM orders o 
	JOIN order_details od 
	ON o.order_id = od.order_id
	GROUP BY o.order_date
) AS x;

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT pt.name, SUM(p.price * od.quantity) AS Revenue 
FROM pizza_types pt
JOIN pizzas p 
	ON pt.pizza_type_id = p.pizza_type_id 
JOIN order_details od 
	ON od.pizza_id = p.pizza_id
GROUP BY pt.name 
ORDER BY Revenue DESC
LIMIT 3;

SELECT pt.name, MAX(p.price) AS price, SUM(od.quantity) AS total_quantity, SUM(p.price * od.quantity) AS Revenue
FROM pizza_types pt
JOIN pizzas p 
	ON pt.pizza_type_id = p.pizza_type_id 
JOIN order_details od 
	ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY Revenue DESC
LIMIT 3;


-- Advanced:----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT pt.category, 
	ROUND(SUM(p.price * od.quantity) / (SELECT ROUND(SUM(p.price * od.quantity),2) FROM pizzas p
											JOIN order_details od 
											ON p.pizza_id = od.pizza_id) 
	 * 100,2)  AS Percentage
FROM pizza_types pt 
JOIN pizzas p 
	ON pt.pizza_type_id = p.pizza_type_id 
JOIN order_details od 
	ON od.pizza_id = p.pizza_id 
GROUP BY pt.category;


SELECT pt.name,
    ROUND(SUM(p.price * od.quantity) * 100.0 / SUM(SUM(p.price * od.quantity)) OVER(), 2) AS Percentage
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.name;

-- Analyze the cumulative revenue generated over time.
SELECT o.order_date, 
	ROUND(SUM(p.price * od.quantity),2) AS Revenue,
	ROUND(SUM(SUM(p.price * od.quantity)) OVER(ORDER BY o.order_date),2) AS Running_Revenue_Over_Dates
FROM orders o 
JOIN order_details od
	ON o.order_id = od.order_id 
JOIN pizzas p 
	ON p.pizza_id = od.pizza_id
GROUP BY o.order_date
ORDER BY order_date;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT category, name, Total_Quantity, Revenue
FROM(
	SELECT category, name, Total_Quantity, Revenue,
		RANK() OVER(PARTITION BY category
					ORDER BY Revenue DESC)
		AS Rank_in_Category
		FROM(
			SELECT pt.category, pt.name, SUM(od.quantity) AS Total_Quantity, SUM(p.price * od.quantity) AS Revenue
			FROM pizza_types pt
			JOIN pizzas p 
				ON pt.pizza_type_id = p.pizza_type_id
			JOIN order_details od 
				ON od.pizza_id = p.pizza_id
			GROUP BY pt.category, pt.name
			) AS x
	) AS z
WHERE Rank_in_Category <= 3
ORDER BY category,Revenue DESC;
