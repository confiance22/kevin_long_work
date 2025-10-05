-- 01_ranking.sql
-- Total revenue per customer for 2024 with ranking functions

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


-- 02_aggregates.sql
-- Monthly revenue per region with running total

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



-- 03_navigation.sql
-- Month-over-month percent change per region

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



-- 04_distribution.sql
-- Customer segmentation: quartiles by total revenue

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



-- 05_moving_average.sql
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

