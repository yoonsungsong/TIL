## Quiz Day1

# world 데이터베이스 문제
use world;
# Quiz 1
# 한국 ( 국가코드 : KOR ) 도시중 인구가 100만이 넘는 도시를 조회하여 인구수 순으로 내림차순으로 출력하세요.
select name, population
from city
where countrycode = 'KOR'
and population >= 100*10000
order by population desc;

# Quiz 2
# 도시 인구가 800만 ~ 1000만 사이인 도시의 데이터를 국가코드 순으로 오름차순으로 출력하세요.
select countrycode, name, population
from city
where population between 800*10000 and 1000*10000
order by countrycode;

# Quiz 3
# 1940 ~ 1950년도 사이에 독립한 국가들중 GNP가 10만이 넘는 국가를 GNP의 내림차순으로 출력하세요.
select code, name, continent, gnp
from country
where (indepyear between 1940 and 1950)
and (gnp >= 10*10000)
order by gnp desc;

# Quiz 4
# 스페인어(Spanish), 영어(English), 한국어(Korean) 중에 95% 이상 사용하는 국가코드, 언어, 비율을 출력하세요.
select countrycode, language, percentage
from countrylanguage
where (language in ('Spanish', 'English', 'Korean'))
and (percentage >= 95)
order by percentage desc;

# Quiz 5
# 국가 코드가 "K"로 시작하는 국가 중에 기대수명(lifeexpectancy)이 70세 이상인 국가를 기대수명의 내림차순 순으로 출력하세요.
select code, name, continent, lifeexpectancy
from country
where code like "K%"
and lifeexpectancy >= 70
order by lifeexpectancy desc;


# sakila 데이터베이스 문제
use sakila;
# Quiz 6
# film_text 테이블에서 title이 ICE가 들어가고 description에 Drama가 들어간 데이터를 출력하세요.
select film_id, title, description
from film_text
where title like "%ICE%"
and description like "%Drama%";

# Quiz 7
# actor 테이블에서 이름(first_name)의 가장 앞글자가 "A", 성(last_name)의 가장 마지막 글자가
# "N"으로 끝나는 배우의 데이터를 출력하세요.
select actor_id, first_name, last_name
from actor
where first_name like "A%"
and last_name like "%N";

# Quiz 8
# film 테이블에서 rating이 "R" 등급인 film 데이터를 상영시간(length)이 가장 긴 상위 10개의 film을
# 상영시간의 내림차순순으로 출력하세요.
select film_id, title, description, rental_duration, rental_rate, length, rating
from film
where rating = "R"
order by length desc
limit 10;

# Quiz 9
# 상영시간(length)이 60분 ~ 120분인 필름 데이터에서 영화설명(description)에 robot 들어있는 영화를
# 상영시간(length)이 짧은순으로 오름차순하여 정렬하고, 11위에서 13 위까지의 영화를 출력하세요.
select film_id, title, description, length
from film
where (length between 60 and 120)
and (description like "%robot%")
order by length
limit 10,3;

# Quiz 10 -> like와 in의 차이
# film_list view에서 카테고리(category)가 sci-fi, anmation, drama가 아니고 배우(actors)가
# "ed chase", "kevin bloom" 이 포함된 영화리스트에서 상영시간이 긴 순서대로 5개의 영화 리스트를 출력하세요.
select title, description, category, length, actors
from film_list
where category not in ("sci-fi", "animation", "drama")
and (actors like "%ed chase%" or actors like "%kevin bloom%")
order by length desc
limit 5;

