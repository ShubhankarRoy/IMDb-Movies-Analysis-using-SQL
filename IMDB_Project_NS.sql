create database imdb_sql_proj_try;
use imdb_sql_proj_try;

Segment 1: Database - Tables, Columns, Relationships
Q.1 -What are the different tables in the database and how are they connected to each other in the database?
The different tables in the database are 'movie','genre', 'ratings', 'role_mapping', 'director_mapping' and 'names'.

The "genre" table has a foreign key "movie_id" that refers to the "id" column in the "movie" table, indicating that a movie can have multiple genres.
The "ratings" table has a foreign key "movie_id" that refers to the "id" column in the "movie" table, indicating that a movie can have ratings associated with it.
The "role_mapping" table has a foreign key "movie_id" that refers to the "id" column in the "movie" table, indicating that a movie can have multiple roles.
The "role_mapping" table also has a foreign key "name_id" that refers to the "id" column in the "names" table, linking the roles to their respective names.
The "director_mapping" table has a foreign key "movie_id" that refers to the "id" column in the "movie" table, indicating that a movie can have multiple directors.
The "director_mapping" table also has a foreign key "name_id" that refers to the "id" column in the "names" table, linking the directors to their respective names.

Q.2-Find the total number of rows in each table of the schema.

select count(*) from genre;
select count(*) from movies;
select count(*) from names;
select count(*) from ratings;
select count(*) from role_mapping;
select count(*) from director_mapping;

#Total_No_of_Rows in each table:-
movies= 7997
genre= 14662
ratings= 7997
names= 25735
role_mapping= 15615
director_mapping= 3867

Q.3-Identify which columns in the movie table have null values.

SET SQL_SAFE_UPDATES = 0;
update movies set id = null where id = '' ;
update movies set title = null where title = '' ;
update movies set year = null where year = '' ;
update movies set duration = null where duration = '' ;
update movies set country = null where country = '' ;
update movies set worlwide_gross_income = null where worlwide_gross_income = '' ;
update movies set languages = null where languages = '' ;
update movies set production_company = null where production_company = '' ;
update genre set movie_id = null where movie_id = '' ;
update genre set genre = null where genre = '' ;
update director_mapping set movie_id = null where movie_id = '' ;
update director_mapping set name_id = null where name_id = '' ;
update role_mapping set movie_id = null where movie_id = '' ;
update role_mapping set name_id = null where name_id = '' ;
update role_mapping set category = null where category = '' ;
update names set id = null where id = '' ;
update names set name = null where name = '' ;
update names set height = null where height = '' ;
update names set date_of_birth = null where date_of_birth = '' ;
update names set known_for_movies = null where known_for_movies = '' ;
update ratings set movie_id = null where movie_id = '' ;
update ratings set avg_rating = null where avg_rating = '' ;
update ratings set total_votes = null where total_votes = '' ;
update ratings set median_rating = null where median_rating = '' ;


select count(*) from movies where id is null;
select count(*) from movies where title is null;
select count(*) from movies where year is null;
select count(*) from movies where date_published is null;
select count(*) from movies where duration is null;
select count(*) from movies where country is null;
select count(*) from movies where worlwide_gross_income is null;
select count(*) from movies where languages is null;
select count(*) from movies where production_company is null;

# worlwide_gross_income, country, languages and production_company has null values in the movies table

Segment 2: Movie Release Trends
Q.4-Determine the total number of movies released each year and analyse the month-wise trend.

select year, count(*) as no_of_movies_released from movies
group by year
order by year desc;

#Total_no_of_movies relased in 2019 = 2001, 2018 = 2944 and 2017 = 3052 repestively

select month(date_published) as month, count(*) as number_of_movies from movies
group by month (date_published)
order by month ;
 
 # Month 3 i.e. March had the highest number of movies published followed by september, january and october. Lowest in December. 

Q.5-Calculate the number of movies produced in the USA or India in the year 2019.

select count(*) from movies
where year =2019 and
(lower(country) like "%usa%" or lower(country) like "%india%");

#Total number of movies produced in the USA or India in the year 2019 = 1059

Segment 3: Production Statistics and Genre Analysis
Q.6-Retrieve the unique list of genres present in the dataset.

select distinct(genre) from genre;

#Genres prsent in the dataset are Thriller,Fantasy,Drama,Comedy,Horror,Romance,Family,Adventure,Sci-Fi,Action,Mystery,Crime and Others

Q.7-Identify the genre with the highest number of movies produced overall.

select genre, count(movie_id) from genre
group by genre
order by count(movie_id) desc
limit 1;

#Highest number of movies produced is with Drama genre, 4285

Q.8-Determine the count of movies that belong to only one genre.

select count(*) from (
select movie_id, count(genre) as no_of_genre from genre
group by movie_id
having no_of_genre = 1) t;

#3289 movies belong to only one genre

Q.9-Calculate the average duration of movies in each genre.

select g.genre, avg(duration) from movies m
right join genre g on g.movie_id = m.id
group by g.genre
order by 2 desc;

Q.10-Find the rank of the 'thriller' genre among all genres in terms of the number of movies produced.

select * from
(select genre, count(movie_id) as no_of_movies,
rank() over (order by count(movie_id) desc) as rnk
from genre
group by genre) t
where genre = 'Thriller';

#The rank of the 'thriller' genre among all genres in terms of the number of movies produced is 3 with total 1484 movies

Segment 4: Ratings Analysis and Crew Members
Q.11-Retrieve the minimum and maximum values in each column of the ratings table (except movie_id).

select min(avg_rating), max(avg_rating), min(total_votes), max(total_votes),
min(median_rating), max(median_rating)
from ratings;

#Min and Max values for avg_rating and median_rating is 1 and 10, for total_votes its 100 and 725138

Q.12-Identify the top 10 movies based on average rating.

select title, avg_rating, row_number() over(order by avg_rating desc) AS rnk from movies m
left join ratings r on r.movie_id = m.id
order by avg_rating desc
limit 10;

#Top 10 movies based on average rating are Love in Kilnerry,Kirket,Gini Helida Kathe,Runam,Fan,Android Kunjappan Version 5.25,Yeh Suhaagraat Impossible,Safe,The Brighton Miracle and Our Little Haven

Q.13-Summarise the ratings table based on movie counts by median ratings.

select median_rating, count(movie_id) as movie_count
from ratings
group by median_rating
order by median_rating;

#Total 2235 movies are with median_rating of 7 which is highest count, after that, 1963 movies with median rating of 6 and 1021 movies with median_rating of 8

Q.14-Identify the production house that has produced the most number of hit movies (average rating > 8).

select * from (
select production_company, count(id) as number_of_movies,
rank () over (order by count(id) desc) as cnt from movies m
join ratings r on m.id = r.movie_id
where avg_rating > 8 and production_company is not null
group by production_company
order by number_of_movies desc) t
where cnt =1;

#Dream Warrior Pictures and National Theatre Live are the production houses that have produced the most number of hit movies (average rating > 8)

Q.15-Determine the number of movies released in each genre during March 2017 in the USA with more than 1,000 votes.

select genre, count(g.movie_id) as No_of_movies
from genre g
inner join movies m on m.id = g.movie_id
inner join ratings r on r.movie_id = g.movie_id
where year = 2017 and
month(date_published) = 3 and
lower(country) like "%usa%" and 
total_votes> 1000
group by genre
order by No_of_movies desc;

#Most number of movies released in during March 2017 in the USA with more than 1,000 votes is with Drama genre (i.e, 24 movies), followed by Comedy-9, Action-8, Thriller-8 and so on..

Q.16-Retrieve movies of each genre starting with the word 'The' and having an average rating > 8.

select g.genre, m.title, r.avg_rating as Average_rating_of_movies
from genre g
inner join movies m on m.id = g.movie_id
inner join ratings r on r.movie_id = g.movie_id
where lower(title) like "the%" and avg_rating > 8.0
order by genre ;

# 7 movies with Drama genre starts with the word 'The' and have average rating> 8
# 3 movies with Crime genre starts with the word 'The' and have average rating> 8
# 1 movie each with Mystery,horror,Thriller,Action and Romance genre starts with the word 'The' and have average rating> 8

Segment 5: Crew Analysis
Q.17-Identify the columns in the names table that have null values.

select count(*) from names where id is null;
select count(*) from names where name is null;
select count(*) from names where height is null;
select count(*) from names where date_of_birth is null;
select count(*) from names where known_for_movies is null;

#height, date_of_birth and known_for_movies have null values in the names table

Q.18-Determine the top three directors in the top three genres with movies having an average rating > 8.

with top_genre as 
(select genre, count(g.movie_id) as total_movies from genre g
inner join ratings r on r.movie_id = g.movie_id
where avg_rating > 8
group by genre
order by total_movies desc limit 3)

select
n.name as top_director_names, count(m.id) as movie_count
from names n
inner join director_mapping dm on dm.name_id = n.id
inner join movies m on m.id = dm.movie_id
inner join genre g on g.movie_id = m.id
inner join ratings r on r.movie_id = m.id 
where avg_rating > 8 and genre in 
(select genre from top_genre)
group by 1
order by movie_count desc
limit 3

#The top three directors in the top three genres are James Mangold, Joe Russo, and Anthony Russo. They have more success rates.

Q.19-Find the top two actors whose movies have a median rating >= 8.

select n.name as actor_name, count(m.id) as movie_count
from names n
inner join role_mapping rm on rm.name_id = n.id
inner join movies m on m.id = rm.movie_id
inner join ratings r on r.movie_id = m.id 
where median_rating >= 8 and lower(category) = 'actor'
group by 1
order by movie_count desc
limit 2;

#Mohanlal and Mamooty are the top actors having median rating >=8

Q.20-Identify the top three production houses based on the number of votes received by their movies.

select production_company,sum(total_votes)as votes from movies m 
join ratings r on m.id=r.movie_id
where production_company is not null
group by production_company 
order by votes desc limit 3;

#Marvel Studios, Twentieth Century Fox, Warner Bros. are the top three production houses based on the number of votes received by their movies

Q.21-Rank actors based on their average ratings in Indian movies released in India.

With actr_avg_rating as
(SELECT
n.name as actor_name,
SUM(r.total_votes) AS total_votes,
COUNT(m.id) as movie_count,
ROUND(
SUM(r.avg_rating*r.total_votes)
/
SUM(r.total_votes)
,2) AS actor_avg_rating
FROM names AS n
INNER JOIN role_mapping AS a ON n.id=a.name_id
INNER JOIN movies AS m ON a.movie_id = m.id
INNER JOIN ratings AS r ON m.id=r.movie_id
WHERE category = 'actor' AND LOWER(country) like '%india%'
GROUP BY actor_name )
select *, rank() over(order by actor_avg_rating desc , total_votes desc) as avg_rank
from actr_avg_rating
where movie_count >= 5
order by actor_avg_rating desc
;

#Vijay Sethupati is the top actor based on his average ratings in Indian movies released in India followed by Fahad Faasil, Yogi Babu, Joju Georgr and Ammy Virk

Q.22-Identify the top five actresses in Hindi movies released in India based on their average ratings

With actr_avg_rating as
(SELECT
n.name as actress_name,
SUM(r.total_votes) AS total_votes,
COUNT(m.id) as movie_count,
ROUND(
SUM(r.avg_rating*r.total_votes)
/
SUM(r.total_votes)
,2) AS actress_avg_rating
FROM names AS n
INNER JOIN role_mapping AS a ON n.id=a.name_id
INNER JOIN movies AS m ON a.movie_id = m.id
INNER JOIN ratings AS r ON m.id=r.movie_id
WHERE category = 'actress' AND LOWER(languages) like '%hindi%'
GROUP BY actress_name )
select *, rank() over(order by actress_avg_rating desc , total_votes desc) as avg_rank
from actr_avg_rating
where movie_count >= 3
limit 5;

# Tapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor and Kriti Kharbanda are the top five actresses in Hindi movies released in India based on their average ratings

Segment 6: Broader Understanding of Data
Q.23-Classify thriller movies based on average ratings into different categories.

select m.title as movie_name,
case
	when avg_rating > 8.0 then "Superhit"
    when avg_rating between 7.0 and 8.0 then "Hit"
    when avg_rating between 5.0 and 7.0 then "One-time watch"
    else "Flop"
End as category from movies m
join genre as g on m.id = g.movie_id
join ratings as r on m.id = r.movie_id
where genre = 'Thriller' and total_votes>25000 ;


[Rating > 8 : Superhit
Rating between 7 and 8 : Hit
Rating between 5 and 7 : One-time watch
Rating < 5 : Flop]
total_votes > 25000;

Q.26-analyse the genre-wise running total and moving average of the average movie duration.

with genre_summary as 
(select genre, avg(duration) as avg_duration
from genre g
left join movies m on g.movie_id = m.id
group by genre)

select genre, avg_duration,
sum(avg_duration) over (order by avg_duration desc) as running_total,
avg(avg_duration) over (order by avg_duration desc) as moving_average
from genre_summary;

Q.27-Identify the five highest-grossing movies of each year that belong to the top three genres.

with top_genre as
(select g.genre, count(m.id) as movie_count
from genre g 
inner join movies m on m.id = g.movie_id
group by genre
order by movie_count desc
limit 3)

select * from 
(select genre, year, m.title as movie_name,
worlwide_gross_income,
rank() over (partition by genre, year order by 
cast(replace(trim(worlwide_gross_income), "$", "") as unsigned)
desc ) as movie_rank
from
movies m inner join genre g on g.movie_id = m.id
where g.genre in (select genre from top_genre)) t
where movie_rank <=5

Q.28-Determine the top two production houses that have produced the highest number of hits among multilingual movies.

select m.production_company,
count(m.id) as movie_count,
rank() over (order by count(m.id) desc) as prod_rnk
from movies m left join ratings r on r.movie_id = m.id
where m.production_company is not null and median_rating > 8
and languages like "%,%"
group by 1
limit 2

#Star Cinema and Ave Fenix Pictures produced the highest number of hits among multilingual movies

Q.29-Identify the top three actresses based on the number of Super Hit movies (average rating > 8) in the drama genre.

With actr_avg_rating as
(SELECT
n.name as actress_name,
SUM(r.total_votes) AS total_votes,
COUNT(m.id) as movie_count,
ROUND(
SUM(r.avg_rating*r.total_votes)
/
SUM(r.total_votes)
,2) AS actress_avg_rating
FROM names AS n
INNER JOIN role_mapping AS a ON n.id=a.name_id
INNER JOIN movies AS m ON a.movie_id = m.id
INNER JOIN ratings AS r ON m.id=r.movie_id
inner join genre g on g.movie_id = m.id
WHERE category = 'actress' AND lower(genre) like "%drama%" and avg_rating > 8
GROUP BY actress_name )

select *, 
row_number() over(order by actress_avg_rating desc, total_votes desc) as actress_rank
from actr_avg_rating
limit 3;

#Sangeetha Bhat, Fatmire Sahiti and Adriana Matoshi are the top three actresses based on the number of Super Hit movies (average rating > 8) in the drama genre.

Q.30-Retrieve details for the top nine directors based on the number of movies, including average inter-movie duration, ratings, and more.

with top_directors as 
( select director_id,director_name
from (select n.id as director_id ,n.name as director_name,
count(m.id)as movie_count,
row_number() over (order by count(m.id)desc ) as director_rank
from names n
inner join director_mapping d on id=d.name_id
inner join movies m on m.id =  d.movie_id
group by 1,2) t
where director_rank <=9),


 movie_summary as 
(select n.id as director_id, n.name as director_name,
m.id as movie_id,
r.avg_rating ,
r.total_votes,
m.duration,
m.date_published,
lead(date_published) over (partition by n.id order by m.date_published) as next_date_published,
datediff(lead(date_published) over (partition by n.id order by m.date_published),
m.date_published) as INTER_MOVIE_DAYS
from  names n
inner join director_mapping d on n.id = d.name_id 
inner join movies m on m.id = d.movie_id 
inner join ratings r on r.movie_id = m.id
where n.id in (select director_id from top_directors) 
)


select 
director_id , 
director_name ,
count(distinct movie_id) as number_of_movies,
avg(inter_movie_days) as avg_inter_movie_days,
round(sum(avg_rating*total_votes)/sum(total_votes),2)
AS directors_avg_rating,
sum(total_votes) as total_votes,
max(avg_rating) as max_rating,
sum(duration)as total_movie_duration from
movie_summary
group by 1,2 
order by number_of_movies desc,
directors_avg_rating desc ;

#A.L. Vijay,Andrew Jones,Steven Soderbergh,Sam Liu,Sion Sono,Jesse V. Johnson,Justin Price,Chris Stokes and Özgür Bakar are the top nine directors based on the number of movies, including average inter-movie duration, ratings, and more

Segment 7: Recommendations
Q.31-Based on the analysis, provide recommendations for the types of content Bolly movies should focus on producing.

#Based on the analysis of the database, here are some recommendations for the types of content that Bolly movies should focus on producing:

i) Bolly movies should focus on producing high-quality Drama movies as drama genre has the highest number of movies produced overall and also has the highest number of hits.
ii) Multilingual movies have the potential to become hits, so its important to focus on producing multilingual films
iii) Directors like A.L. Vijay, Andrew Jones, Steven Soderbergh, Sam Liu, Sion Sono, Jesse V. Johnson, Justin Price, Chris Stokes, and Özgür Bakar have a proven track record in terms of movie count and average ratings. Collaborating with such experienced directors can lead to more successful projects. 
iv) Collaborating with actors like Mohanlal, Mamooty, Vijay Sethupati, and actress like Tapsee Pannu, Kriti Sanon, and others who have received high ratings for their performances can elevate the quality of movies and attract more viewers.
v) Consider releasing movies in months like March, September, January, and October, which have historically shown higher movie releases
vi) Focusing or investing in top production houses like Marvel studios, Twentiath Century Fox etc and learning their strategies will help bolly movies to create impactful movies
vii) Bolly movies can focus on thriller genres also as it tends to have consistent ratings, which means audience appreciates thriller genre movies.
viii) Bolly movies should actively promote movies that have received high avg_ratings and positive reviews
ix) Its also important to diversify genres to cater to different audience preferences
x) Listening and understanding audience feedbacks and preferences to tailor content accordingly is a very important aspect too.