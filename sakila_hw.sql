use sakila;
-- 1a.
select first_name, last_name from actor;

-- 1b.
select concat(first_name," ",last_name) as Actor_Name from actor;

-- 2a.
select actor_id, first_name, last_name from actor
where first_name = "Joe";

-- 2b.
select actor_id, first_name, last_name from actor
where last_name like "%gen%";

-- 2c.
select actor_id, first_name, last_name from actor
where last_name like "%li%"
order by last_name, first_name;

-- 2d.
select country_id, country from country
where country in ('afghanistan', 'bangladesh', 'china');

-- 3a.
alter table actor 
 add middle_name varchar(50);
select actor_id, first_name, middle_name, last_name, last_update from actor;

-- 3b.
alter table actor
modify middle_name blob;

-- 3c.
alter table actor
drop column middle_name;

-- 4a.
select last_name, count(last_name) as 'Name Count' from actor 
group by last_name order by count(last_name) desc;

-- 4b.
select last_name, count(last_name) as 'Name Count' from actor 
group by last_name
having count(last_name) >= 2 
order by count(last_name) desc;

-- 4c.
update actor
set first_name = "HARPO"
where first_name = "groucho" and last_name = "williams";
select * from actor;

-- 4d.
set SQL_SAFE_UPDATES = 0;
update actor
set first_name = 
case when first_name = "HARPO"
then "GROUCHO"  when first_name = "GROUCHO" 
then "MUCHO GROUCHO"
else first_name
end;
select * from actor;

-- 5a.
show create table address;

-- 6a.
select staff.first_name,staff.last_name, address.address from staff
join address on staff.address_id = address.address_id;

-- 6b.
select staff.staff_id, staff.first_name, staff.last_name, sum(payment.amount) from staff
join payment on staff.staff_id = payment.staff_id 
where payment.payment_date like "2005-08%"
group by staff.staff_id;

-- 6c.
select film.title, film.film_id, count(film_actor.actor_id) as 'Number of Actors' from film
join film_actor on film.film_id = film_actor.film_id
group by film.title;

-- 6d.
select film.title, count(inventory.film_id) as 'Number of Copies of Hunchback Impossible' from inventory
join film on inventory.film_id = film.film_id 
group by film.title
having film.title = "Hunchback Impossible";

-- 6e.
select customer.first_name, customer.last_name, payment.customer_id, sum(payment.amount) as 'Total Amount Paid' from customer
join payment on payment.customer_id = customer.customer_id
group by payment.customer_id
order by customer.last_name asc;

-- 7a.
select film.title, film.film_id from film
join language on language.language_id = film.language_id
where language.language_id = (select language.language_id from language 
	where language.name = "English") AND (film.title like "K%" OR film.title like "Q%")
group by film.title;

-- 7b.
select actor_id, first_name, last_name from actor where actor_id in 
(select actor_id from film_actor where film_id=
(select film.film_id from film where film.title = 'ALONE TRIP'))
group by actor_id
order by actor.last_name asc;

-- 7c.
select first_name, last_name, email from customer
join address on customer.address_id = address.address_id
join city on city.city_id = address.city_id
join country on city.country_id = country.country_id where country = "Canada";

-- 7d.
select title, film_id from film where film_id in
(select film_id from film_category  where category_id =
(select category_id from category where category.name = "family"));

-- 7e.
select film.title, count(rental.rental_id) as 'Number Of Rentals' from film 
join inventory on inventory.film_id = film.film_id
join rental on rental.inventory_id = inventory.inventory_id
group by film.title
order by count(rental.rental_id) desc;

-- 7f.
select store.store_id, sum(payment.amount) as 'Total Revenue ($)' from store
join customer on customer.store_id = store.store_id
join payment on payment.customer_id = customer.customer_id
group by store.store_id;

-- 7g.
select store.store_id, city.city, country.country from store
join address on address.address_id = store.address_id
join city on city.city_id = address.city_id
join country on city.country_id = country.country_id;

-- 7h.
select name, sum(payment.amount) as 'Total Revenue ($)' from category
join film_category on category.category_id = film_category.category_id
join film on film.film_id = film_category.film_id
join inventory on inventory.film_id = film.film_id
join rental on inventory.inventory_id = rental.inventory_id
join payment on rental.rental_id = payment.rental_id
group by category.name 
order by category.name asc;

-- 8a.
create view Top_5_Genres as 
(select name, sum(payment.amount) as 'Total Revenue ($)' from category
join film_category on category.category_id = film_category.category_id
join film on film.film_id = film_category.film_id
join inventory on inventory.film_id = film.film_id
join rental on inventory.inventory_id = rental.inventory_id
join payment on rental.rental_id = payment.rental_id
group by category.name 
order by sum(payment.amount) desc limit 5);


-- 8b.
select * from Top_5_Genres;

-- 8c. 
drop view Top_5_Genres;