## Quiz Day2

# world 데이터베이스 문제
use world;
# Quiz 1
# 국가 코드별 도시의 갯수를 출력하세요. (상위 5개를 출력)
select countrycode, count(countrycode) as count
from city
group by countrycode
order by count desc
limit 5;

# Quiz 2
# 대륙별 몇개의 국가가 있는지 대륙별 국가의 갯수로 내림차순하여 출력하세요.
select continent, count(continent) as count
from country
group by continent
order by count desc;

# Quiz 3
# 대륙별 인구가 1000만명 이상인 국가의 수와 GNP의 평균을 소수 둘째 자리에서 반올 림하여 첫째자리까지 출력하세요.
select continent, count(continent) as count, round(avg(gnp), 1) as avg_gnp
from country
where population >= 1000*10000
group by continent
order by avg_gnp desc;

# Quiz 4
# city 테이블에서 국가코드(CountryCode) 별로 총인구가 몇명인지 조회하고 총인구 순으로 내림차순하세요.
# (총인구가 5천만 이상인 도시만 출력)
select countrycode, sum(population) as population
from city
group by countrycode
having population >= 5000*10000
order by population desc;

# Quiz 5 # count (*)
# countrylanguage 테이블에서 언어별 사용하는 국가수를 조회하고 많이 사용하는 언 어를 6위에서 10위까지 조회하세요.
select language, count(*) as count
from countrylanguage
group by language
order by count desc
limit 5,5;

# Quiz 6 # count (*)
# countrylanguage 테이블에서 언어별 20개 국가 이상에서 사용되는 언어를 조회하고 언어별 사용되는 국가수에 따라 내림차순하세요.
select language, count(*) as count
from countrylanguage
group by language
having count >= 20
order by count desc;

# Quiz 7
# country 테이블에서 대륙별 전체 표면적크기를 구하고 표면적 크기 순으로 내림차순하세요.
select continent, round(sum(surfacearea), 0) as surfacearea
from country
group by continent
order by surfacearea desc;

# Quiz 8 # distinct를 해주어야한다. = 언어의 개수이기때문에 국가는 중복이 안되어도 언어가 중복될 수 있기때문
# World 데이터 베이스의 countrylanguage에서 언어의 사용 비율이 90%대(90 ~ 99.9)의 사용율을 갖는 언어의 갯수를 출력하세요.
select count(distinct language)
from countrylanguage
where percentage between 90 and 99.9;

select count(distinct(language)) as count_90
from countrylanguage
where truncate(percentage*0.1, 0)*10 = 90;

# Quiz 9 (case 사용해보자)
# 1800년대에 독립한 국가의 수와 1900년대에 독립한 국가의수를 출력하세요.
# group by를 컬럼별로 묶어낼 수 있다. # not 컬럼 is null
select count(indepyear),
	   case
		when indepyear between 1900 and 1999 then 1900
	    when indepyear between 1800 and 1899 then 1800
	   end as indepyear_ages
from country
group by indepyear_ages
having not indepyear_ages is null ;

select 1900 as indepyear_ages, count(code) as count
from country
where indepyear between 1900 and 1999
union
select 1800 as indepyear_ages, count(code) as count
from country
where indepyear between 1800 and 1899;


# sakila 데이터베이스 문제
use sakila;
# Quiz 10
# sakila의 payment 테이블에서 월별 총 수입을 출력하세요.
select date_format(payment_date, '%Y-%m') as monthly
		, sum(amount) amount
from payment
group by monthly;

# Quiz 11 (쿼리 조회를 두번 실행해서 해보자)
# actor 테이블에서 가장 많이 사용된 first_name을 아래와 같이 출력하세요.
# 가장 많이 사용된 first_name의 횟수를 먼저 구하고, 횟수를 Query에 넣어서 결과를 출력하세요.
select first_name, count(*) as count
from actor
group by first_name
order by count desc
limit 1;
select first_name
from actor
group by first_name
having count(*) = 4;

select first_name
from actor
group by first_name
having count(*) = (
		select count(*) as count
		from actor
        group by first_name
        order by count desc
        limit 1
        );

# Quiz 12
# film_list 뷰에서 카테고리별 가장 많은 매출을 올린 카테고리 3개를 매출순으로 정렬 하여 아래와 같이 출력하세요.
select category, sum(price) as sales
from film_list
group by category
order by sales desc
limit 3;
