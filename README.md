# sql_retail_sales_project.sql
Retail sales data analysis using MySQL, covering customer behavior, revenue trends, profitability, churn analysis, and operational insights.

---

# Retail Sales Analysis using SQL (MySQL)
## Project Overview
This project performs an **end-to-end retail sales analysis** using **MySQL**, focusing on **data quality, customer behavior, revenue growth, profitability, and business insights**.
The goal of this project is to demonstrate **advanced SQL skills** and the ability to translate raw transactional data into **actionable business insights**.
---
## Tools & Technologies
* **Database:** MySQL 8+
* **Language:** SQL
* **Concepts Used:**

  * CTEs (Common Table Expressions)
  * Window Functions (`RANK`, `LAG`, `NTILE`)
  * Time-series analysis
  * Pareto (80/20) analysis
  * Customer churn modeling
  * Profitability & volatility analysis
  * ---
## Dataset Description
The dataset represents retail transactions with the following key attributes:

| Column Name    | Description                   |
| -------------- | ----------------------------- |
| transaction_id | Unique transaction identifier |
| sale_date      | Date of transaction           |
| sale_time      | Time of transaction           |
| customer_id    | Unique customer identifier    |
| gender         | Customer gender               |
| age            | Customer age                  |
| category       | Product category              |
| quantity       | Units sold                    |
| price_per_unit | Price per unit                |
| cogs           | Cost of goods sold            |
| total_sale     | Total transaction amount      |
---
## 1. Data Quality & Validation
Ensured high data integrity by performing:
* Null value detection and removal
* Duplicate transaction identification
* Data anomaly detection
  *(validated total sales against quantity × price)*
> **Outcome:** Clean and reliable dataset for accurate analysis.
---
## 2. Customer & Revenue Intelligence
Key analyses include:
* **Customer Lifetime Value (CLV)** – Identified high-value customers based on historical profit
* **Repeat vs One-Time Customers** – Measured revenue contribution and retention impact
* **Pareto Analysis (80/20 Rule)** – Determined customers driving majority of revenue
> **Business Impact:** Helps prioritize VIP customers and retention strategies.
---
## 3. Time-Series & Growth Analysis
Performed advanced trend analysis such as:
* Month-over-Month (MoM) sales growth
* Running total of sales
* Average Order Value (AOV) trend analysis
> **Business Impact:** Enables monitoring of growth momentum and seasonality.
> ---
## 4. Operational & Time-Based Analysis
Analyzed sales performance by:
* Time-of-day buckets (Morning, Afternoon, Evening, Night)
* Peak sales hour identification
* Monthly sales volatility using standard deviation
> **Business Impact:** Supports staffing, inventory, and promotional planning.
---
## 5. Profitability & Cost Analysis
Evaluated financial performance through:
* Profit margin by product category
* Ranking categories by profitability
* Identifying low-margin risk areas
> **Business Impact:** Guides pricing and cost optimization decisions.
---
## 6. Business Scenario Analysis
Solved real-world business problems such as:
* **Customer Churn Analysis**
  *(customers inactive for last 3 months)*
* **Seasonal Trend Analysis (Q1 vs Q4)**
* **Customer Segmentation** into:
   * High Value
   * Medium Value
   * Low Value customers
> **Business Impact:** Enables targeted marketing and retention strategies.
---
## Key SQL Skills Demonstrated
* Advanced joins & aggregations
* Window functions for ranking and trend analysis
* Analytical thinking & business logic
* Data validation and quality checks
* Performance awareness using indexing concepts
---
## Project Structure
```
Retail-Sales-SQL-Analysis/
├── Retail_Sales_Analysis.csv      -- Raw data
├── retail_sales_analysis.sql   -- Full SQL analysis
├── retail_sales_schema.sql    -- Table creation
├── README.md                  -- Project documentation
└── insights_summary.md        -- Business insights (optional)
```
---
## How to Run This Project
1. Open **MySQL Workbench**
2. Run `retail_sales_schema.sql` to create the database & table
3. Load the dataset into `retail_sales`
4. Execute `retail_sales_analysis.sql`
---
## Key Takeaway
> *This project demonstrates how SQL can be used not just for querying data, but for driving real business decisions through analytics.*
---
## Contact
If you’d like to discuss this project or collaborate:

**LinkedIn:** *(www.linkedin.com/in/alok-gupta-a7bb5b260)*
**GitHub:** *(github.com/guptaalok95 )*
---
