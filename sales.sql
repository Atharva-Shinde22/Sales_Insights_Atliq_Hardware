USE sales;

SELECT * FROM customers;
SELECT * FROM date;
SELECT * FROM markets;
SELECT * FROM products;
SELECT * FROM transactions;



# Data is from June 2017 to June 2020
SELECT DISTINCT(YEAR(date)) AS Year, (MONTHNAME(date)) AS Month 
FROM date;

# Rename customer_name column
ALTER TABLE customers
RENAME COLUMN custmer_name TO customer_name;

# Rename market column name
ALTER TABLE markets
RENAME COLUMN markets_code TO market_code,
RENAME COLUMN markets_name TO market_name;


# Transactions of Chennai for the year 2019
SELECT transactions.*, date.*
FROM transactions
INNER JOIN date 
ON transactions.order_date = date.date
WHERE date.year = 2019 AND transactions.market_code = "Mark001";


# Total Revenue by Year
SELECT YEAR(order_date) AS Year, SUM(sales_amount) AS Revenue
FROM transactions
GROUP BY Year;


# Top 5 customers with highest revenue
SELECT c.customer_code, c.customer_name, SUM(t.sales_amount) AS Revenue
FROM customers c
JOIN transactions t
ON c.customer_code = t.customer_code
GROUP BY c.customer_code, c.customer_name
ORDER BY Revenue DESC
LIMIT 5;


# Top 5 customers with lowest revenue
SELECT c.customer_code, c.customer_name, SUM(t.sales_amount) AS Revenue
FROM customers c
JOIN transactions t
ON c.customer_code = t.customer_code
GROUP BY c.customer_code, c.customer_name
ORDER BY Revenue
LIMIT 5;


# Top 5 products with highest revenue
SELECT p.product_code, SUM(t.sales_amount) AS Revenue
FROM products p
JOIN transactions t
ON p.product_code = t.product_code
GROUP BY p.product_code
ORDER BY Revenue DESC
LIMIT 5;


# Top 5 products with lowest revenue
SELECT p.product_code, SUM(t.sales_amount) AS Revenue
FROM products p
JOIN transactions t
ON p.product_code = t.product_code
GROUP BY p.product_code
ORDER BY Revenue
LIMIT 5;


# Revenue according to market region
SELECT m.market_code, m.market_name, SUM(t.sales_amount) AS Revenue
FROM markets m
JOIN transactions t 
ON m.market_code = t.market_code
GROUP BY m.market_code, market_name
ORDER BY Revenue DESC;


# Revenue according to market zone
SELECT m.zone, SUM(t.sales_amount) AS Revenue
FROM markets m
JOIN transactions t 
ON m.market_code = t.market_code
GROUP BY m.zone
ORDER BY Revenue DESC;


# What is the total sales quantity and sales amount for each product type 
SELECT p.product_type, SUM(t.sales_qty) AS Total_Sales_Quantity,
SUM(t.sales_amount) AS Revenue
FROM transactions t
JOIN products p 
ON t.product_code = p.product_code
JOIN date d 
ON t.order_date = d.date
GROUP BY p.product_type;


# How many customers of each type made purchases in each market zone
SELECT c.customer_type, m.zone, COUNT(DISTINCT t.customer_code) AS Total_Customers
FROM transactions t
JOIN customers c 
ON t.customer_code = c.customer_code
JOIN markets m 
ON t.market_code = m.market_code
JOIN date d 
ON t.order_date = d.date
GROUP BY c.customer_type, m.zone;


# What is the total sales amount in USD for each market
SELECT m.market_name, ROUND(SUM(t.sales_amount) / 75, 0) AS Revenue_USD
FROM transactions t
JOIN markets m 
ON t.market_code = m.market_code
GROUP BY m.market_name;


# Which product type had the highest sales quantity last quarter 
SELECT p.product_type, SUM(t.sales_qty) AS Total_Sales_Quantity
FROM transactions t
JOIN products p 
ON t.product_code = p.product_code
JOIN date d 
ON t.order_date = d.date
WHERE d.year = YEAR(CURRENT_DATE()) 
AND MONTHNAME(d.year) IN ('January', 'February', 'March')
GROUP BY p.product_type
ORDER BY Total_Sales_Quantity DESC
LIMIT 1;


# What is the total sales amount and profit margin percentage for each customer type in the current month
SELECT c.customer_type, SUM(t.sales_amount) AS Total_Sales_Amount,
ROUND(AVG(t.profit_margin_percentage), 2) * 100 AS Avg_Profit_Margin_Percentage
FROM transactions t
JOIN customers c 
ON t.customer_code = c.customer_code
JOIN date d 
ON t.order_date = d.date
WHERE d.month_name = MONTHNAME(CURRENT_DATE())
GROUP BY c.customer_type;


# How does the average profit margin percentage vary for each product type across different market zones
SELECT p.product_type, m.zone, ROUND(AVG(t.profit_margin_percentage), 2) * 100 AS Avg_Profit_Margin_Percentage
FROM transactions t
JOIN products p 
ON t.product_code = p.product_code
JOIN markets m 
ON t.market_code = m.market_code
GROUP BY p.product_type, m.zone;


# Which market had the highest total sales amount in the last year 
SELECT m.market_name, SUM(t.sales_amount) AS Total_Sales_Amount
FROM transactions t
JOIN markets m 
ON t.market_code = m.market_code
JOIN date d 
ON t.order_date = d.date
WHERE d.year = YEAR(CURRENT_DATE()) - 1
GROUP BY m.market_name
ORDER BY Total_Sales_Amount DESC
LIMIT 1;


# Which market zone has the highest total profit margin
SELECT m.zone, ROUND(SUM(t.profit_margin), 0) AS Total_Profit_Margin
FROM transactions t
JOIN markets m 
ON t.market_code = m.market_code
JOIN date d
ON t.order_date = d.date
WHERE YEAR(d.date) = 2019 
GROUP BY m.zone
ORDER BY Total_Profit_Margin DESC
LIMIT 1;


# How many transactions were made by each customer in each month of the year
SELECT c.customer_name, MONTHNAME(order_date) AS Month, YEAR(order_date) AS Year,
COUNT(*) AS Total_Transactions
FROM transactions t
JOIN customers c ON t.customer_code = c.customer_code
GROUP BY c.customer_name, Month, Year;


# What is the trend of revenue generated by a specific product over the past 12 months 
SELECT MONTHNAME(d.date_yy_mmm) AS Month, SUM(sales_amount) AS Total_Revenue
FROM transactions t
JOIN date d 
ON t.order_date = d.date
WHERE product_code = 'Prod001'
AND order_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 12 MONTH)
GROUP BY Month
ORDER BY order_date;


# Which product has the highest average profit margin percentage
SELECT p.product_code, AVG(profit_margin_percentage) * 100 AS Average_Profit_Margin_Percentage
FROM transactions t
JOIN products p 
ON t.product_code = p.product_code
GROUP BY p.product_code
ORDER BY Average_Profit_Margin_Percentage DESC
LIMIT 1;


# What is the total revenue and profit margin for each customer type in a specific market - No solution
SELECT c.customer_type, SUM(t.sales_amount) AS Total_Revenue,
ROUND(SUM(t.profit_margin), 0) AS Total_Profit_Margin
FROM transactions t
JOIN customers c 
ON t.customer_code = c.customer_code
WHERE t.market_code = 'Mark007'
GROUP BY c.customer_type;
    

# How many transactions were made for each product type in each market zone
SELECT p.product_type, m.zone, COUNT(*) AS Total_Transactions
FROM transactions t
JOIN products p 
ON t.product_code = p.product_code
JOIN markets m 
ON t.market_code = m.market_code
GROUP BY p.product_type, m.zone;
    
    
# Which month had the highest average sales quantity
SELECT month_name, AVG(sales_qty) AS Average_Sales_Quantity
FROM transactions t
JOIN date d 
ON t.order_date = d.date
GROUP BY month_name
ORDER BY Average_Sales_Quantity DESC
LIMIT 1;


# What is the total profit margin for each product type in a specific market 
SELECT p.product_type, ROUND(SUM(t.profit_margin), 0) AS Total_Profit_Margin
FROM transactions t
JOIN products p 
ON t.product_code = p.product_code
WHERE t.market_code = 'Mark007'
GROUP BY p.product_type;
    

# How many unique customers made purchases in each market zone
SELECT m.zone, COUNT(DISTINCT t.customer_code) AS Unique_Customers
FROM transactions t
JOIN markets m 
ON t.market_code = m.market_code
GROUP BY m.zone;
    
    
# What is the total sales revenue for each month of the year
SELECT month_name, SUM(sales_amount) AS Total_Revenue
FROM transactions t
JOIN date d 
ON t.order_date = d.date
GROUP BY month_name;
    
    
# Which customer has made the highest total purchase amount
SELECT customer_name, SUM(sales_amount) AS Total_Purchase_Amount
FROM transactions t
JOIN customers c 
ON t.customer_code = c.customer_code
GROUP BY customer_name
ORDER BY Total_Purchase_Amount DESC
LIMIT 1;


# What is the average profit margin percentage for each product type
SELECT product_type, AVG(profit_margin_percentage) AS Average_Profit_Margin_Percentage
FROM transactions t
JOIN products p 
ON t.product_code = p.product_code
GROUP BY product_type;
    

# What is the average profit margin percentage per customer type
SELECT c.customer_type, AVG(t.profit_margin_percentage) AS avg_profit_margin_percentage
FROM customers c
JOIN transactions t 
ON c.customer_code = t.customer_code
GROUP BY c.customer_type;


# How does the sales quantity vary across different customer types for a specific product 
SELECT customer_type, SUM(sales_qty) AS Total_Sales_Quantity
FROM transactions t
JOIN customers c 
ON t.customer_code = c.customer_code
WHERE t.product_code = 'Prod022'
GROUP BY customer_type;


# Total sales amount for each market zone in a specific month
SELECT m.zone, SUM(t.sales_amount) AS total_sales_amount
FROM markets m
JOIN transactions t 
ON m.market_code = t.market_code
JOIN date d 
ON t.order_date = d.date
WHERE d.month_name = 'January' AND d.year = 2019
GROUP BY m.zone;


# Customers who have purchased from more than one market
SELECT c.customer_name, COUNT(DISTINCT t.market_code) AS num_markets_purchased_from
FROM customers c
JOIN transactions t 
ON c.customer_code = t.customer_code
GROUP BY c.customer_name
HAVING num_markets_purchased_from > 1
ORDER BY num_markets_purchased_from DESC;


# Products with the highest profit margin percentage in each market
SELECT m.market_name, p.product_code, p.product_type,
MAX(t.profit_margin_percentage) AS max_profit_margin_percentage
FROM markets m
JOIN transactions t 
ON m.market_code = t.market_code
JOIN products p 
ON t.product_code = p.product_code
GROUP BY m.market_name, p.product_code, p.product_type;


# How can we categorize products into three groups based on their sales quantity: Low, Medium, and High
SELECT product_code,
       CASE 
           WHEN sales_qty < 100 THEN 'Low'
           WHEN sales_qty >= 100 AND sales_qty <= 500 THEN 'Medium'
           ELSE 'High'
       END AS sales_quantity_category
FROM transactions;


# How can we find the monthly sales trend for a specific market zone
WITH MonthlySales AS (
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
           SUM(sales_amount) AS total_sales_amount
    FROM transactions
    GROUP BY month
)
SELECT month, total_sales_amount
FROM MonthlySales;
