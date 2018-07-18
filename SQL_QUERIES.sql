
--  1a. You need a list of all the actors who have Display the first and last names of all actors from the table `actor`. 

SELECT first_name AS 'First Name', last_name AS 'Last Name' 
FROM actor;


--  1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`. 

-- 1st method

-- coverting first name and last name to Upper Case.
UPDATE actor
SET    first_name = UPPER(first_name)
WHERE  first_name != UPPER(first_name);

UPDATE actor
SET    last_name = UPPER(last_name)
WHERE  last_name != UPPER(last_name);

-- concatinating  Last and First name column
SELECT *, CONCAT(last_name ,', ', first_name) AS Actor_Name FROM `actor`;


-- second method
SELECT UPPER(CONCAT(last_name,", ",first_name))
AS Actor_Name FROM actor;





-- * 2a. You need to find the ID number, first name, and last name of an actor, 
--       of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = 'joe';


-- * 2b. Find all actors whose last name contain the letters `GEN`:

SELECT * FROM actor
WHERE last_name LIKE '%GEN%';

-- * 2c. Find all actors whose last names contain the letters `LI`. 
--   This time, order the rows by last name and first name, in that order:

-- 1st Method
SELECT * FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- second method
SELECT actor_id, first_name, last_name FROM actor WHERE INSTR(`last_name`, 'Li')
ORDER BY last_name, first_name;

-- * 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: 
-- Afghanistan, Bangladesh, and China:


SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');






-- * 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. 
-- Hint: you will need to specify the data type.

ALTER table actor
ADD COLUMN middle_name VARCHAR(20) AFTER first_name;

SELECT * FROM actor;

-- * 3b. You realize that some of these actors have tremendously long last names. 
-- Change the data type of the `middle_name` column to `blobs`.

ALTER TABLE actor
DROP middle_name,
ADD COLUMN middle_name BLOB AFTER first_name;

SELECT * FROM actor;

-- * 3c. Now delete the `middle_name` column.

ALTER TABLE actor
DROP middle_name;

SELECT * FROM actor;






-- * 4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name,
COUNT(last_name) AS L_NAME_COUNT
FROM actor
GROUP BY last_name;

-- * 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors

SELECT last_name,
COUNT(last_name) AS L_NAME_COUNT
FROM actor
GROUP BY last_name
HAVING COUNT(*) >=2;

-- * 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, 
-- the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.

UPDATE actor
SET first_name = 'HARPO' 
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- verifying the update
SELECT * FROM actor
WHERE last_name = 'Williams';

-- * 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` 
-- was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, 
-- change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor 
-- will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR 
-- TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)

UPDATE actor 
SET first_name = CASE 
WHEN first_name = 'GROUCHO' AND last_name = 'Williams' THEN 'MUCHO GROUCHO' 
WHEN first_name = 'HARPO' AND last_name = 'Williams' THEN 'GROUCHO'
ELSE first_name
END
WHERE last_name = 'Williams';


-- verifying the update
SELECT * FROM actor
WHERE last_name = 'Williams';



-- * 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?

SHOW CREATE TABLE address;

-- Creating Table 
CREATE TABLE address (
address_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
address VARCHAR(50) NOT NULL,
address2 VARCHAR(50) DEFAULT NULL,
district VARCHAR(20) NOT NULL,
city_id SMALLINT UNSIGNED NOT NULL,
postal_code VARCHAR(10) DEFAULT NULL,
phone VARCHAR(20) NOT NULL,
locatiON GEOMETRY NOT NULL,
last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY  (address_id),
KEY idx_fk_city_id (city_id),
SPATIAL KEY `idx_locatiON` (locatiON),
CONSTRAINT `fk_address_city` FOREIGN KEY (city_id) REFERENCES city (city_id) ON DELETE RESTRICT ON UPDATE CASCADE
)
ENGINE=InnoDB DEFAULT CHARSET=utf8;





-- * 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
-- Use the tables `staff` and `address`:

SELECT first_name, last_name, address
FROM staff
JOIN address ON staff.address_id = address.address_id;


-- * 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. 

SELECT username AS USER_NAME, SUM(amount) AS AMOUNT
FROM STAFF 
JOIN PAYMENT ON staff.staff_id = payment.staff_id
WHERE payment_date BETWEEN '2005-08-01' and '2005-09-01'
GROUP BY username;

-- * 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. 
-- Use inner join.

SELECT title, COUNT(actor_id) AS NUMBER_OF_ACTORS
FROM FILM
INNER JOIN FILM_ACTOR ON FILM.film_id = FILM_ACTOR.film_id
GROUP BY TITLE;


-- * 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

SELECT title, COUNT(inventory_id) AS copies
FROM film
INNER JOIN inventory ON inventory.film_id = film.film_id
WHERE title = 'Hunchback Impossible'
GROUP BY title;

-- * 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
-- List the customers alphabetically by last name:

select first_name, last_name, sum(amount) as Total_paid_by_Customer
from customer
inner join payment on customer.customer_id = payment.customer_id
group by last_name, first_name
order by last_name;




-- * 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. 


SELECT title AS FILM_TITLE
FROM film
WHERE title LIKE 'q%' or title LIKE 'k%' AND language_id IN
(SELECT language_id FROM language
WHERE name = 'english'
);

-- using join
SELECT title
FROM film 
JOIN(language) ON film.language_id = language.language_id
WHERE name = 'English' AND title LIKE 'k%' or title LIKE 'q%';


-- * 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

select first_name, last_name
from actor
where actor_id in (
select actor_id from film_actor
where film_id in
(select film_id
from film 
where title = 'Alone Trip'
));

-- using Join 
SELECT first_name, last_name 
FROM actor 
JOIN(film_actor) ON actor.actor_id = film_actor.actor_id
JOIN(film) ON film_actor.film_id = film.film_id
WHERE title ='ALONE TRIP';


-- * 7c. You want to run an email marketing campaign in Canada, for which you will need the names 
-- and email addresses of all Canadian customers. Use joins to retrieve this information.


SELECT first_name, last_name, email 
FROM customer 
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country = 'Canada';

-- * 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

SELECT title, name 
FROM film_category
JOIN category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
WHERE name = 'family';

-- * 7e. Display the most frequently rented movies in descending order.

SELECT title, COUNT(*) AS Most_Rented
FROM payment
JOIN rental ON payment.rental_id = rental.rental_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
GROUP BY title
ORDER BY COUNT(*) DESC;

-- * 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT store_id, CONCAT('$',FORMAT(sum(amount),2)) AS Total_Revenue_by_Store
FROM staff
JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY store_id;


-- * 7g. Write a query to display for each store its store ID, city, and country.

SELECT store_id, City, country
FROM staff
JOIN address ON staff.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id;


-- * 7h. List the top five genres in gross revenue in descending order. 
-- (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT name AS Genre, concat('$',format(SUM(amount),2)) AS Gross_Revenue FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN inventory ON film_category.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY Genre
ORDER BY SUM(amount) DESC
LIMIT 5;




-- * 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. 
-- If you haven't solved 7h, you can substitute another query to create a view.
Create View Top_5_Genres AS(
	SELECT name AS Genre, concat('$',format(SUM(amount),2)) AS Gross_Revenue FROM category
	JOIN film_category ON category.category_id = film_category.category_id
	JOIN inventory ON film_category.film_id = inventory.film_id
	JOIN rental ON inventory.inventory_id = rental.inventory_id
	JOIN payment ON rental.rental_id = payment.rental_id
	GROUP BY Genre
	ORDER BY SUM(amount) DESC
	LIMIT 5
    );
  	
* 8b. How would you display the view that you created in 8a?

SELECT * FROM Top_5_Genres


-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.

DROP VIEW Top_5_Genres
