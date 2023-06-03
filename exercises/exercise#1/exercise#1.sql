USE sakila;

-- 1.
SELECT *
FROM actor
WHERE last_name LIKE 'T%Y';


-- 2. 
SELECT * 
FROM film 
WHERE length > 100 AND length < 120;


-- 3. 
SELECT film_id, title, name
FROM film
INNER JOIN language USING (language_id);


-- 4. 
SELECT film_id, actor_id, first_name, last_name
FROM film
INNER JOIN film_actor USING (film_id)
INNER JOIN actor USING (actor_id)
WHERE film_id = 1;

-- 5.
SELECT film_id, actor_id, first_name, last_name
FROM film
INNER JOIN film_actor USING (film_id)
INNER JOIN actor USING (actor_id)
WHERE title = 'ANGELS LIFE';

# Alternative Query:
SELECT film_id, actor_id, first_name, last_name
FROM film
INNER JOIN film_actor USING (film_id)
INNER JOIN actor USING (actor_id)
WHERE film_id IN (
	SELECT film_id
    FROM film
    WHERE title = 'ANGELS LIFE'
);


-- 6.
SELECT actor_id, film_id, title
FROM actor 
INNER JOIN film_actor USING (actor_id)
INNER JOIN film USING (film_id)
WHERE actor_id = 2;

-- 7. 
SELECT store_id, city, country
FROM store
INNER JOIN address USING (address_id)
INNER JOIN city USING (city_id)
INNER JOIN country USING (country_id);



-- 8. 
# A)
SELECT film_id, title, name
FROM film
INNER JOIN film_category USING (film_id)
INNER JOIN category USING (category_id);

# B)
SELECT film_id, title, name
FROM film
INNER JOIN film_category USING (film_id)
INNER JOIN category USING (category_id)
WHERE name = 'Action';

# C)
SELECT COUNT(*)
FROM film
INNER JOIN film_category USING (film_id)
INNER JOIN category USING (category_id)
WHERE name = 'Animation';


-- 9. 
SELECT payment_id, customer_id, first_name, last_name
FROM payment
INNER JOIN customer USING (customer_id)
WHERE amount = (
	SELECT MAX(amount)
    FROM payment
);

-- 10. 
SELECT DISTINCT customer_id, first_name, last_name 
FROM customer
INNER JOIN payment USING (customer_id)
WHERE amount > (
	SELECT AVG(amount)
    FROM payment
);


-- 11. 
SELECT DISTINCT customer_id, first_name, last_name
FROM customer
INNER JOIN store USING (store_id)
INNER JOIN inventory USING (store_id)
INNER JOIN film USING (film_id)
INNER JOIN film_category USING (film_id)
INNER JOIN category USING (category_id)
WHERE name = 'Sci-Fi'
ORDER BY customer_id;


-- 12. 
SELECT SUM(amount)
FROM store
INNER JOIN customer USING(store_id)
INNER JOIN payment USING(customer_id)
WHERE store_id = 1;



