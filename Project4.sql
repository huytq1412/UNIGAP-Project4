/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 'movie' AS table_name, COUNT(*) AS number_of_rows FROM movie;

SELECT 'genre' AS table_name, COUNT(*) AS number_of_rows FROM genre;

SELECT 'director_mapping' AS table_name, COUNT(*) AS number_of_rows FROM director_mapping;

SELECT 'role_mapping' AS table_name, COUNT(*) AS number_of_rows FROM role_mapping;

SELECT 'names' AS table_name, COUNT(*) AS number_of_rows FROM names;

SELECT 'ratings' AS table_name, COUNT(*) AS number_of_rows FROM ratings;

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT  
	COUNT(*) - COUNT(id) AS id_null,
	COUNT(*) - COUNT(title) AS title_null,
	COUNT(*) - COUNT("year") AS year_null,
	COUNT(*) - COUNT(date_published) AS date_published_null,
	COUNT(*) - COUNT(duration) AS duration_null,
	COUNT(*) - COUNT(country) AS country_null,
	COUNT(*) - COUNT(worlwide_gross_income) AS income_null,
	COUNT(*) - COUNT(languages) AS languages_null,
	COUNT(*) - COUNT(production_company) AS production_company_null
FROM movie;

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+
*/

SELECT m."year", COUNT(id) AS number_of_movies
FROM movie m 
GROUP BY m."year"
ORDER BY m."year"; 

/* Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT EXTRACT(MONTH FROM m.date_published) AS month_num, COUNT(id) AS number_of_movies
FROM movie m 
GROUP BY month_num
ORDER BY month_num; 

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT COUNT(id) AS number_of_movies
FROM movie m 
WHERE (m.country ILIKE '%USA%' OR m.country ILIKE '%India%') AND m."year" = 2019;

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT g.genre AS unique_genre
FROM genre g 
GROUP BY g.genre 


/* So, Bee Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT g.genre, COUNT(m.id) AS number_of_movies
FROM genre g
	INNER JOIN movie m ON g.movie_id  = m.id 
GROUP BY g.genre
ORDER BY number_of_movies DESC 
LIMIT 1;

/* So, based on the insight that you just drew, Bee Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH one_genre
AS
(
	SELECT m.id
	FROM movie m
		INNER JOIN genre g ON g.movie_id  = m.id 
	GROUP BY m.id
	HAVING count(genre) = 1
)
SELECT COUNT(*) AS number_of_movies
FROM one_genre;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of Bee Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre, ROUND(AVG(m.duration), 2) AS avg_duration
FROM genre g
	INNER JOIN movie m ON g.movie_id  = m.id 
GROUP BY g.genre


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH movie_count
AS 
(
	SELECT g.genre, COUNT(m.id) AS movie_count
	FROM genre g
		INNER JOIN movie m ON g.movie_id  = m.id 
	GROUP BY g.genre 
),
movie_rank
AS 
(
	SELECT mc.genre, mc.movie_count, RANK() OVER(ORDER BY mc.movie_count DESC) AS genre_rank
	FROM movie_count mc
)
SELECT * 
FROM movie_rank mr
WHERE mr.genre = 'Thriller'

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/



-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT  
	MIN(r.avg_rating) AS min_avg_rating, MAX(r.avg_rating) AS max_avg_rating, 
	MIN(r.total_votes) AS min_total_votes, MAX(r.total_votes) AS max_total_votes, 
	MIN(r.median_rating) AS min_median_rating, MAX(r.median_rating) AS max_median_rating
FROM ratings r;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH movie_ranks
AS 
(
	SELECT m.title, r.avg_rating, DENSE_RANK() OVER(ORDER BY r.avg_rating DESC) AS movie_rank
	FROM movie m 
		INNER JOIN ratings r ON m.id  = r.movie_id 
	ORDER BY r.avg_rating DESC
)
SELECT *
FROM movie_ranks
WHERE movie_rank <= 10;
	

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT r.median_rating, COUNT(m.id) AS movie_count
FROM movie m 
	INNER JOIN ratings r ON m.id  = r.movie_id 
GROUP BY r.median_rating 
ORDER BY r.median_rating


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which Bee Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH movie_count
AS
(
	SELECT COALESCE(m.production_company, 'Others') AS production_company, COUNT(m.id) AS movie_count
	FROM movie m 
		INNER JOIN ratings r ON m.id  = r.movie_id 
	WHERE r.avg_rating > 8 AND m.production_company IS NOT NULL
	GROUP BY m.production_company
),
movie_rank
AS 
(
	SELECT mc.production_company, mc.movie_count, DENSE_RANK() OVER(ORDER BY mc.movie_count DESC) AS prod_company_rank
	FROM movie_count mc
)
SELECT *
FROM movie_rank mr
WHERE mr.prod_company_rank = 1

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre, COUNT(m.id) AS movie_count
FROM genre g 
	INNER JOIN movie m ON g.movie_id  =  m.id
	INNER JOIN ratings r ON m.id  = r.movie_id 
WHERE EXTRACT(MONTH FROM m.date_published) = 3
	AND EXTRACT(YEAR FROM m.date_published) = 2017
	AND m.country = 'USA' 
	AND r.total_votes > 1000
GROUP BY g.genre
ORDER BY movie_count DESC;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.title, r.avg_rating, g.genre 
FROM movie m
	INNER JOIN genre g ON g.movie_id  =  m.id
	INNER JOIN ratings r ON m.id  = r.movie_id 
WHERE m.title ILIKE 'The%' 
    AND r.avg_rating > 8
ORDER BY r.avg_rating DESC;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT COUNT(m.id) AS movie_count
FROM movie m
	INNER JOIN ratings r ON m.id  = r.movie_id 
WHERE m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
	AND r.median_rating = 8;

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH votes_german
AS 
(
	SELECT SUM(r.total_votes) AS votes
	FROM movie m
		INNER JOIN ratings r ON m.id  = r.movie_id 
	WHERE m.languages ILIKE '%German%'
),
votes_italian
AS
(
	SELECT SUM(r.total_votes) AS votes
	FROM movie m
		INNER JOIN ratings r ON m.id  = r.movie_id 
	WHERE m.languages ILIKE '%Italian%'
),
difference
AS
(
	SELECT (SELECT votes FROM votes_german) - (SELECT votes FROM votes_italian) AS difference
)
SELECT CASE WHEN difference > 0 THEN 'German > Italian'
			WHEN difference < 0 THEN 'German < Italian'
			ELSE 'German = Italian' END AS result
FROM difference 
-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/



-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT  
	COUNT(*) - COUNT(id) AS id_nulls,
	COUNT(*) - COUNT(name) AS name_nulls,
	COUNT(*) - COUNT(height) AS height_nulls,
	COUNT(*) - COUNT(date_of_birth) AS date_of_birth_nulls,
	COUNT(*) - COUNT(known_for_movies) AS known_for_movies_nulls
FROM names;

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by Bee Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_genre
AS 
(
	SELECT g.genre, COUNT(g.movie_id) AS movie_count
	FROM genre g 
		INNER JOIN ratings r ON g.movie_id = r.movie_id 
	WHERE r.avg_rating > 8
	GROUP BY g.genre
	ORDER BY movie_count DESC
	LIMIT 3
)
SELECT MAX(n."name") AS director_name, COUNT(dm.movie_id) AS movie_count
FROM names n
	INNER JOIN director_mapping dm ON n.id = dm.name_id
	INNER JOIN genre g ON dm.movie_id = g.movie_id
	INNER JOIN ratings r ON dm.movie_id = r.movie_id
WHERE r.avg_rating > 8
	AND g.genre IN (SELECT genre FROM top_genre)
GROUP BY n.id
ORDER BY movie_count DESC
LIMIT 3;

/* James Mangold can be hired as the director for Bee's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT MAX(n."name") AS actor_name, COUNT(rm.movie_id) AS movie_count
FROM names n
	INNER JOIN role_mapping rm ON n.id = rm.name_id
--	INNER JOIN movie m ON rm.movie_id = m.id
	INNER JOIN ratings r ON rm.movie_id = r.movie_id
WHERE r.median_rating  >= 8
	AND rm.category ILIKE 'actor'
GROUP BY n.id 
ORDER BY movie_count DESC
LIMIT 2;


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
Bee Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH votes_sum
AS
(
	SELECT COALESCE(m.production_company, 'Others') AS production_company, SUM(r.total_votes) AS votes_sum
	FROM movie m 
		INNER JOIN ratings r ON m.id  = r.movie_id 
	WHERE m.production_company IS NOT NULL
	GROUP BY m.production_company
), 
prod_rank
AS
(
	SELECT vs.production_company, vs.votes_sum, DENSE_RANK() OVER(ORDER BY vs.votes_sum DESC) AS prod_comp_rank
	FROM votes_sum vs
)
SELECT *
FROM prod_rank pr
WHERE pr.prod_comp_rank <= 3


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since Bee Movies is based out of Mumbai, India also wants to woo its local audience. 
Bee Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH avg_rating
AS 
(
	SELECT 
		MAX(n."name") AS actor_name,
		SUM(r.total_votes) AS total_votes,
		COUNT(m.id) AS movie_count,
		ROUND(SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes), 2) AS actor_avg_rating
	FROM names n
		INNER JOIN role_mapping rm ON n.id = rm.name_id
		INNER JOIN movie m ON rm.movie_id = m.id
		INNER JOIN ratings r ON rm.movie_id = r.movie_id
	WHERE m.country ILIKE '%India%' 
		AND rm.category ILIKE 'actor'
	GROUP BY n.id 
	HAVING COUNt(m.id) >= 5 
)
SELECT *, RANK() OVER(ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
FROM avg_rating
LIMIT 1;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH avg_rating
AS 
(
	SELECT 
		MAX(n."name") AS actress_name,
		SUM(r.total_votes) AS total_votes,
		COUNT(m.id) AS movie_count,
		ROUND(SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes), 2) AS actress_avg_rating
	FROM names n
		INNER JOIN role_mapping rm ON n.id = rm.name_id
		INNER JOIN movie m ON rm.movie_id = m.id
		INNER JOIN ratings r ON rm.movie_id = r.movie_id
	WHERE m.country ILIKE '%India%' 
		AND m.languages ILIKE '%Hindi%'
		AND rm.category ILIKE 'actress'
	GROUP BY n.id 
	HAVING COUNt(m.id) >= 3 
)
SELECT *, RANK() OVER(ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM avg_rating
LIMIT 5;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT 
	m.title, 
	r.avg_rating,
	CASE 
		WHEN r.avg_rating > 8 THEN 'Superhit movies'
		WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
		WHEN r.avg_rating >= 5 AND r.avg_rating < 7 THEN 'One-time-watch movies'
		ELSE 'Flop movies' 
	END AS classify
FROM movie m 
	INNER JOIN ratings r ON m.id = r.movie_id
	INNER JOIN genre g ON m.id = g.movie_id
WHERE g.genre ILIKE 'Thriller'
ORDER BY r.avg_rating DESC;

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH avg_duration
AS 
(
	SELECT 
		g.genre,
		ROUND(AVG(duration), 2) AS avg_duration
	FROM movie m 
		INNER JOIN genre g ON m.id = g.movie_id
	GROUP BY g.genre
)
SELECT
	genre,
    avg_duration,
	ROUND(SUM(avg_duration) OVER (ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS running_total_duration,
	ROUND(AVG(avg_duration) OVER (ORDER BY genre ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING), 2) AS moving_avg_duration
FROM avg_duration;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH 
top_genre
AS 
(
	SELECT 
		g.genre, COUNT(m.id) AS movie_count
	FROM movie m 
		INNER JOIN genre g ON m.id = g.movie_id
	GROUP BY g.genre
	ORDER BY movie_count DESC
	LIMIT 3
), movie_income
AS 
(
	SELECT 
		g.genre, m.title, m."year", 
		MAX(CAST(TRIM(REGEXP_REPLACE(worlwide_gross_income, '[^0-9.]', '', 'g')) AS BIGINT)) AS numeric_income,
		MAX(TRIM(REGEXP_REPLACE(worlwide_gross_income, '[0-9. ]', '', 'g'))) AS currency_unit
	FROM movie m 
		INNER JOIN genre g ON m.id = g.movie_id
	WHERE g.genre IN (SELECT genre FROM top_genre) AND worlwide_gross_income IS NOT NULL
	GROUP BY g.genre, m.title, m."year" 
),
movie_rank
AS 
(
	SELECT genre, "year", title, currency_unit || ' ' || numeric_income AS worlwide_gross_income, DENSE_RANK() OVER(PARTITION BY "year" ORDER BY numeric_income DESC) AS movie_rank
	FROM movie_income
)
SELECT genre, "year", title AS movie_name, worlwide_gross_income, movie_rank 
FROM movie_rank
WHERE movie_rank <= 5;

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH movie_count
AS
(
	SELECT COALESCE(m.production_company, 'Others') AS production_company, COUNT(m.id ) AS movie_count
	FROM movie m 
		INNER JOIN ratings r ON m.id  = r.movie_id 
	WHERE m.production_company IS NOT NULL 
		AND r.median_rating >= 8
		AND POSITION(',' IN m.languages)>0
	GROUP BY m.production_company
), 
prod_rank
AS
(
	SELECT mv.production_company, mv.movie_count, DENSE_RANK() OVER(ORDER BY mv.movie_count DESC) AS prod_comp_rank
	FROM movie_count mv
)
SELECT *
FROM prod_rank pr
WHERE pr.prod_comp_rank <= 2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH avg_rating
AS 
(
	SELECT 
		MAX(n."name") AS actress_name,
		SUM(r.total_votes) AS total_votes,
		COUNT(rm.movie_id) AS movie_count,
		ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actress_avg_rating
	FROM names n
		INNER JOIN role_mapping rm ON n.id = rm.name_id
		INNER JOIN ratings r ON rm.movie_id = r.movie_id
		INNER JOIN genre g ON rm.movie_id = g.movie_id
    WHERE rm.category = 'actress'
        AND r.avg_rating > 8
        AND g.genre = 'Drama'
	GROUP BY n.id 
)
SELECT *, DENSE_RANK() OVER (ORDER BY movie_count DESC) AS actress_rank
FROM avg_rating
LIMIT 3;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH top_directors
AS 
(
	SELECT n.id, MAX(n."name") AS director_name, COUNT(m.id) AS number_of_movies
	FROM names n
		INNER JOIN director_mapping dm ON n.id = dm.name_id
		INNER JOIN movie m ON dm.movie_id = m.id 
	GROUP BY n.id
	ORDER BY number_of_movies DESC
	LIMIT 9
), date_difference
AS
(
	SELECT 
		n.id, m.title , m.date_published, 
		LEAD(m.date_published) OVER(PARTITION BY n.id ORDER BY m.date_published) - m.date_published AS date_difference
	FROM names n
		INNER JOIN director_mapping dm ON n.id = dm.name_id
		INNER JOIN movie m ON dm.movie_id = m.id 
	WHERE n.id IN (SELECT td.id FROM top_directors td)
)
SELECT 
	td.id AS director_id, MAX(td.director_name) AS director_name, 
	MAX(td.number_of_movies) AS number_of_movies,
	ROUND(AVG(date_difference), 2) AS avg_inter_movie_days,
	ROUND(AVG(r.avg_rating), 2) AS avg_rating,
	SUM(r.total_votes) AS total_votes,
	MIN(r.avg_rating) AS min_rating,
	MAX(r.avg_rating) AS max_rating,
	SUM(m.duration) AS total_duration
FROM top_directors td
	INNER JOIN director_mapping dm ON td.id = dm.name_id
	INNER JOIN movie m ON dm.movie_id = m.id 
	INNER JOIN ratings r ON dm.movie_id = r.movie_id
	INNER JOIN date_difference  diff ON td.id = diff.id 
GROUP BY td.id
ORDER BY number_of_movies DESC;




