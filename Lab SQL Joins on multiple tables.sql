-- Lab | SQL Joins on multiple tables

use sakila;

-- Write a query to display for each store its store ID, city, and country.
select * from store;
select * from address;
select * from city;
select * from country;

select store_id, city, country from store
join address
using(address_id)
join city
using(city_id)
join country
using(country_id);

-- Write a query to display how much business, in dollars, each store brought in.
select * from store;
select * from payment;
select * from customer;

select store_id, sum(amount) from store
join customer 
using(store_id)
join payment
using(customer_id)
group by store_id;

-- What is the average running time of films by category?
select * from film;
select * from film_category;
select * from category;

select name as category, round(avg(length),2) as average_duration from film
join film_category
using(film_id)
join category
using(category_id)
group by name;

-- Which film categories are longest?
select * from film;
select * from film_category;
select * from category;

# don't know how to do it without the second select
select category, length from ( 

select name as category, length, rank() over(order by length desc) as ranking from film
join film_category
using(film_id)
join category
using(category_id)
# having ranking = 1; -- does not work here, therefore have to use second select?

) t
where ranking = 1;

-- Display the most frequently rented movies in descending order.
select * from film;
select * from inventory;
select * from rental;

select title, count(film_id) as rentals from film
join inventory
using(film_id)
join rental
using(inventory_id)
group by film_id
order by count(film_id) desc;

-- List the top five genres in gross revenue(sum) in descending order.
select * from film;
select * from film_category;
select * from category;

select * from inventory;
select * from rental;
select * from payment;

select name, sum(amount) from film
join film_category
using(film_id)
join category
using(category_id)
join inventory # now we have the genre
using(film_id)
join rental
using(inventory_id)
join payment
using(rental_id) # now we have the amount
group by name
order by sum(amount) desc
limit 5;

-- Is "Academy Dinosaur" available for rent from Store 1?
select film.film_id, film.title, store.store_id, inventory.inventory_id
from inventory 
join store 
using (store_id) 
join film 
using (film_id)
where film.title = 'Academy Dinosaur' and store.store_id = 1;