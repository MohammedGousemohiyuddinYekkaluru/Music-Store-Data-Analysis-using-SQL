-- =====================================
-- MODERATE - Question 1
-- =====================================
/* Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A
*/

SELECT DISTINCT
	c.email,
	c.first_name,
	c.last_name,
	g.name AS genre
FROM customer c
LEFT JOIN invoice i
ON c.customer_id = i.customer_id
LEFT JOIN invoice_line il
ON i.invoice_id = il.invoice_id
LEFT JOIN track t
ON il.track_id = t.track_id
LEFT JOIN genre g
ON t.genre_id = g.genre_id
WHERE g.name LIKE '%Rock%'
ORDER BY email;

-- OR

SELECT DISTINCT
	c.email,
	c.first_name,
	c.last_name
FROM customer c
LEFT JOIN invoice i
ON c.customer_id = i.customer_id
LEFT JOIN invoice_line il
ON i.invoice_id = il.invoice_id
WHERE track_id IN (
	SELECT t.track_id
	FROM track t
	LEFT JOIN genre g
	ON t.genre_id = g.genre_id
	WHERE g.name LIKE 'Rock'
)
ORDER BY c.email;

-- =====================================
-- MODERATE - Question 2
-- =====================================
/* Let's invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands
*/

SELECT
	a.name,
	COUNT(*) AS track_count
FROM artist a
LEFT JOIN album al
ON a.artist_id = al.artist_id
WHERE al.artist_id IN (
	SELECT t.album_id
	FROM track t
	LEFT JOIN genre g
	ON t.genre_id = g.genre_id
	WHERE g.name LIKE 'Rock'
)
GROUP BY a.name
ORDER BY track_count DESC
LIMIT 10;

-- OR

SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) AS number_of_songs
FROM artist
JOIN album ON artist.artist_id = album.artist_id
JOIN track ON album.album_id = track.album_id 
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;

-- =====================================
-- MODERATE - Question 3
-- =====================================
/* Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first
*/

SELECT 
	name,
	milliseconds
FROM track
WHERE milliseconds > (SELECT AVG(milliseconds) from track)
ORDER BY milliseconds DESC;