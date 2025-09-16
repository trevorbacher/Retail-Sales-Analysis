-- Database Setup
CREATE DATABASE sql_project_p1;

-- Table Creation
CREATE TABLE retail_sales
(
    transaction_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    dollars FLOAT,
    total_sale FLOAT
);

-- Data Exploration & Quality Checks
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

-- Check for null values
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR dollars IS NULL;

-- Clean data by removing null records
DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR dollars IS NULL;

-- Analysis Query 1: Retrieve all sales for specific date
SELECT *
FROM retail_sales
WHERE sale_date = '2022-06-05';

-- Analysis Query 2: Filter transactions by category, date, and quantity
SELECT *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND quantity >= 4;

-- Analysis Query 3: Calculate total sales for each category
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;

-- Analysis Query 4: Find average age of customers in Beauty category
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Analysis Query 5: Find all high-value transactions
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Analysis Query 6: Transaction count by gender and category
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Analysis Query 7: Find best selling month in each year
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

-- Analysis Query 8: Find top 5 customers by total sales
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Analysis Query 9: Count unique customers per category
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP BY category;

-- Analysis Query 10: Sales distribution by time shifts
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