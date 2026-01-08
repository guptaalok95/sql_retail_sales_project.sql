-- SQL Retail Sales Analysis - MySQL

CREATE DATABASE IF NOT EXISTS Retail_sales_project;
USE Retail_sales_project;

-- Drop table if exists
DROP TABLE IF EXISTS retail_sales;

-- Create table
CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit DECIMAL(10,2),
    cogs DECIMAL(10,2),
    total_sale DECIMAL(10,2)
);

SELECT * FROM retail_sales;

-- Count total number of records present in the data set
SELECT COUNT(*) FROM retail_sales;

-- How many uniuque customers we have
SELECT
 COUNT(DISTINCT customer_id) as total_customers 
 FROM retail_sales;
 
 CREATE INDEX idx_sale_date ON retail_sales(sale_date);
CREATE INDEX idx_customer_id ON retail_sales(customer_id);
CREATE INDEX idx_category ON retail_sales(category);