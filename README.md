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
CREATE USER kevin IDENTIFIED BY password;
GRANT CONNECT, RESOURCE, DBA TO kevin;
GRANT UNLIMITED TABLESPACE TO kevin;


CREATE TABLE customers (
  customer_id NUMBER PRIMARY KEY,
  name VARCHAR2(100),
  region VARCHAR2(100)
);

CREATE TABLE products (
  product_id NUMBER PRIMARY KEY,
  name VARCHAR2(100),
  category VARCHAR2(100)
);

CREATE TABLE transactions (
  transaction_id NUMBER PRIMARY KEY,
  customer_id NUMBER REFERENCES customers(customer_id),
  product_id NUMBER REFERENCES products(product_id),
  sale_date DATE,
  amount NUMBER(10,2)
);

