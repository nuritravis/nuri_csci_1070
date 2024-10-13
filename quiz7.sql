-- 1.
SELECT amount FROM payment 
WHERE amount >= 9.99 ;

-- 2.
SELECT title FROM payment
INNER JOIN rental ON payment.rental_id = rental.rental_id 
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id 
INNER JOIN film ON inventory.film_id = film.film_id 
WHERE amount = (SELECT MAX(amount) FROM payment) ;

-- 3.
SELECT CONCAT(staff.first_name,' ',staff.last_name) AS full_name, staff.email, address, city, country
FROM staff 
INNER JOIN address ON staff.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id ;
-- 4.
/*
I'm not sure exactly what industry i want to work in, but i do know that i want to use CS skills to improve the lives of others in some way, be paid well to do that, and have a good work-life balance.
I think i would have the best chance of finding that in industries where i can use data science or cybersecurity knowledge, so healthcare, finance or industries like those that arent directly technology related.
*/

/*
crows foot notation shows the relationship between data tables.
In the relationship between city and address, the crows foot used means that each address is in 
one and only one city, and each city can have zero to many addresses in it.
*/