--1
UPDATE rental
SET status = CASE
	WHEN AGE(rental_date, return_date) < INTERVAL '7 days' THEN 'early'
	WHEN AGE(rental_date, return_date) = INTERVAL '7 days' THEN 'on time'
	ELSE 'late'
END;
SELECT * FROM rental;

--2
SELECT SUM(payment.amount) AS total_amount
FROM payment
JOIN customer ON customer.customer_id = payment.customer_id
JOIN address ON address.address_id = customer.address_id
JOIN city ON city.city_id = address.city_id
WHERE city.city IN ('Kansas City', 'Saint Louis');

--3
SELECT category.name, COUNT(film.film_id)
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name;

--4
-- film_category is used for relations between film and category

--5
SELECT film.film_id, film.title, film.length
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE rental.return_date BETWEEN '2005-05-15' AND '2005-05-31' ;

--6 
SELECT film.film_id, film.title, film.rental_rate
FROM film
WHERE film.rental_rate < (SELECT AVG(film.rental_rate) FROM film) ;

--7
SELECT status, COUNT(*) AS count FROM rental
GROUP BY status ;

--8 
SELECT film.title, film.length, PERCENT_RANK() OVER (ORDER BY film.length) AS percentile
FROM film;

--9
EXPLAIN ANALYZE
SELECT city, SUM(amount) AS total_payments
FROM payment
JOIN customer ON payment.customer_id = customer.customer_id
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
WHERE city.city IN ('Kansas City', 'Saint Louis')
GROUP BY city;

EXPLAIN ANALYZE
SELECT film.film_id, film.title, film.rental_rate
FROM film
WHERE film.rental_rate < (SELECT AVG(rental_rate) FROM film);

-- Since the first query has so many join statements,
-- more operations have to be performed (nested loops, etc ) takes more time and space
-- The second query is much less complex and only reads a single table 
-- so it takes less memory and executes faster

--ec
-- set-based programming languages (SQL) perform operations on data as a whole
-- without explicitly iterating line by line
-- procedural languages (like Python) iterates through operations in a specific order
-- according to set conditions
