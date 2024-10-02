--1. Count the number of Movies vs TV Shows
Select type,count(type) as ao from netfllix
group by 1;

--2. Find the most common rating for movies and TV shows
select type ,rating from
(
select
	type,
	rating,
	count(*) , 
	rank() over(partition by type order by count(*)desc) as ranking
from  netfllix
group by 1,2
) as t1
where ranking =1


--3. List all movies released in a specific year (e.g., 2020)

select Title ,release_year from	
(
select *
from netfllix where  type = 'Movie'
) as t1
where release_year =2020

--4. Find the top 5 countries with the most content on Netflix

	
select unnest (string_to_array(country, ',')) as new_country , count(show_id) from
	 netfllix group by 1
     order by 2 desc
     limit 5
	



--5. Identify the longest movie

select * from netfllix
where 
	type = 'Movie'
      And 
      duration = (select max(duration) from netfllix)




--6. Find content added in the last 5 years

select *
from netfllix
where To_DATE (date_added,'Month DD,YYYY' )>= current_date - Interval '5 years'



--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select  * from netfllix where director like '%Rajiv Chilaka%'





--8. List all TV shows with more than 5 seasons

select *
	
	from netfllix
where	type = 'TV Show'
	And
 split_part(duration,' ',1)::numeric > 5 



--9. Count the number of content items in each genre

select unnest(string_to_array(listed_in,',')) as genre,
 count(show_id)
	from netfllix
group by 1


--10.Find each year and the average numbers of content release in India on netflix. return top 5 year with highest avg content release!

select  
	extract(year from to_date (date_added,'Month DD,YYYY')) as year,count(*),
	round(count(*)::numeric/(select count (*) from netfllix where country = 'India')::numeric *100 ,2)
	as avg_count_per_year 
from netfllix where country = 'India'
group by 1 



--11. List all movies that are documentaries
 
select * from netfllix
where listed_in Like  '%Documentaries%'



--12. Find all content without a director
select * from netfllix where director is null


--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select * from netfllix where casts ilike '%Salman Khan%' and release_year > Extract(year from current_date) -10
 


--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select unnest(string_to_array(casts,',')) as actors,
	count(*) as total_content
 	from netfllix
	where country ilike '%India%'
    group by actors
	order by total_content desc limit 10

--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many 
--items fall into each category.

with new_table	
as
(	
select * ,
	case when   description ilike '%Kill%' or  description ilike '%violence%' then 'BAD'
	else 'GOOD'
	end catagory
	from netfllix
)
select catagory , count (*) as total_content from new_table group by 1
	
















