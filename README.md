# Retail Sales Analysis
Developed with reference to instructional material by Zero Analyst on YouTube
## Overview

A comprehensive SQL-based analysis of retail sales data to uncover business insights and trends. This project demonstrates data exploration, cleaning, and analysis techniques using PostgreSQL to answer key business questions about customer behavior, sales patterns, and product performance.

**Database**: `sql_project_p1`

## Dataset

The analysis is based on retail sales transaction data containing:
- Transaction details (ID, date, time)
- Customer information (ID, gender, age)
- Product data (category, quantity, pricing)
- Financial metrics (price per unit, dollars, total sales)

## Database Structure

### Table: retail_sales

```sql
CREATE DATABASE sql_project_p1;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

## Data Quality & Preparation

Initial data exploration and cleaning steps:

```sql
-- Dataset overview
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

-- Data quality check and cleanup
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

## Key Analysis & Queries

### 1. Daily Sales Analysis
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

### 2. Category-Specific Filtering
```sql
SELECT *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND quantity >= 4;
```

### 3. Sales Performance by Category
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;
```

### 4. Customer Demographics Analysis
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';
```

### 5. High-Value Transaction Analysis
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```

### 6. Transaction Distribution by Demographics
```sql
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY category;
```

### 7. Monthly Sales Trends & Peak Performance
```sql
SELECT 
    year,
    month,
    avg_sale
FROM 
(    
    SELECT 
        EXTRACT(YEAR FROM sale_date) as year,
        EXTRACT(MONTH FROM sale_date) as month,
        AVG(total_sale) as avg_sale,
        RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
    FROM retail_sales
    GROUP BY 1, 2
) as ranked_months
WHERE rank = 1;
```

### 8. Top Customer Identification
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

### 9. Customer Reach by Category
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP BY category;
```

### 10. Sales Distribution by Time of Day
```sql
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END as shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;
```

## Key Findings

- **Customer Base**: Analysis reveals diverse customer demographics across multiple product categories
- **Premium Transactions**: Identified significant high-value purchases (>$1000) indicating strong premium market segment
- **Seasonal Patterns**: Monthly analysis uncovered peak sales periods for strategic planning
- **Customer Behavior**: Top-spending customers and category preferences provide insights for targeted marketing
- **Operational Insights**: Time-based analysis shows customer shopping patterns throughout the day

## Technical Stack

- **Database**: PostgreSQL
- **Analysis**: SQL queries for data exploration and business intelligence
- **Data Processing**: ETL operations for data cleaning and preparation

## Usage

1. Set up PostgreSQL database named `sql_project_p1`
2. Create the `retail_sales` table using the provided schema
3. Import your retail sales data
4. Execute the analysis queries to generate insights
5. Modify queries as needed for specific business requirements

