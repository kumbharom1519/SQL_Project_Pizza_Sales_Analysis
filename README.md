<img width="1988" height="958" alt="image" src="https://github.com/user-attachments/assets/cb2fbf47-6eea-471d-ae9e-59c2451dff96" /># 🍕 Pizza House Sales Analysis: SQL Portfolio Project

![SQL](https://img.shields.io/badge/MySQL-00000F?style=for-the-badge&logo=mysql&logoColor=white)
![Data Analysis](https://img.shields.io/badge/Data_Analysis-100000?style=for-the-badge&logo=data&logoColor=white)

## 📌 Project Overview    

This project is an end-to-end data analysis of Pizza Hut's sales over a one-year period. The goal of this project is to leverage SQL to extract actionable business insights regarding customer ordering patterns, peak operational hours, and revenue-driving menu items. 

The findings are synthesized into a business-focused presentation designed to help stakeholders optimize inventory, staffing, and marketing strategies.

---

## 💾 Data Architecture & Schema
The dataset comprises over 21,000+ records spread across four flat `.csv` files, which were imported into a relational MySQL database. 

**Tables:**
1. `Orders`: Contains order timestamp details (`order_id`, `order_date`, `order_time`).
2. `Order_Details`: Contains line-item details for each order (`order_details_id`, `order_id`, `pizza_id`, `quantity`).
3. `Pizzas`: Contains pricing and sizing for specific pizza configurations (`pizza_id`, `pizza_type_id`, `size`, `price`).
4. `Pizza_Types`: Contains high-level details about the pizza recipes (`pizza_type_id`, `name`, `category`, `ingredients`).

---

## 🛠️ Tech Stack & Skills Demonstrated
* **Database Management:** MySQL Workbench
* **Data Ingestion:** ETL (Extract, Transform, Load) from raw CSVs to a relational database.
* **SQL Techniques:** * Basic Aggregations (`SUM`, `COUNT`, `AVG`)
  * Complex Table `JOIN`s (Inner)
  * Data Grouping & Filtering (`GROUP BY`, `HAVING`, `ORDER BY`)
  * Subqueries & Nested Queries
  * Window Functions (`RANK()`, `SUM() OVER()`) for cumulative and ranking calculations.
* **Data Visualization/Presentation:** Canva (PDF generation)

---

## ❓ Business Questions Answered

### Basic Level
1. Retrieve the total number of orders placed.
2. Calculate the total revenue generated from pizza sales.
3. Identify the highest-priced pizza.
4. Identify the most common pizza size ordered.
5. List the top 5 most ordered pizza types along with their quantities.

### Intermediate Level
6. Join the necessary tables to find the total quantity of each pizza category ordered.
7. Determine the distribution of orders by hour of the day.
8. Join relevant tables to find the category-wise distribution of pizzas.
9. Group the orders by date and calculate the average number of pizzas ordered per day.
10. Determine the top 3 most ordered pizza types based on revenue.

### Advanced Level
11. Calculate the percentage contribution of each pizza type to total revenue.
12. Analyze the cumulative revenue generated over time.
13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.

---

## 💡 Key Insights & Recommendations
* **Peak Traffic:** Order volumes spike significantly between **12:00 PM - 1:00 PM** (lunch rush) and **5:00 PM - 7:00 PM** (dinner rush). *Recommendation: Optimize staff scheduling during these windows to reduce customer wait times.*
* **Revenue Drivers:** The **Thai Chicken Pizza** generates the highest overall revenue, despite the *Classic* category being the most frequently ordered. *Recommendation: Ensure high inventory levels of Thai Chicken ingredients to avoid stockouts of this high-margin item.*
* **Customer Preferences:** **Large-sized** pizzas account for the vast majority of total sales volume. *Recommendation: Prioritize Large dough preparation and consider targeted promotions for smaller sizes to boost their sales if needed.*

---

## 📂 Repository Structure
* `Dataset/`: Contains the original `.csv` files used for this analysis.
* `Queries/`: Contains the `.sql` scripts mapping to the business questions.
* `Pizza_Sales_Presentation.pdf`: The final business presentation showcasing the ER Diagram, methodology, SQL snippets, and insights.
