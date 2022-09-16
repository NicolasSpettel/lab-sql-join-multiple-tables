-- Lab | SQL Joins on multiple tables

use sakila;

-- Write a query to display for each store its store ID, city, and country.
SELECT 
    store_id, city, country
FROM
    store
        JOIN
    address USING (address_id)
        JOIN
    city USING (city_id)
        JOIN
    country USING (country_id);

-- Write a query to display how much business, in dollars, each store brought in.
SELECT 
    store_id, SUM(amount)
FROM
    store
        JOIN
    customer USING (store_id)
        JOIN
    payment USING (customer_id)
GROUP BY store_id;

-- What is the average running time of films by category?
SELECT 
    name AS category, ROUND(AVG(length), 2) AS average_duration
FROM
    film
        JOIN
    film_category USING (film_id)
        JOIN
    category USING (category_id)
GROUP BY name;

-- Which film categories are longest?
# don't know how to do it without the second select
SELECT 
    category, length
FROM
    (SELECT 
        name AS category, length, RANK() OVER(ORDER BY length DESC) AS ranking
    FROM
        film
    JOIN film_category USING (film_id)
    JOIN category USING (category_id)) t
WHERE
    ranking = 1;

-- Display the most frequently rented movies in descending order.
SELECT 
    title, COUNT(film_id) AS rentals
FROM
    film
        JOIN
    inventory USING (film_id)
        JOIN
    rental USING (inventory_id)
GROUP BY film_id
ORDER BY COUNT(film_id) DESC;

-- List the top five genres in gross revenue(sum) in descending order.
SELECT 
    name, SUM(amount)
FROM
    film
        JOIN
    film_category USING (film_id)
        JOIN
    category USING (category_id)
        JOIN
    inventory USING (film_id)
        JOIN
    rental USING (inventory_id)
        JOIN
    payment USING (rental_id)
GROUP BY name
ORDER BY SUM(amount) DESC
LIMIT 5;

-- Is "Academy Dinosaur" available for rent from Store 1?
SELECT 
    film.film_id,
    film.title,
    store.store_id,
    inventory.inventory_id
FROM
    inventory
        JOIN
    store USING (store_id)
        JOIN
    film USING (film_id)
WHERE
    film.title = 'Academy Dinosaur'
        AND store.store_id = 1;