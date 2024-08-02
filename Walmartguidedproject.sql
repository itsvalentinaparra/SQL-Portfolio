CREATE DATABASE IF NOT EXISTS SALESDATAWALMART;


CREATE TABLE IF NOT EXISTS sales(
Invoice_ID VARCHAR(30) NOT NULL PRIMARY KEY,
    Branch VARCHAR(5) NOT NULL,
    City VARCHAR(30) NOT NULL, 
    Customer_type VARCHAR(30) NOT NULL,
    Gender VARCHAR(10) NOT NULL, 
    Product_line VARCHAR(100) NOT NULL, 
    Unity_Price DECIMAL(10, 2) NOT NULL, 
    Quantity INT NOT NULL, 
    VAT FLOAt(6, 4) NOT NULL, 
    Total_rev DECIMAL(12, 4) NOT NULL, 
    date DATETIME NOT NULL, 
    time TIME NOT NULL, 
    Payment_method VARCHAR(15) NOT NULL, 
    COGS DECIMAL(10, 2) NOT NULL, 
    Gross_margine_pct FLOAT(11, 9) NOT NULL, 
    Gross_income DECIMAL(12,4) NOT NULL, 
    Rating FLOAT(2,1) NOT NULL
    );
    
-- -- Feature Engineering -- -- 
-- Time of the day -- 
-- The time of the day could be divided by midnight, early morning, morning, afternoon and evening, 
-- However, it is important to considerate opening and closing times of Walmart.
-- Googling, it says that is usually from 7 to 11 pm, however, there might be some locations that open 24 hours. 
-- Despite this information, the data does not show midnight and early morning time, but it'll be considerated in the data becasue to be accurate with reality. 

SELECT
    time,
    (CASE
        WHEN time BETWEEN '00:00:00' AND '02:59:59' THEN 'MIDNIGHT'
        WHEN time BETWEEN '03:00:00' AND '05:59:59' THEN 'EARLY MORNING'
        WHEN time BETWEEN '06:00:00' AND '11:59:59' THEN 'MORNING'
        WHEN time BETWEEN '12:00:00' AND '17:59:59' THEN 'AFTERNOON'
        ELSE 'EVENING'
    END) AS time_of_day
FROM sales;

-- Adding this information to the initial date data --
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20) NOT NULL;

UPDATE sales
	SET time_of_day = (CASE
        WHEN time BETWEEN '00:00:00' AND '02:59:59' THEN 'MIDNIGHT'
        WHEN time BETWEEN '03:00:00' AND '05:59:59' THEN 'EARLY MORNING'
        WHEN time BETWEEN '06:00:00' AND '11:59:59' THEN 'MORNING'
        WHEN time BETWEEN '12:00:00' AND '17:59:59' THEN 'AFTERNOON'
        ELSE 'EVENING'
    END);
    
-- Adding the day name --
SELECT
	date,
    DAYNAME(date)
FROM sales;


ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
UPDATE sales
SET day_name = DAYNAME(date);

-- Adding the month name --
SELECT
	date,
    MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales
SET month_name = MONTHNAME(date);


-- ---------------------------------------------
-- How many unique cities does the data have? --
SELECT
	DISTINCT city 
FROM sales;

-- In which city is each branch -- 
SELECT
	DISTINCT branch
FROM sales;


-- Now unique cities and branches. 
--
SELECT
	DISTINCT city, 
    branch
From sales;

-- Questions of PRODUCTS -- 
-- ------------------------
SELECT
	DISTINCT Product_line
From sales;
-- countint the ditinct products

SELECT
	COUNT(DISTINCT Product_line)
From sales;

-- What is the most common payment method?
SELECT
	DISTINCT Payment_method
From sales;

-- Now counting each payment method, and also grouping them is done with the following code:
-- Also ordering them from highest number to the lowest one:
SELECT
	Payment_method, 
    COUNT(Payment_method) AS count
FROM sales
GROUP BY Payment_method
ORDER by count DESC;

-- Thus the most common payment method used is CASH. 

-- What is the most selling product line?
-- First we recognize what are the products, 
SELECT
	DISTINCT Product_line
From sales;

-- Now we use the code we just used for payment method.
SELECT
	Product_line, 
    COUNT(Product_line) AS productsline
FROM sales
GROUP BY Product_line
ORDER by productsline DESC;
-- Thus the most sold item is Fashion accessories. 

-- What is the total revenue by month? --
SELECT
	*
FROM sales;

SELECT
	month_name AS monthname,
    SUM(Total_rev) AS Total_revenue
From sales
GROUP BY month_name
ORDER BY Total_revenue DESC;
-- Janaury has the most sales. 

-- What month has the largest COGS? --
SELECT
	month_name AS monthname,
    SUM(COGS) AS Total_cogs
From sales
GROUP BY month_name
ORDER BY Total_cogs DESC;

-- What product of line had the largest revenue? --
SELECT
	Product_line AS productline,
    SUM(Total_rev) AS Total_revenue
From sales
GROUP BY Product_line
ORDER BY Total_revenue DESC;
-- The highes revenue was Food and beverages, 

-- What city had the largest revenue? --
SELECT
	Branch,
	City,
    SUM(Total_rev) AS Total_revenue
From sales
GROUP BY City, Branch
ORDER BY Total_revenue DESC;

-- What product line had the largest VAT? 
SELECT
	Product_line,
    AVG(VAT) AS avg_tax
FROM sales
GROUP BY Product_line
ORDER BY avg_tax DESC;

-- Fetch each product line and add column for those products line showing "GOOD", "BAD"
-- Good if its greater than average salaries. 

-- Which branch sold more products than average products sold?
SELECT
	branch,
    SUM(Quantity) AS quantity
FROM sales
GROUP BY branch 
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);
-- Branch A sold more products 


-- What is the most common product line by gender?
SELECT
	Gender, 
    Product_line, 
    COUNT(Gender) AS total_gender 
FROM sales
GROUP BY Gender, Product_line
ORDER BY total_gender DESC;

-- What is the average rating of each product line?
SELECT
	*
FROM sales;

SELECT
	ROUND(AVG(Rating), 2) AS avg_rating , 
    Product_line 
FROM sales
GROUP BY Product_line
ORDER BY avg_rating DESC;

-- SALES.
-- Number of sales made in each time of the day per weekday
SELECT
	day_name,
    time_of_day, 
	SUM(Quantity) AS quantity
FROM sales
GROUP BY day_name, time_of_day
ORDER BY quantity DESC;
 
-- Customers types that brings the most revenue. 
SELECT
	*
FROM sales;
   
SELECT
	Customer_type,
    SUM(Total_rev) AS sum_revenue
FROM sales
GROUP BY Customer_type
ORDER BY sum_revenue DESC;


-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT
	Branch,
    City, 
    ROUND(avg(VAT),2) AS avg_tax
FROM sales
GROUP BY Branch, City
ORDER BY avg_tax DESC;

-- Which customer type pays the most in VAT?
SELECT
	Customer_type,
    ROUND(avg(VAT),2) AS avg_tax
FROM sales
GROUP BY Customer_type
ORDER BY avg_tax DESC;

-- Customer
-- How many unique customer types does the data have?
-- What is the most common customer type?
SELECT
	Customer_type,
    COUNT(Customer_type) AS sum_customertype
FROM sales
GROUP BY Customer_type
ORDER BY sum_customertype;

-- How many unique payment methods does the data have?
SELECT
	Payment_method,
    COUNT(Payment_method) AS total_paymentmethod
FROM sales
GROUP BY Payment_method
ORDER BY total_paymentmethod;

-- Which customer type buys the most?
SELECT
	Customer_type,
    SUM(Quantity) AS sum_quantity
FROM sales
GROUP BY Customer_type
ORDER BY sum_quantity;

-- What is the gender of most of the customers?
SELECT
	Gender, 
    Customer_type, 
    COUNT(Gender) AS total_gender 
FROM sales
GROUP BY Gender, Customer_type
ORDER BY total_gender DESC;

-- What is the gender distribution per branch?
SELECT
	Gender, 
    Branch,
    City,
    COUNT(Gender) AS total_gender 
FROM sales
GROUP BY Gender, Branch, City
ORDER BY total_gender DESC;

-- Which time of the day do customers give most ratings?
SELECT
	Customer_type, 
    Time_of_day,
    ROUND (AVG(Rating), 2) AS avg_ratings
FROM sales
GROUP BY Customer_type, Time_of_day
ORDER BY avg_ratings DESC;

-- Which time of the day do customers give most ratings?
SELECT
	Customer_type, 
    Time_of_day,
    COUNT(Rating) AS quanity_of_ratings
FROM sales
GROUP BY Customer_type, Time_of_day
ORDER BY quanity_of_ratings DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT
	Customer_type, 
    Time_of_day,
    Branch,
    City,
    COUNT(Rating) AS quanity_of_ratings
FROM sales
GROUP BY Customer_type, Time_of_day, Branch, City
ORDER BY quanity_of_ratings DESC;


-- Which day fo the week has the best avg ratings?
SELECT 
	Day_name,
    ROUND(AVG(Rating), 2) AS avg_rating
FROM sales
GROUP BY Day_name
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?
SELECT 
	Branch, 
    City,
	Day_name,
    ROUND(AVG(Rating), 2) AS avg_rating
FROM sales
GROUP BY Branch, City, Day_name
ORDER BY avg_rating DESC;

-- Revenue by city and gender, monthly 
SELECT 
	Branch, 
    City,
	month_name,
    Gender, 
    SUM(Total_rev) AS total_revenue
FROM sales
GROUP BY Branch, City, month_name, Gender
ORDER BY total_revenue DESC;
