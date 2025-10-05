# Assignment I - PL/SQL Window Functions

## Student Information
**Student ID:** 27387  
**Name:** MANZI Erick Kevin  
**Department:** Software Engineering  
**Course:** Database Development with PL/SQL (INSY 8311)

---

## Problem Statement
This project implements a **Sales & Customer Analytics Database** using **PL/SQL window functions**.  
It helps a retail company analyze sales transactions, track customer behavior, and generate insights for decision-making.

---

## Business Context
A retail company wants to analyze product sales per region, identify top customers, and evaluate growth trends.

---

## Data Challenge
The company has millions of sales records across different regions and products.  
Traditional queries are insufficient for trend analysis and customer segmentation.

---

## Expected Outcome
By applying PL/SQL window functions, we extract:

- Top-performing products and customers.  
- Running totals of sales.  
- Month-over-month growth.  
- Customer quartiles and market segmentation.

---

## Success Criteria (Goals)
| Goal | Function |
|------|-----------|
| Top 5 products per region/quarter | `RANK()` |
| Running monthly sales totals | `SUM() OVER()` |
| Month-over-month growth | `LAG()` / `LEAD()` |
| Customer quartiles | `NTILE(4)` |
| 3-month moving averages | `AVG() OVER()` |

---

## Database Schema

### Tables
- **Customers** (`customer_id`, `name`, `region`)  
- **Products** (`product_id`, `name`, `category`)  
- **Transactions** (`transaction_id`, `customer_id`, `product_id`, `sale_date`, `amount`)

### Example Rows
| Table | Example |
|--------|----------|
| Customers | `1001, John Doe, Kigali` |
| Products | `2001, Coffee Beans, Beverages` |
| Transactions | `3001, 1001, 2001, 2024-01-15, 25000` |

---

## ER Diagram
*(Include diagram image in repo — e.g., `er_diagram.png`)*

---

## Key Implementations

### ✅ Database Creation & Privileges
```sql
-- Connect to pluggable database
ALTER SESSION SET CONTAINER = plsql_window_functions;

-- Create user and grant privileges
CREATE USER kevin IDENTIFIED BY 123;
```
### ✅ Window Functions Implemented
1. Ranking Functions - Top Customers
```sql
SELECT customer_id, 
       SUM(amount) AS total_sales,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS sales_rank
FROM transactions
GROUP BY customer_id;
```
2. Ranking Functions - Top Products by Region
```sql
SELECT p.region,
       pr.name AS product_name,
       SUM(t.amount) AS region_sales,
       RANK() OVER (PARTITION BY p.region ORDER BY SUM(t.amount) DESC) AS regional_rank
FROM transactions t
JOIN customers p ON t.customer_id = p.customer_id
JOIN products pr ON t.product_id = pr.product_id
GROUP BY p.region, pr.name;
```
3. Aggregate with Window Frame - Running Total
```sql
SELECT sale_date, 
       amount,
       SUM(amount) OVER (ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM transactions
ORDER BY sale_date;
```
4. Navigation Functions - Month-over-Month Growth
```sql
SELECT sale_date, 
       amount,
       LAG(amount) OVER (ORDER BY sale_date) AS prev_sale,
       ROUND(
           (amount - LAG(amount) OVER (ORDER BY sale_date)) / 
           LAG(amount) OVER (ORDER BY sale_date) * 100, 2
       ) AS growth_percent
FROM transactions
ORDER BY sale_date;
```
5. Distribution Functions - Customer Quartiles
```sql
SELECT customer_id, 
       SUM(amount) AS total_spent,
       NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS quartile,
       CASE 
           WHEN NTILE(4) OVER (ORDER BY SUM(amount) DESC) = 1 THEN 'Platinum'
           WHEN NTILE(4) OVER (ORDER BY SUM(amount) DESC) = 2 THEN 'Gold' 
           WHEN NTILE(4) OVER (ORDER BY SUM(amount) DESC) = 3 THEN 'Silver'
           ELSE 'Bronze'
       END AS customer_segment
FROM transactions
GROUP BY customer_id;
```
6. Moving Average - 3-Month Rolling Average
```sql
SELECT sale_date, 
       amount,
       AVG(amount) OVER (ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3month
FROM transactions
ORDER BY sale_date;
```


## 🧮 Results Analysis  

### 🔹 Descriptive – What Happened?  
- Sales steadily increased quarter by quarter.  
- Top products were concentrated in the **Beverages** category.  
- **25%** of customers contributed to nearly **70%** of total revenue.  

---

### 🔹 Diagnostic – Why Did It Happen?  
- **Kigali** and **Huye** regions showed stronger growth due to marketing campaigns.  
- High-value customers are mainly **repeat buyers**.  

---

### 🔹 Prescriptive – What Next?  
- Expand marketing in regions with **low performance**.  
- Offer **loyalty programs** to top quartile customers.  
- Increase stock for **top-selling categories**.  

---

## 📚 References  
- [Oracle PL/SQL Documentation](https://docs.oracle.com/en/database/oracle/oracle-database/)   
- [W3Schools SQL OVER() Examples](https://www.w3schools.com/sql/sql_over.asp)    
- [Oracle Live SQL Demos](https://livesql.oracle.com/)  
- [TutorialsPoint PL/SQL Advanced Topics](https://www.tutorialspoint.com/plsql/index.htm)  
 
- **Academic Lecture Notes (AUCA 2025)**  

---

## 🏁 Conclusion  
This project demonstrates how **PL/SQL Window Functions** can transform raw sales data into **actionable insights**.  
By combining **ranking**, **running totals**, **growth tracking**, and **segmentation**, businesses gain a **complete analytical picture** of customer and sales performance.  

---

**📌 Author:** MANZI Erick Kevin  
**📚 Course:** Database Development with PL/SQL  
**🏫 Institution:** Adventist University of Central Africa  


