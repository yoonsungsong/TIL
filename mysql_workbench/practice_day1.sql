use world; -- 이 데이터 베이스 선택 - bold체로 바뀜
select database();

# CRUD : create, read, update, delete

# SELECT FROM (read)
select code, name, population
from country;

# WHERE : 산술, 비교, 논리
select code, name, population
from country
where population >= 8000 * 10000;

desc country; -- description

select code, name, population, continent
from country;

# 인구수가 8천만 이상인 국가 중에서 아시아 대륙이 아닌 국가들만 출력하세요.
select code, name, population, continent
from country
where (population >= 8000*10000) and (continent != "Asia");

# LifeExpectancy : 기대수명
# 기대수명이 75세 이상인 국가 중에서 아시아에 있는 국가를 출력하세요.
select code, name, population, surfacearea, continent, LifeExpectancy
from country
where (LifeExpectancy >= 80) and (continent = "Asia");

# 이 국가들의 인구밀도를 출력하세요.
select code, name, population, surfacearea, population / surfacearea as population_per_surface
		, continent, LifeExpectancy
from country
where (LifeExpectancy >= 80) and (continent = "Asia");








