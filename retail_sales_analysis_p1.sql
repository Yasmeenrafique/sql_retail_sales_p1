--- table
CREATE TABLE retail_sales(
		      transaction_id INT PRIMARY KEY, 
			  sale_date DATE,
			  sale_time TIME,
			  customer_id INT,
			  gender VARCHAR(15),
			  age INT,
			  category VARCHAR(15),
			  quantity INT,
			  price_per_unit FLOAT,
			  cogs FLOAT,
			  total_sale FLOAT
           );

---Data cleaning
SELECT *
FROM retail_sales
LIMIT 10;

SELECT COUNT(*)
FROM retail_sales

SELECT *
FROM retail_sales
WHERE 
      transaction_id IS NULL
      OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  customer_id IS NULL
	  OR
	  gender IS NULL
	  OR
	  age IS NULL
	  OR
	  category IS NULL
	  OR
	  quantity IS NULL
	  OR
	  price_per_unit IS NULL
	  OR
	  cogs IS NULL
	  OR
	  total_sale IS NULL;

UPDATE retail_sales
SET age = 0
WHERE age IS NULL;


DELETE FROM retail_sales
WHERE
      transaction_id IS NULL
      OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  customer_id IS NULL
	  OR
	  gender IS NULL
	  OR
	  age IS NULL
	  OR
	  category IS NULL
	  OR
	  quantity IS NULL
	  OR
	  price_per_unit IS NULL
	  OR
	  cogs IS NULL
	  OR
	  total_sale IS NULL;

-- Data exploration
-- how many sales we have?
SELECT COUNT(*) AS total_sales
FROM retail_sales;

-- how many  unique customers we have?
SELECT COUNT(DISTINCT customer_id) AS customers
FROM retail_sales;

-- how many categories we have?
SELECT DISTINCT category 
FROM retail_sales;

---Data analysis
--q1 Write a sql query to retrieve all columns for sales made on '2022-11-05' ?

SELECT *
FROM retail_sales
WHERE sale_date ='2022-11-05';

--q2 write a sql query to retrieve all transactions where the category is 'clothing' and the quantity 
--sold is more than 4 and the month nov-2022?

SELECT *
FROM retail_sales
WHERE category = 'Clothing' 
      AND 
      TO_CHAR(sale_date,'YYYY-MM')='2022-11'
      AND
	  quantity >=4;

--q3 write a sql query to calculate the total sales for each category?
SELECT category,SUM(total_sale)as net_sale,
COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

--q4 Write a sql query to find the average age of customers who purchased items from the 'Beauty' category?
SELECT  ROUND(AVG(age),2) as Avg_age
FROM retail_sales
WHERE category = 'Beauty';

--q5 write a sql query to find all transactions where the total_sale is greater than 10000?
SELECT *
FROM retail_sales
WHERE total_sale >=1000;

--q6 write sql query to find the total number of transactions(transactions_id) made by each gender in each category
SELECT category,
gender,COUNT(*) AS total_trans
FROM retail_sales
GROUP BY 
   category,
   gender
ORDER BY 1

--q7 write a sql query to calculate the average sale for each month.Find out best selling month in each year?
SELECT year ,
       month,
       avg_sale
FROM 
(       SELECT EXTRACT(YEAR FROM sale_date)as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) AS avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale))AS rank
		FROM retaiL_sales
		GROUP BY 1,2
) as t1
WHERE rank = 1
--ORDER BY 1,3 DESC



--q8 write a sql query of top 5 customers based on the highest total_sales
SELECT customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--q9 Write a sql query to find the numbers who purchased items from each category.
SELECT 
   category,
   COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY category

--q10 Write a sql query to create each shift and number of orders(Example Morning <=12,Afternoon between 12 &17,Evening>17?)
WITH hourly_sale
AS
(
SELECT *,
     CASE 
	 WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
	 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	 ELSE 'Evening'
  END AS shift
FROM retail_sales
)
SELECT shift,
  COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

SELECT EXTRACT(HOUR FROM CURRENT_TIME)

