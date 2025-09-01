-- create table
drop table if exists retail_sales;
create table retail_sales(
transactions_id int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(15),
age int,
category varchar(15),
quantiy int,
price_per_unit float,
cogs float,
total_sale float
)

select *
from retail_sales

select count(*)
from retail_sales

-- data cleaning
select *
from retail_sales
where 
transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null

delete from retail_sales
where 
transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null

select count(*)
from retail_sales


-- data exploration

-- how many sales we have.
select count(*)
from retail_sales

-- how many customers we have.
select count(distinct customer_id)
from retail_sales

-- names of all categories we have.
select distinct category
from retail_sales

-- data anlysis and business problem and answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select *
from retail_sales
where sale_date='2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
select *
from retail_sales
where category='Clothing'
and quantiy >3
and extract(month from sale_date)=11
and extract(year from sale_date)=2022

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select
	category,
	sum(total_sale) as total_sales
from retail_sales
group by category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select
	round(avg(age),2) as avg_age
from retail_sales
where category='Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *
from retail_sales
where total_sale>1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select
	category,
	gender,
	count(transactions_id) as total_transactions
from retail_sales
group by
	category,
	gender
order by category

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
WITH monthly_sales AS (
    SELECT
        EXTRACT(MONTH FROM sale_date) AS month,
        EXTRACT(YEAR FROM sale_date) AS year,
        AVG(total_sale) AS avg_sale
    FROM retail_sales
    GROUP BY EXTRACT(MONTH FROM sale_date), EXTRACT(YEAR FROM sale_date)
),
ranked AS (
    SELECT
        month,
        year,
        avg_sale,
        DENSE_RANK() OVER (PARTITION BY year ORDER BY avg_sale DESC) AS rnk
    FROM monthly_sales
)
SELECT
    month,
    year,
    avg_sale
FROM ranked
WHERE rnk = 1
ORDER BY year, month;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select
	customer_id,
	sum(total_sale) as total_sales
from retail_sales
group by customer_id
order by sum(total_sale) desc
limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select
	category,
	count(distinct customer_id) as total_customers
from retail_sales
group by category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
select
*,
case
	when extract(hour from sale_time)<12
	then 'Morning'
	when extract(hour from sale_time)>17
	then 'Evening'
	else 'Afternoon'
end as shift
from retail_sales



