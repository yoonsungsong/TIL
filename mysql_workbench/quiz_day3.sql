## Quiz Day3

# world 데이터베이스 문제
use world;
# Quiz 1
# 멕시코(Mexico)보다 인구가 많은 나라이름과 인구수를 조회하시고 인구수 순으로 내림차순하세요.
select name, population
from country
where population > (select population
					 from country
					 where name = 'Mexico')
order by population desc;

# Quiz 2
# 국가별 몇개의 도시가 있는지 조회하고 도시수 순으로 10위까지 내림차순하세요.
select country.name, count(city.name) as count
from city
join country
on city.countrycode = country.code
group by country.name
order by count desc
limit 10;

# Quiz 3 (서브쿼리로 언어별 사용인구 출력 후 그룹바이)
# 언어별 사용인구를 출력하고 언어 사용인구 순으로 10위까지 내림차순하세요.
select cl.language, round(sum(c.population * cl.percentage/100)) as count
from countrylanguage as cl
join country as c
on cl.countrycode = c.code
group by cl.language
order by count desc
limit 10;

select sub.language, sum(sub.count) as count
from(
	select cl.language, round(c.population * cl.percentage/100) as count
	from country as c
	join countrylanguage as cl
	on c.code = cl.countrycode
    ) as sub
group by sub.language
order by count desc
limit 10;

# Quiz 4 (필터링 후 JOIN사용, JOIN후 필터링)
# 나라 전체 인구의 10%이상인 도시에서 도시인구가 500만이 넘는 도시를 아래와 같이 조회 하세요.
select city.name, city.countrycode, country.name,
	   round((city.population / country.population * 100), 2) as percentage
from (select * from city where population >= 500*10000) as city
join country
on country.code = city.countrycode
having percentage >= 10
order by percentage desc;

# from 안에 두개의 테이블을 같이 놓고, where절에 키 조건을 넣으면 join된다.
select city.name, city.countrycode, country.name, city.population, country.population,
	   round(city.population / country.population * 100, 2) as rate
from (select * from city where population >= 5000000) as city, country
where city.countrycode = country.code
having rate >= 10 order by rate desc;

# Quiz 5
# 면적이 10000km^2 이상인 국가의 인구밀도(1km^2 당 인구수)를 구하고
# 인구밀도(density)가 200이상인 국가들의 사용하고 있는 언어가 2가지인 나라를 조회 하세요.
select distinct c.name
	   , round(c.population / c.surfacearea) as density
	   , count(cl.language) as language_count
	   , group_concat(cl.language) as language_list
from country as c
join countrylanguage as cl
on c.code = cl.countrycode
where c.surfacearea >= 10000
group by cl.countrycode
having language_count = 2
and density >= 200;

# 서브쿼리 사용 (where = 원래 컬럼에 적용, having = 변형된 컬럼에 적용)
# max든 min이든 상관없음, 하나만 추출하는 컨셉
select sub.name, max(sub.density), count(cl.language) as language_count,
	   group_concat(cl.language) as language_list
from (
	select code, name, round(population / surfacearea) as density
	from country
	where surfacearea >= 10000
	having density >= 200
	) as sub
join countrylanguage as cl
on sub.code = cl.countrycode
group by sub.name
having language_count = 2
order by language_count desc;


# Quiz 6
# 사용하는 언어가 3가지 이하인 국가중 도시인구가 300만 이상인 도시를 아래와 같이 조회하세요.
# view만들기

create view cl as
	select ct.countrycode, ct.name, ct.population, cl.language_count, cl.languages
	from (
		select countrycode, count(language) as language_count, group_concat(language) as languages
		from countrylanguage
		group by countrycode
		having language_count <= 3
		) as cl
	join (
		select *
		from city
		where population >= 300*10000
		) as ct
	on cl.countrycode = ct.countrycode;

select city.countrycode, city.name as city_name, city.population, 
	   country.name, city.language_count, city.languages
from cl as city
join country
on country.code = city.countrycode
order by population desc;

# Quiz 7 (0,1방식으로 논리 서브쿼리 생성)
# 한국와 미국의 인구와 GNP를 세로로 아래와 같이 나타내세요. (쿼리문에 국가 코드명을 문자열로 사용 해도 됩니다.)
# flag사용법 : 1에 해당되는 (논리) 값들만 추출된다.*****
select "population" as "category", sum(ct.KOR) as KOR, sum(ct.USA) as USA
from (
	select if(code="KOR", population, 0) as KOR,
		   if(code="USA", population, 0) as USA,
		   1 as flag
		   from country
	 ) as ct
group by flag
union
select "gnp" as "category", sum(ct.KOR) as KOR, sum(ct.USA) as USA
from (
	select if(code="KOR", gnp, 0) as KOR,
		   if(code="USA", gnp, 0) as USA,
           1 as flag
	from country
) as ct
group by flag;



# world 데이터베이스 문제
use sakila;
# Quiz 8
# sakila 데이터 베이스의 payment 테이블에서 수입(amount)의 총합을 아래와 같이 출력하세요.
select date_format(payment_date, '%Y-%m') as monthly, sum(amount) as amount
from payment
group by monthly;

# 임시테이블 생성하는 방법을 잘 익혀두자. 값을 만드는 서브쿼리를 만들고 tmp컬럼을 추가해 밖에서 group by한다.*****
select sum(sub.date1) as "2005-05",
	   sum(sub.date2) as "2005-06",
       sum(sub.date3) as "2005-07",
       sum(sub.date4) as "2005-08",
       sum(sub.date5) as "2006-02"
from (
select
	sum(if(date_format(payment_date, '%Y-%m')="2005-05", amount, 0)) as date1,
    sum(if(date_format(payment_date, '%Y-%m')="2005-06", amount, 0)) as date2,
    sum(if(date_format(payment_date, '%Y-%m')="2005-07", amount, 0)) as date3,
    sum(if(date_format(payment_date, '%Y-%m')="2005-08", amount, 0)) as date4,
    sum(if(date_format(payment_date, '%Y-%m')="2006-02", amount, 0)) as date5,
    "tmp"
from payment
group by date_format(payment_date, "%Y-%m")
) as sub
group by tmp;


# Quiz 9
# 위의 결과에서 payment 테이블에서 월별 렌트 횟수 데이터를 추가하여 아래와 같이 출력하세요.
select date_format(payment_date, '%Y-%m') as monthly, sum(amount) as amount, count(rental_id) as rent
from payment
group by monthly;


select "amount" as "category",
	   sum(sub1.date1) as "2005-05",
	   sum(sub1.date2) as "2005-06",
       sum(sub1.date3) as "2005-07",
       sum(sub1.date4) as "2005-08",
       sum(sub1.date5) as "2006-02"
from (
	select
		sum(if(date_format(payment_date, '%Y-%m')="2005-05", amount, 0)) as date1,
		sum(if(date_format(payment_date, '%Y-%m')="2005-06", amount, 0)) as date2,
		sum(if(date_format(payment_date, '%Y-%m')="2005-07", amount, 0)) as date3,
		sum(if(date_format(payment_date, '%Y-%m')="2005-08", amount, 0)) as date4,
		sum(if(date_format(payment_date, '%Y-%m')="2006-02", amount, 0)) as date5,
		"tmp"
	from payment
	group by date_format(payment_date, "%Y-%m")
) as sub1
group by tmp
union
select "rent" as "category",
       sum(sub2.date1) as "2005-05",
	   sum(sub2.date2) as "2005-06",
       sum(sub2.date3) as "2005-07",
       sum(sub2.date4) as "2005-08",
       sum(sub2.date5) as "2006-02"
from (
select
	sum(if(date_format(payment_date, '%Y-%m')="2005-05", 1, 0)) as date1,
    sum(if(date_format(payment_date, '%Y-%m')="2005-06", 1, 0)) as date2,
    sum(if(date_format(payment_date, '%Y-%m')="2005-07", 1, 0)) as date3,
    sum(if(date_format(payment_date, '%Y-%m')="2005-08", 1, 0)) as date4,
    sum(if(date_format(payment_date, '%Y-%m')="2006-02", 1, 0)) as date5,
    "tmp"
from payment
group by date_format(payment_date, "%Y-%m")
) as sub2
group by tmp;
