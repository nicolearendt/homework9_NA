USE SAKILA;

#1a. Display the first and last names of all actors from the table actor.
SELECT FIRST_NAME, LAST_NAME FROM SAKILA.ACTOR;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) AS 'Actor Name' FROM SAKILA.ACTOR;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT ACTOR_ID, FIRST_NAME, LAST_NAME FROM SAKILA.ACTOR WHERE FIRST_NAME = 'Joe';

#2b. Find all actors whose last name contain the letters GEN:
SELECT * FROM SAKILA.ACTOR WHERE LAST_NAME LIKE '%GEN%';

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT LAST_NAME, FIRST_NAME FROM SAKILA.ACTOR WHERE LAST_NAME LIKE '%LI%';

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT COUNTRY_ID, COUNTRY FROM SAKILA.COUNTRY WHERE COUNTRY IN ('Afghanistan','Bangladesh','China');

#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
#    so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE SAKILA.ACTOR ADD description BLOB;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE SAKILA.ACTOR DROP COLUMN description;

#4a. List the last names of actors, as well as how many actors have that last name.
SELECT LAST_NAME, COUNT(*) AS 'COUNT' FROM SAKILA.ACTOR GROUP BY LAST_NAME;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT LAST_NAME, COUNT(*) AS 'COUNT' FROM SAKILA.ACTOR GROUP BY LAST_NAME HAVING COUNT >= 2;

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE SAKILA.ACTOR SET FIRST_NAME = 'HARPO' WHERE FIRST_NAME = 'GROUCHO' AND LAST_NAME = 'WILLIAMS';

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE SAKILA.ACTOR SET FIRST_NAME = 'GROUCHO' WHERE FIRST_NAME = 'HARPO';

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
#Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
DESCRIBE SAKILA.ADDRESS;
#OR
SHOW CREATE TABLE SAKILA.ADDRESS;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT S.FIRST_NAME, S.LAST_NAME, A.ADDRESS FROM SAKILA.STAFF S
JOIN SAKILA.ADDRESS A ON S.ADDRESS_ID = A.ADDRESS_ID;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT S.FIRST_NAME, S.LAST_NAME, SUM(P.AMOUNT) AS 'TOTAL' FROM SAKILA.STAFF S
JOIN SAKILA.PAYMENT P ON S.STAFF_ID = P.STAFF_ID AND PAYMENT_DATE LIKE '2005-08%'
GROUP BY S.FIRST_NAME, S.LAST_NAME;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT F.TITLE, COUNT(A.ACTOR_ID) AS 'NUMBER OF ACTORS' FROM SAKILA.FILM F
INNER JOIN SAKILA.FILM_ACTOR A ON F.FILM_ID = A.FILM_ID GROUP BY F.TITLE;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT F.TITLE, COUNT(I.FILM_ID) AS 'COPIES' FROM SAKILA.FILM F
JOIN SAKILA.INVENTORY I ON F.FILM_ID = I.FILM_ID AND F.TITLE = 'HUNCHBACK IMPOSSIBLE' GROUP BY F.TITLE;

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT C.FIRST_NAME, C.LAST_NAME, SUM(P.AMOUNT) AS 'TOTAL AMOUNT PAID' FROM SAKILA.CUSTOMER C
JOIN SAKILA.PAYMENT P ON C.CUSTOMER_ID = P.CUSTOMER_ID 
GROUP BY C.FIRST_NAME, C.LAST_NAME ORDER BY C.LAST_NAME;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
#    Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT F.TITLE FROM SAKILA.FILM F
JOIN SAKILA.LANGUAGE L ON F.LANGUAGE_ID = L.LANGUAGE_ID AND L.NAME = 'English'
WHERE F.TITLE LIKE 'K%' OR F.TITLE LIKE 'Q%';

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT FIRST_NAME, LAST_NAME
FROM SAKILA.ACTOR A
	JOIN SAKILA.FILM_ACTOR B
	ON A.ACTOR_ID = B.ACTOR_ID
	JOIN SAKILA.FILM C
	ON B.FILM_ID = C.FILM_ID
WHERE C.TITLE = "Alone Trip";

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT A.FIRST_NAME, A.LAST_NAME, A.EMAIL
FROM SAKILA.CUSTOMER A
	JOIN SAKILA.ADDRESS B
	ON A.ADDRESS_ID = B.ADDRESS_ID
	JOIN SAKILA.CITY C
	ON B.CITY_ID = C.CITY_ID
    JOIN SAKILA.COUNTRY D
    ON C.COUNTRY_ID = D.COUNTRY_ID
WHERE D.COUNTRY = "CANADA";

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT A.TITLE
FROM SAKILA.FILM A
	JOIN SAKILA.FILM_CATEGORY B
	ON A.FILM_ID = B.FILM_ID
	JOIN SAKILA.CATEGORY C
	ON B.CATEGORY_ID = C.CATEGORY_ID
WHERE C.NAME = "FAMILY";

#7e. Display the most frequently rented movies in descending order.
SELECT C.TITLE, COUNT(A.RENTAL_ID)
FROM SAKILA.RENTAL A
	JOIN SAKILA.INVENTORY B
	ON A.INVENTORY_ID = B.INVENTORY_ID
	JOIN SAKILA.FILM C
	ON B.FILM_ID = C.FILM_ID
GROUP BY C.TITLE ORDER BY COUNT(A.RENTAL_ID) DESC;

#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT B.STORE_ID, SUM(A.AMOUNT) AS 'TOTAL'
FROM SAKILA.PAYMENT A
	JOIN SAKILA.STORE B
	ON A.STAFF_ID = B.MANAGER_STAFF_ID
GROUP BY B.STORE_ID;

#7g. Write a query to display for each store its store ID, city, and country.
SELECT A.STORE_ID, C.CITY, D.COUNTRY
FROM SAKILA.STORE A
JOIN SAKILA.ADDRESS B
ON A.ADDRESS_ID = B.ADDRESS_ID
JOIN SAKILA.CITY C
ON B.CITY_ID = C.CITY_ID
JOIN SAKILA.COUNTRY D
ON C.COUNTRY_ID = D.COUNTRY_ID;

#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT A.NAME, SUM(E.AMOUNT)
FROM SAKILA.CATEGORY A
JOIN SAKILA.FILM_CATEGORY B
ON A.CATEGORY_ID = B.CATEGORY_ID
JOIN SAKILA.INVENTORY C
ON B.FILM_ID = C.FILM_ID
JOIN SAKILA.RENTAL D
ON C.INVENTORY_ID = D.INVENTORY_ID
JOIN SAKILA.PAYMENT E
ON D.RENTAL_ID = E.RENTAL_ID
GROUP BY A.NAME 
ORDER BY SUM(E.AMOUNT) DESC LIMIT 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
#    Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
USE SAKILA;
CREATE VIEW top_five_genres AS
SELECT A.NAME, SUM(E.AMOUNT)
FROM SAKILA.CATEGORY A
JOIN SAKILA.FILM_CATEGORY B
ON A.CATEGORY_ID = B.CATEGORY_ID
JOIN SAKILA.INVENTORY C
ON B.FILM_ID = C.FILM_ID
JOIN SAKILA.RENTAL D
ON C.INVENTORY_ID = D.INVENTORY_ID
JOIN SAKILA.PAYMENT E
ON D.RENTAL_ID = E.RENTAL_ID
GROUP BY A.NAME 
ORDER BY SUM(E.AMOUNT) DESC LIMIT 5;

#8b. How would you display the view that you created in 8a?
SELECT * FROM sakila.top_five_genres;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five_genres;