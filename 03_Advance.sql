-- =====================================
-- ADVANCE - Question 1
-- =====================================
/* Find  how  much  amount  spent  by  each  customer  on  artists?  Write  a  query  to  return 
customer name, artist name and total spent */

WITH best_selling_artist AS (
	SELECT
		artist.artist_id AS artist_id,
		artist.name AS artist_name,
		SUM(invoice_line.quantity * invoice_line.unit_price) AS total_sales
	FROM artist
	JOIN album ON artist.artist_id = album.artist_id
	JOIN track ON album.album_id = track.album_id
	JOIN invoice_line ON track.track_id = invoice_line.track_id
	GROUP BY 1, 2
	ORDER BY 3 DESC
	LIMIT 1
)

SELECT
	c.customer_id,
	c.first_name,
	c.last_name,
	bsa.artist_name,
	SUM(il.unit_price * il.quantity) AS amount_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN album al ON t.album_id = al.album_id
JOIN best_selling_artist bsa ON al.artist_id = bsa.artist_id
GROUP BY 1, 2, 3, 4
ORDER BY 5 DESC;

-- =====================================
-- ADVANCE - Question 2
-- =====================================
/* We want to find out the most popular music Genre for each country. We determine the 
most popular genre as the genre with the highest amount of purchases. Write a query 
that returns each country along with the top Genre. For countries where the maximum 
number of purchases is shared return all Genres */

WITH popular_genre AS (
	SELECT 
		c.country,
		g.name,
		g.genre_id,
		COUNT(il.*) AS purchases,
		ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY COUNT(il.*) DESC) AS row_no
	FROM customer c
	JOIN invoice i ON c.customer_id = i.customer_id
	JOIN invoice_line il ON i.invoice_id = il.invoice_id
	JOIN track t ON il.track_id = t.track_id
	JOIN genre g ON t.genre_id = g.genre_id
	GROUP BY 1, 2, 3
	ORDER BY 1 ASC, 4 DESC
)

SELECT 
	pg.genre_id,
	pg.country,
	pg.name,
	pg.purchases
FROM popular_genre pg
WHERE row_no <= 1;

-- =====================================
-- ADVANCE - Question 3
-- =====================================
/* Write a query that determines the customer that has spent the most on music for each 
country. Write a query that returns the country along with the top customer and how 
much  they  spent.  For  countries  where  the  top  amount  spent  is  shared,  provide  all 
customers who spent this amount  */

WITH RECURSIVE 
	customer_with_country AS (
		SELECT
			c.customer_id,
			c.first_name,
			c.last_name,
			i.billing_country,
			SUM(i.total) AS total_spending
		FROM customer c
		JOIN invoice i ON c.customer_id = i.customer_id
		GROUP BY 1, 2, 3, 4
		ORDER BY 1, 5 DESC
	),

	country_max_spending AS (
		SELECT
			billing_country,
			MAX(total_spending) AS max_spending
		FROM customer_with_country
		GROUP BY billing_country
	)

SELECT
	cc.first_name,
	cc.last_name,
	cc.billing_country,
	cc.total_spending
FROM customer_with_country cc
JOIN country_max_spending ms
ON cc.billing_country = ms.billing_country
WHERE cc.total_spending = ms.max_spending
ORDER BY 3;