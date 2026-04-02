--SQL Retail 

SELECT *
FROM retail_sales;

SELECT COUNT (*)
FROM retail_sales;

--Data Cleaning
-- Check where there is no value
SELECT *
FROM retail_sales
WHERE transactions_id IS NULL;

SELECT *
FROM retail_sales
WHERE sale_date IS NULL;

SELECT *
FROM retail_sales
WHERE sale_time IS NULL;

SELECT *
FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Delete null values
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--Check how many deleted
SELECT COUNT (*)
FROM retail_sales

-- Data Exploration
SELECT *
FROM retail_sales

--How many sales we have?
SELECT COUNT(*) as total_sale
FROM retail_sales

--How many unique customers did they have?
SELECT COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales

--How many unique retail catgeory do they have?
SELECT COUNT(DISTINCT category) as unique_category
FROM retail_sales

--What are the unique category?
SELECT DISTINCT category
FROM retail_sales

--Main Data Analysis & Business Key Problems
-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022:
-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.:
-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
-- 8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.:
-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
-- Can also write TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' but my method also works

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	  AND
	  quantiy >= 4
	  AND
	  sale_date >= '2022-11-01' AND sale_date <= '2022-11-30';

	  
-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT category, sum(total_sale) as net_sale, COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT round(avg(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:

SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT COUNT(transactions_id) as total_transaction, category, gender
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT * FROM
(
SELECT AVG(total_sale) as avg_sales, EXTRACT(YEAR FROM sale_date) as year, EXTRACT(MONTH FROM sale_date) as month,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
FROM retail_sales
GROUP BY year, month
) as t1
WHERE rank = 1;

-- 8. **Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT customer_id, SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT category, COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP BY category;

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN  'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN  'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT shift, COUNT(transactions_id)
FROM hourly_sale
GROUP BY shift;
