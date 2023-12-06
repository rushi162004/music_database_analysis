--Who is the senior most employee based on job title?

SELECT first_name,last_name,title 
FROM employee
ORDER BY levels DESC
limit 1;

--Which countries have the most Invoices?
SELECT billing_country, COUNT(*) AS total_invoice
FROM invoice
GROUP BY billing_country
ORDER BY total_invoice DESC
limit 1;

--What are top 3 values of total invoice?
SELECT invoice_id,total 
FROM invoice
ORDER BY total DESC
limit 3;
--Which city has the best customers? We would like to throw a promotional Music
--Festival in the city we made the most money. Write a query that returns one city that
--has the highest sum of invoice totals. Return both the city name & sum of all invoice
--totals
SELECT billing_city, SUM(total) AS total_invoice
FROM invoice
GROUP BY billing_city
ORDER BY total_invoice DESC
limit 1;

--Who is the best customer? The customer who has spent the most money will be
--declared the best customer. Write a query that returns the person who has spent the
--most money

SELECT c.customer_id,c.first_name,c.last_name,SUM(i.total) AS total_spending
FROM customer c
INNER JOIN invoice i
ON c.customer_id = i.customer_id
GROUP BY c.customer_id
ORDER BY total_spending DESC;


--Write query to return the email, first name, last name, & Genre of all Rock Music
--listeners. Return your list ordered alphabetically by email starting with A

SELECT DISTINCT c.email,c.first_name,c.last_name ,g.name AS genere_name
FROM customer c
INNER JOIN invoice i
ON c.customer_id = i.customer_id
INNER JOIN invoice_line ii
ON i.invoice_id = ii.invoice_id
INNER JOIN track t
ON ii.track_id = t.track_id
INNER JOIN genre g
ON t.genre_id = g.genre_id 
WHERE g.name LIKE 'Rock'
ORDER BY c.email DESC;


--Let's invite the artists who have written the most rock music in our dataset. Write a
--query that returns the Artist name and total track count of the top 10 rock bands.

SELECT ar.name, COUNT(t.track_id) AS total_track
FROM track t
INNER JOIN album al
ON t.album_id = al.album_id
INNER JOIN artist ar
ON al.artist_id = ar.artist_id
JOIN genre g
ON g.genre_id = t.genre_id
WHERE g.name LIKE 'Rock'
GROUP BY ar.artist_id
ORDER BY total_track DESC
LIMIT 10 ;

--Return all the track names that have a song length longer than the average song length
--Return the Name and Milliseconds for each track. Order by the song length with the
--Longest songs listed first

SELECT name,milliseconds
FROM track 
WHERE milliseconds > (SELECT AVG(milliseconds) 
					  AS avg_length 
					  FROM track)
ORDER BY milliseconds DESC;

--Find how much amount spent by each customer on artists? Write a query to return
--customer name, artist name and total spent
SELECT
    c.customer_id,
   CONCAT( c.first_name ,' ' , c.last_name) AS customer_name,
    a.name AS artist_name,
    SUM(il.unit_price * il.quantity) AS total_spent
FROM
    customer c
JOIN
    invoice i ON c.customer_id = i.customer_id
JOIN
    invoice_line il ON i.invoice_id = il.invoice_id
JOIN
    track t ON il.track_id = t.track_id
JOIN
    album al ON t.album_id = al.album_id
JOIN
    artist a ON al.artist_id = a.artist_id
GROUP BY
    c.customer_id, customer_name, a.name
ORDER BY
     customer_id,a.name,total_spent DESC;
	 
--We want to find out the most popular music Genre for each country. We determine the
--most popular genre as the genre with the highest amount of purchases. Write a query
--that returns each country along with the top Genre. For countries where the maximum
--number of purchases is shared return all Genres

WITH CountryGenrePurchases AS (
    SELECT
        c.country,
        g.name AS genre_name,
        SUM(il.quantity) AS total_purchases,
        RANK() OVER (PARTITION BY c.country ORDER BY SUM(il.quantity) DESC) AS genre_rank
    FROM
        customer c
    JOIN
        invoice i ON c.customer_id = i.customer_id
    JOIN
        invoice_line il ON i.invoice_id = il.invoice_id
    JOIN
        track t ON il.track_id = t.track_id
    JOIN
        genre g ON t.genre_id = g.genre_id
    GROUP BY
        c.country, g.name
)
SELECT
    country,
    genre_name,
	total_purchases,
	genre_rank
FROM
    CountryGenrePurchases
WHERE
	genre_rank =1
ORDER BY
    country, total_purchases DESC, genre_name;

--Write a query that determines the customer that has spent the most on music for each
--country. Write a query that returns the country along with the top customer and how
--much they spent. For countries where the top amount spent is shared, provide all
--customers who spent this amount

WITH customer_country AS (
							SELECT  c.customer_id ,
									CONCAT( c.first_name ,' ' , c.last_name) AS customer_name,
									c.country AS country,
									SUM(i.total) AS total_amount,
									RANK() OVER(PARTITION BY c.country ORDER BY SUM(i.total) DESC) AS rank_num
							FROM
								customer c
							JOIN
								invoice i ON c.customer_id = i.customer_id
							JOIN
								invoice_line il ON i.invoice_id = il.invoice_id
							GROUP BY c.customer_id,country
						)
						
SELECT cc.customer_name,
		cc.country,
		cc.total_amount
FROM customer_country cc
WHERE cc.rank_num = 1		
ORDER BY country,total_amount DESC
















