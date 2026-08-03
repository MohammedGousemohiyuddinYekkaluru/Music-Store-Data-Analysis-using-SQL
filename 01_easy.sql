-- =====================================
-- EASY - Question 1
-- =====================================
-- Who is the senior most employee based on job title? 

SELECT * FROM employee;

SELECT
	first_name,
	last_name,
	title
FROM employee
ORDER BY levels DESC
LIMIT 1;

-- =====================================
-- EASY - Question 2
-- =====================================
-- Which countries have the most Invoices?

SELECT * FROM invoice;

SELECT
	billing_country,
	COUNT(*) AS Total_Invoices
FROM invoice
GROUP BY billing_country
ORDER BY Total_Invoices DESC;

-- =====================================
-- EASY - Question 3
-- =====================================
-- What are top 3 values of total invoice? 

SELECT
	billing_country,
	COUNT(*) AS Total_Invoices
FROM invoice
GROUP BY billing_country
ORDER BY Total_Invoices DESC
LIMIT 3;

-- =====================================
-- EASY - Question 4
-- =====================================
/* Which  city  has  the  best  customers?  We  would  like  to  throw  a  promotional  Music 
Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice 
totals */

SELECT
	billing_city,
	COUNT(*) AS Total_Invoices
FROM invoice
GROUP BY billing_city
ORDER BY Total_Invoices DESC
LIMIT 1;

SELECT
	billing_city,
	SUM(total) AS Invoice_Totals
FROM invoice
GROUP BY billing_city
ORDER BY Invoice_Totals DESC
LIMIT 1;

-- =====================================
-- EASY - Question 5
-- =====================================
/* Who  is  the  best  customer?  The  customer  who  has  spent  the  most  money  will  be 
declared the best customer. Write a query that returns the person who has spent the 
most money */

SELECT * FROM customer;

SELECT
	c.customer_id,
	CONCAT(c.first_name, c.last_name) AS customer_name,
	SUM(i.total) AS total_spending
FROM customer c
LEFT JOIN invoice i
ON c.customer_id = i.customer_id
GROUP BY c.customer_id
ORDER BY total_spending DESC
LIMIT 1;


SELECT customer.customer_id, first_name, last_name, SUM(total) AS total_spending
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total_spending DESC
LIMIT 1;