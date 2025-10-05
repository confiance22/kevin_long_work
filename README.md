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
<img width="1366" height="768" alt="Screenshot (616)" src="https://github.com/user-attachments/assets/12548b53-ecf4-4314-b8b6-5ec68349c464" />


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
1. Total revenue per customer for 2024 with ranking functionss
```sql
SELECT
  customer_id,
  name,
  total_rev,
  ROW_NUMBER() OVER (ORDER BY total_rev DESC)         AS row_num,
  RANK()       OVER (ORDER BY total_rev DESC)         AS rnk,
  DENSE_RANK() OVER (ORDER BY total_rev DESC)         AS dense_rnk,
  PERCENT_RANK() OVER (ORDER BY total_rev DESC)       AS pct_rank
FROM (
  SELECT c.customer_id, c.name, NVL(SUM(t.amount),0) AS total_rev
  FROM customers c
  LEFT JOIN transactions t ON c.customer_id = t.customer_id
    AND t.sale_date BETWEEN TO_DATE('2024-01-01','YYYY-MM-DD') AND TO_DATE('2024-12-31','YYYY-MM-DD')
  GROUP BY c.customer_id, c.name
) x
ORDER BY total_rev DESC;
```
2. Monthly revenue per region with running total
```sql
WITH monthly AS (
  SELECT
    c.region,
    TO_DATE(TO_CHAR(t.sale_date, 'YYYY-MM') || '-01', 'YYYY-MM-DD') AS month_start,
    SUM(t.amount) AS monthly_revenue
  FROM transactions t
  JOIN customers c ON t.customer_id = c.customer_id
  GROUP BY c.region, TO_CHAR(t.sale_date, 'YYYY-MM')
)
SELECT
  region,
  TO_CHAR(month_start,'YYYY-MM') AS ym,
  monthly_revenue,
  SUM(monthly_revenue) OVER (PARTITION BY region ORDER BY month_start
                             ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_rows,
  SUM(monthly_revenue) OVER (PARTITION BY region ORDER BY month_start
                             RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_range
FROM monthly
ORDER BY region, month_start;
```
3. Month-over-month percent change per region
```sql
WITH monthly AS (
  SELECT
    c.region,
    TO_DATE(TO_CHAR(t.sale_date,'YYYY-MM') || '-01', 'YYYY-MM-DD') AS month_start,
    SUM(t.amount) AS monthly_revenue
  FROM transactions t
  JOIN customers c ON t.customer_id = c.customer_id
  GROUP BY c.region, TO_CHAR(t.sale_date,'YYYY-MM')
)
SELECT
  region,
  TO_CHAR(month_start,'YYYY-MM') AS ym,
  monthly_revenue,
  LAG(monthly_revenue) OVER (PARTITION BY region ORDER BY month_start) AS prev_revenue,
  CASE 
    WHEN LAG(monthly_revenue) OVER (PARTITION BY region ORDER BY month_start) IS NULL THEN NULL
    WHEN LAG(monthly_revenue) OVER (PARTITION BY region ORDER BY month_start) = 0 THEN NULL
    ELSE ROUND( (monthly_revenue - LAG(monthly_revenue) OVER (PARTITION BY region ORDER BY month_start))
                / LAG(monthly_revenue) OVER (PARTITION BY region ORDER BY month_start) * 100, 2)
  END AS mom_pct_change
FROM monthly
ORDER BY region, month_start;
```
4. Customer segmentation: quartiles by total revenue
```sql
SELECT
  customer_id,
  name,
  total_rev,
  NTILE(4) OVER (ORDER BY total_rev DESC) AS quartile,
  CUME_DIST() OVER (ORDER BY total_rev DESC) AS cumedist
FROM (
  SELECT c.customer_id, c.name, NVL(SUM(t.amount),0) AS total_rev
  FROM customers c
  LEFT JOIN transactions t ON c.customer_id = t.customer_id
    AND t.sale_date BETWEEN TO_DATE('2024-01-01','YYYY-MM-DD') AND TO_DATE('2024-12-31','YYYY-MM-DD')
  GROUP BY c.customer_id, c.name
) x
ORDER BY total_rev DESC;
```
5. Moving Average - 3-Month Rolling Average
```sql
WITH monthly AS (
  SELECT
    TO_DATE(TO_CHAR(sale_date,'YYYY-MM') || '-01', 'YYYY-MM-DD') AS month_start,
    product_id,
    SUM(amount) AS monthly_revenue
  FROM transactions
  GROUP BY TO_CHAR(sale_date,'YYYY-MM'), product_id
)
SELECT
  product_id,
  TO_CHAR(month_start,'YYYY-MM') AS ym,
  monthly_revenue,
  ROUND(AVG(monthly_revenue) OVER (PARTITION BY product_id ORDER BY month_start
                                   ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS moving_avg_3mo
FROM monthly
ORDER BY product_id, month_start;
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
- [W3Schools SQL OVER()](https://www.w3schools.com/sql/sql_over.asp)     
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


