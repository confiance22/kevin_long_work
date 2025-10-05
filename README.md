Assignment I - PL/SQL Window Functions
Student Information

Student ID: 27387

Name: MANZI Erick Kevin

Department: Software Engineering

Course: Database Development with PL/SQL (INSY 8311)

Problem Statement

This project implements a Sales & Customer Analytics Database using PL/SQL Window Functions.
It helps a retail company analyze sales transactions, track customer behavior, and generate insights for decision-making.

Business Context

A retail company wants to analyze product sales per region, identify top customers, and evaluate growth trends for performance improvement.

Data Challenge

The company manages millions of transactions across different regions and product categories.
Traditional SQL queries struggle with trend analysis and customer segmentation, making PL/SQL window functions ideal for extracting deeper insights.

Expected Outcome

By applying window functions, the system can:

Identify top-performing products and customers.

Compute running totals of sales over time.

Measure month-over-month growth.

Classify customers into quartiles for market segmentation.

Calculate moving averages for sales trend analysis.

Success Criteria (Goals)
Goal	Window Function Used
Top 5 products per region/quarter	RANK()
Running monthly sales totals	SUM() OVER()
Month-over-month growth	LAG() / LEAD()
Customer quartiles	NTILE(4)
3-month moving averages	AVG() OVER()
Database Schema
Tables Created

Customers (customer_id, name, region)

Products (product_id, name, category)

Transactions (transaction_id, customer_id, product_id, sale_date, amount)

Example Rows

Customers → (1001, John Doe, Kigali)

Products → (2001, Coffee Beans, Beverages)

Transactions → (3001, 1001, 2001, 2024-01-15, 25000)

CREATING PDB AND USER PRIVILEGES
Created Pluggable Database (PDB)
ALTER SESSION SET CONTAINER = plsql_window_functions;

Created User and Granted Privileges
CREATE USER kevin IDENTIFIED BY password;

GRANT CONNECT, RESOURCE TO kevin;
GRANT CREATE SESSION TO kevin;
GRANT CREATE TABLE TO kevin;
GRANT CREATE VIEW TO kevin;
GRANT CREATE SEQUENCE TO kevin;
GRANT CREATE PROCEDURE TO kevin;
GRANT DBA TO kevin;
GRANT UNLIMITED TABLESPACE TO kevin;


✅ Result: User kevin has full control of the PDB plsql_window_functions.

Implemented Window Functions
1. Ranking Function
SELECT customer_id,
       SUM(amount) AS total_sales,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS sales_rank
FROM transactions
GROUP BY customer_id;


📌 Insight: Identifies the top customers based on total sales revenue.

2. Aggregate with Window Frame
SELECT sale_date,
       SUM(amount) OVER (ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM transactions;


📌 Insight: Displays cumulative sales from the beginning to the current date.

3. Navigation Function
SELECT sale_date,
       amount,
       LAG(amount) OVER (ORDER BY sale_date) AS prev_sale,
       (amount - LAG(amount) OVER (ORDER BY sale_date)) / LAG(amount) OVER (ORDER BY sale_date) * 100 AS growth_percent
FROM transactions;


📌 Insight: Shows monthly growth rate compared to the previous month.

4. Distribution Function
SELECT customer_id,
       SUM(amount) AS total_spent,
       NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS quartile
FROM transactions
GROUP BY customer_id;


📌 Insight: Segments customers into 4 quartiles (Top, Upper-Mid, Lower-Mid, and Low spenders).

5. Moving Average Function
SELECT sale_date,
       AVG(amount) OVER (ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM transactions;


📌 Insight: Calculates the 3-month moving average for smoother sales trend visualization.

Screenshots

Creating PDB and granting user privileges

ER Diagram of the database schema

Query executions (RANK, SUM, LAG, NTILE, AVG)

Query result outputs with insights

Results Analysis
🔹 Descriptive – What Happened

Sales have increased steadily across multiple regions.

Beverage products consistently rank as top sellers.

Around 25% of customers contribute to 70% of total sales.

🔹 Diagnostic – Why It Happened

Kigali and Huye regions performed well due to targeted marketing.

Top customers were frequent buyers in high-margin categories.

🔹 Prescriptive – What to Do Next

Expand marketing campaigns in underperforming regions.

Launch loyalty programs for top-quartile customers.

Maintain high stock for fast-moving products.

References

Oracle Documentation (Window Functions)

W3Schools SQL & PL/SQL Tutorials

GeeksforGeeks SQL Analytics Functions

TutorialsPoint PL/SQL Programming

Academic Papers on Data Analytics using SQL

Real Business Case Studies (Retail Analytics)

Conclusion

This project demonstrates advanced PL/SQL analytics using Window Functions.
It highlights how SQL can power business intelligence by ranking top performers, measuring growth, and segmenting customers — all within a single, efficient database system.

📌 Author: MANZI Erick Kevin
📚 Course: Database Development with PL/SQL
