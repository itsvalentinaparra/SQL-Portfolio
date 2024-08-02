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



