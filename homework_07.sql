-- 1. Show all customers whose last names start with T. Order them by first name from A-Z.
SELECT first_name, last_name 
FROM customer 
WHERE SUBSTRING(last_name FROM 1 FOR 1) = 'T' 
ORDER BY first_name ;

--2. Show all rentals returned from 5/28/2005 to 6/1/2005
SELECT * FROM rental
WHERE return_date BETWEEN '2005/05/28' AND '2005/06/01'
ORDER BY return_date ;

-- 3. Show the top 10 movies rented the most.
SELECT film.title 
FROM rental
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id 
GROUP BY title
ORDER BY COUNT(rental_id) DESC
LIMIT 10 ;

-- 4. Show how much each customer spent on movies (for all time). Order them from least to most.
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS full_name,
SUM(payment.amount) AS total_amount 
FROM customer
INNER JOIN payment ON payment.customer_id = customer.customer_id
GROUP BY full_name 
ORDER BY total_amount ASC ;

-- 5. Which actor was in the most movies in 2006? Order the results from most to least.
SELECT 
CONCAT(actor.first_name, ' ', actor.last_name) AS full_name,
COUNT(actor.actor_id) AS movie_count
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
GROUP BY full_name
ORDER BY movie_count DESC ; -- Susan Davis was in the most movies in 2006

-- 6. 
EXPLAIN ANALYZE
SELECT customer.customer_id, SUM(amount)
FROM payment
JOIN customer ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY SUM (amount)
-- sorts results by amount spent (SUM(payment.amount))
-- processes 599 rows in 5.969-5.986ms using quicksort alg (43kB)
-- HashAggregate aggregates total spending by customer
-- group key is customer.customer_id (297kB)
-- hash Join joins payment and customer tables using customer_id as the key
-- scans the payment table (14596 rows)
-- scans the customer table (599 rows)
-- planning time: 0.339ms
-- execution time: 3.280ms

EXPLAIN ANALYZE
SELECT actor.first_name ||' '|| actor.last_name as actor_name, COUNT(actor.actor_id) as total_movies
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
WHERE film.release_year = 2006
GROUP BY actor_name
ORDER BY total_movies DESC
LIMIT 1 ;
-- 1 result gets returned after sorting (1.590ms).
-- actors are sorted by the amount of movies they appeared in
-- uses top-N heapsort algo (25kB memory)
-- HashAggregate aggregates actor names and counts how many movies they appeared in (1.571ms)
-- Hash Join joins film_actor and film tables to get the list of actors and films released in 2006 
-- Seq Scan is used on payment and customer
-- planning time: 0.339ms
-- execution time: 3.280

-- 7.
SELECT category.name AS genre, AVG(film.rental_rate) 
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY genre ;

-- 8.
SELECT category.name AS genre, COUNT(rental.rental_id), SUM(payment.amount)
FROM rental
JOIN payment ON rental.rental_id = payment.rental_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY genre
ORDER BY COUNT(rental.rental_id) DESC
LIMIT 5 ;

--ec
SELECT to_char(rental.rental_date, 'Month') AS month, category.name AS genre, COUNT(rental.rental_id)
FROM rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
GROUP BY month, genre
ORDER BY month





	