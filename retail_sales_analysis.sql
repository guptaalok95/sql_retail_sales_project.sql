-- SQL Retail Sales Analysis

-- -----------------------------
-- 1. DATA QUALITY & VALIDATION
-- -----------------------------

-- A. Find null values in the data ?

SELECT * FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- B. Disable safe update mode temporarily to delete null records

Set SQL_Safe_Updates =0;
DELETE FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- C. Duplicate Transaction Detection
SELECT
    customer_id,
    sale_date,
    sale_time,
    total_sale,
    COUNT(*) AS duplicate_count
FROM retail_sales
GROUP BY customer_id, sale_date, sale_time, total_sale
HAVING COUNT(*) > 1 AND COUNT(DISTINCT transaction_id) > 1;

 -- D. Data Anomaly Detection

SELECT *
FROM retail_sales
WHERE total_sale <> quantity * price_per_unit;

-- -----------------------
-- 2. Data Exploration
-- -----------------------

-- SECTION 1: CUSTOMER & REVENUE INTELLIGENCE

-- 1. Total spendings of each customer who purchased our products -- Customer Lifetime Value (CLV)
-- NOTE: CLV here represents historical customer value based on available data

SELECT customer_id,
    SUM(total_sale) AS total_revenue,
    SUM(cogs) AS total_cost,
    SUM(total_sale - cogs) AS clv,
    RANK() OVER (ORDER BY SUM(total_sale - cogs) DESC) AS clv_rank
FROM retail_sales
GROUP BY customer_id;


-- 2. Repeat vs One-Time Customers + Revenue Contribution

WITH customer_orders AS (
	SELECT customer_id,
        COUNT(*) AS order_count,
        SUM(total_sale) AS revenue
    FROM retail_sales
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN order_count = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS total_customers,
    SUM(revenue) AS total_revenue,
    ROUND(100 * SUM(revenue) / SUM(SUM(revenue)) OVER (), 2) AS revenue_percentage
FROM customer_orders
GROUP BY customer_type;


-- 3. Month-over-Month (MoM) Sales Growth %

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(sale_date, '%Y-%m') AS month,
        SUM(total_sale) AS monthly_revenue
    FROM retail_sales
    GROUP BY month
)
SELECT
    month,
    monthly_revenue,
    ROUND(
        (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month))
        / NULLIF(LAG(monthly_revenue) OVER (ORDER BY month),0) * 100, 2
    ) AS mom_growth_pct
FROM monthly_sales;

-- 4. Category Contribution to Total Sales

SELECT
    category,
    SUM(total_sale) AS category_sales,
    ROUND( 100 * SUM(total_sale) / SUM(SUM(total_sale)) OVER (), 2) AS contribution_pct
FROM retail_sales
GROUP BY category;

-- SECTION 2: WINDOW FUNCTIONS & RANKING

-- 5. Running Total of Sales (Daily)

SELECT
    sale_date,
    SUM(total_sale) AS daily_sales,
    SUM(SUM(total_sale)) OVER (ORDER BY sale_date) AS running_total
FROM retail_sales
GROUP BY sale_date;

-- 6. Customer Purchase Frequency Ranking
SELECT
    customer_id,
    COUNT(*) AS total_orders,
    SUM(total_sale) AS total_sales,
    RANK() OVER (
        ORDER BY COUNT(*) DESC, SUM(total_sale) DESC
    ) AS customer_rank
FROM retail_sales
GROUP BY customer_id;

-- 7. Top Selling Category per Month

WITH category_monthly AS (
    SELECT
        DATE_FORMAT(sale_date, '%Y-%m') AS month,
        category,
        SUM(total_sale) AS total_sales,
        RANK() OVER (
            PARTITION BY DATE_FORMAT(sale_date, '%Y-%m')
            ORDER BY SUM(total_sale) DESC
        ) AS rank_in_month
    FROM retail_sales
    GROUP BY month, category
)
SELECT month, category, total_sales
FROM category_monthly
WHERE rank_in_month = 1;

-- 8. Average Order Value (AOV) Trend

WITH monthly_aov AS (
    SELECT
        DATE_FORMAT(sale_date, '%Y-%m') AS month,
        AVG(total_sale) AS aov
    FROM retail_sales
    GROUP BY month
)
SELECT
    month,
    aov,
    ROUND(aov - LAG(aov) OVER (ORDER BY month), 2) AS aov_change
FROM monthly_aov;

-- SECTION 3: OPERATIONAL & TIME ANALYSIS

-- 9. Find Sales by Time Buckets

SELECT
    CASE
        WHEN HOUR(sale_time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(sale_time) BETWEEN 17 AND 21 THEN 'Evening'
        ELSE 'Night'
    END AS time_bucket,
    COUNT(*) AS total_orders,
    SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY time_bucket;

-- 10. Peak Sales Hour
SELECT
    HOUR(sale_time) AS hour_of_day,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY hour_of_day
ORDER BY total_sales DESC
LIMIT 1;


-- 11. Sales Volatility (Standard Deviation)

SELECT
    DATE_FORMAT(sale_date, '%Y-%m') AS month,
    Round(STDDEV(total_sale),2) AS sales_volatility
FROM retail_sales
GROUP BY month
order by month;

-- 4: PROFITABILITY & COST ANALYSIS

-- 12. Profit Margin by Category
SELECT category,
       SUM(total_sale - cogs) AS total_profit,
       ROUND(100 * SUM(total_sale - cogs) / SUM(total_sale), 2) AS profit_margin_pct,
       RANK() OVER (
           ORDER BY SUM(total_sale - cogs) / SUM(total_sale) DESC
    ) AS margin_rank
FROM retail_sales
GROUP BY category;


-- 13. pareto Analysis (80/20 Rule)

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(total_sale) AS total_sales
    FROM retail_sales
    GROUP BY customer_id
),
ranked_sales AS (
    SELECT *,
        SUM(total_sales) OVER (ORDER BY total_sales DESC)
        / SUM(total_sales) OVER () AS cumulative_pct
    FROM customer_sales
)
SELECT *
FROM ranked_sales
WHERE cumulative_pct <= 0.80;

-- SECTION 5: BUSINESS SCENARIOS

-- 14. Customer Churn (No Purchase in Last 3 Months)

SELECT DISTINCT customer_id
FROM retail_sales
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM retail_sales
    WHERE sale_date >= DATE_SUB(
        (SELECT MAX(sale_date) FROM retail_sales), INTERVAL 3 MONTH)
);

-- 15. Seasonal Trend Analysis (Q1 vs Q4)

SELECT
    category,
    SUM(CASE WHEN QUARTER(sale_date) = 1 THEN total_sale ELSE 0 END) AS q1_sales,
    SUM(CASE WHEN QUARTER(sale_date) = 4 THEN total_sale ELSE 0 END) AS q4_sales
FROM retail_sales
GROUP BY category;

-- 16. Customer Segmentation (Low / Medium / High Value)

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(total_sale) AS total_sales
    FROM retail_sales
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_sales,
   CASE NTILE(3) OVER (ORDER BY total_sales DESC) 
        WHEN 1 THEN 'High Value'
        WHEN 2 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_sales;
