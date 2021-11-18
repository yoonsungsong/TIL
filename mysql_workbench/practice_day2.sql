use world;

# CRUD : READ
## SELECT FROM WHERE
# 인구가 7000만 ~ 1억인 국가를 출력 : code, name, population
select code, name, population
from country
where (population >= 7000*10000) and (population <= 10000*10000);

## BETWEEN
select code, name, population
from country
where population between 7000*10000 and 10000*10000;

# 인구수가 5천만 이상인 아시아와 아프리카대륙의 데이터를 출력
# code, name, population, continent
select code, name, population, continent
from country
where (population >= 5000*10000)
	and (continent = 'Asia' or continent = 'Africa');
    
## IN, NOT IN
select code, name, population, continent
from country
where (population >= 5000*10000)
	and (continent not in ('Asia', 'Africa'));

## LIKE : 특정 문자열 포함
# govermentform : Republic을 포함하는 데이터 출력
select code, name, governmentform
from country
where governmentform like '%Republic%';

select code, name
from country
where code like 'K%';

## ORDER BY : 정렬 (ASC(생략가능), DESC)
# 국가의 인구수가 8천만 이상인 국가들을 출력하고, 인구수 순으로 내림차순 정렬
select code, name, population
from country
where population >= 8000*10000
order by population desc;

select countrycode, name, population
from city
order by countrycode desc, population asc;

## LIMIT : 조회되는 데이터의 수를 제한
# 인구가 많은 상위 5개 국가의 데이터를 출력
# 인구수 순으로 내림차순정렬 -> 상위 5개 데이터만 출력
select code, name, population
from country
order by population desc
limit 5;

# 인구수 5위 ~ 7위까지 출력
# limit 4(skip), 3(limit)
select code, name, population
from country
order by population desc
limit 4, 3;

## DISTINCT : 중복데이터 제거
# city 테이블
# 도시의 인구수가 100만 ~ 200만 사이의 도시 > 국가의 국가 코드 출력
select distinct countrycode
from city
where population between 100*10000 and 200*10000;

# 법(문법), 도덕(컨벤션) : PEP8, PEP20
# c, java, python
# c : a = 1
# python : number = 1, 가독성 좋게 작성

# 데이터타입
create database test;
use test;
create table number1(
	data tinyint
);
show tables;
desc number1;
select * from number1;
insert into number1 value (-125); # tinyint는 기본적으로 signed 데이터 생성
insert into number1 value (128);
insert into number1 value (127);

create table number2(
	data tinyint unsigned
);
show tables;
desc number2;
select * from number2;
insert into number2 value (128);

SELECT * FROM world.country;

## DDL : create, alter, drop (생성, 수정, 삭제)
# create database <name>, create table <name>
use test;

## DDL : CREATE
# user1 테이블 생성
create table user1(
	user_id int,
    name varchar(20),
    email varchar(30),
    age int,
    rdate date
);
desc user1;
# 제약조건을 추가한 user2테이블 생성 
create table user2(
	user_id int primary key auto_increment, # 하나만 들어감, 자동으로 1씩 추가 
    name varchar(20) not null, # 비어있는 데이터 추가불가
    email varchar(30) not null unique, # 유니크한 값이 들어감
    age int default 30, # 디폴트값 설정
    rdate timestamp # 디폴트는 현재시간으로 자동설정됨
);
desc user2;

## DDL : ALTER
show variables like "character_set_database";
alter database test character set = utf8; # character set을 utf8로 설정함 (인코딩)

# add column
desc user2; # 원래는 tmp 컬럼 없었음
alter table user2 add tmp text not null;

# modify column
alter table user2 modify column tmp int;
desc user2;

# drop column
alter table user2 drop tmp;
desc user2;

## DDL : DROP (데이터 베이스, 테이블 삭제)
create database tmp;
show databases;
drop database tmp;

use test;
show tables;
drop table number1;
drop table number2;
show tables;

# DML : CRUD : create
desc user1;
insert into user1(user_id, name, email, age, rdate)
value (1, "peter", "peter@daum.net", 27, "2020-01-13"); # not null 제약조건 있을시 공백은 에러발생
select * from user1;

insert into user1(user_id, name, email, age, rdate)
values (2, "po", "po@daum.net", 37, "2020-02-13")
, (3, "andy", "andy@naver.com", 42, "2020-03-13")
, (4, "poi", "poi@daum.net", 27, "2020-07-13")
, (7, "jin", "jin@gmail.com", 32, "2019-05-13");
select * from user1;

use test;
desc user2;
insert into user2(name, email, age)
values ("peter", "peter@naver.com", 35)
, ("andy", "andy@gmail.com", 26)
, ("jhon", "jhon@daum.net", 29);
select * from user2; # user_id 자동으로 1씩 증가함, rdate는 현재시간으로 들어감

insert into user2(name, email)
values ("lone", "lone@naver.com"); # age디폴트값 30들어감
select * from user2;

insert into user2(name, email)
values ("lone2", "lone@naver.com"); # 이미 있는 값이 존재해서 에러 발생 (unique)

insert into user2(email)
values ("lone2@naver.com"); # name이 꼭 들어가야해서 에러발생

use world;
select countrycode, name, population
from city
where population >= 800*10000;

create table city_800(
	countrycode char(3),
    name varchar(50),
    population int
);
desc city_800;
# select구문에서 작성한 내용을 새로생성한 city_800테이블로 저장하기 = 자주 사용하는 기능은 아님
insert into city_800
select countrycode, name, population
from city
where population >= 800*10000;

select * from city_800;

# CRUD : update
use test;
select * from user2;
## CRUD : UPDATE
# 무조건 where절이 있어야한다. 안그럼 전부 다 바뀜
# limit을 입력해줘야 큰 실수를 막을 수 있음.
update user2
set name='jin', age=40
where name='lone' # 조건에 해당되는 로우의 내용을 변경
limit 5; # 이 안전장치를 입력해줘야 워크벤치에서 실행이된다. (이게 없어도 터미널mysql에서는 실행가능)
select * from user2;
# 만약에 쿼리를 잘못 동작시켰을 경우, 아래 코드를 실행시켜 중단을 시켜줘야한다.
show processlist; # 쿼리의 처리실행상태를 볼 수 있음.
kill 43; # 43번에 해당되는 쿼리가 중단됨.

## CRUD : DELETE
# where절과 함꼐 쓴다
select * from user2;
delete from user2
where age < 37
limit 2; # 37세 이하 2명을 삭제시켜줌

-- drop table user2 = 스키마까지 모두 삭제됨
# 테이블 초기화
truncate user2; # 스키마는 남기고 데이터만 사라짐
select * from user2;

# DML : CRUD
# create : insert into
# read : select from
# update : update set
# delete : delete from

# DDL : create, alter, drop

## 외래키 : Foreign Key
# 데이터의 무결성을 지켜주는 기능
# unique, primary key 제약조건이 있어야 설정이 가능

use test;
create table user(
	uid int primary key auto_increment, # 주요키 설정
    name varchar(20),
    addr varchar(20)
);
create table money(
	mid int primary key auto_increment,
    income int,
    uid int # 외래키 설정X
);
insert into user(name, addr)
values ("andy", "seoul"), ("jin", "pusan"), ("peter", "incheon");

insert into money(income, uid)
values (100, 1), (200, 4); # 외래키설정이 없어서 그대로 생성가능
select * from money;

drop table money;
create table money(
	mid int primary key auto_increment,
    income int,
    uid int,
    foreign key (uid) references user(uid) # 외래키 설정
);
desc money;
insert into money(income, uid)
values (100, 1), (200, 4); # 외래키 설정조건 때문에 들어가지 않음
select * from money;

insert into money(income, uid)
values (100, 1), (200, 3); # 외래키 조건을 만족하기 때문에 값이 들어감
select * from money;

# 만약 참조된 키가 사라진다면? = 무결성이 다시 깨짐
update user
set uid=4
where uid=3; # 오류 발생, 외래키 재약조건으로 인해 바뀌지가 않음

update user
set uid=4
where uid=2; # 2는 현재 참조된 곳이 없기 때문에 가

drop table user;

# on update, on delete 설정
# cascade : 참조되는(user) 데이터를 삭제, 수정하면 참조하는(money) 데이터도 삭제, 수정
# set null : 참조하는 데이터를 null로 변경
# no action  : 참조하는 데이터가 변경되지 않음 (무결성이 깨져버림), 실제 사용 X
# set default : 참조하는 데이터가 디폴트값으로 변경
# restrict : 수정이나 삭제 불가 : 에러 발생시킴 (디폴트)
alter table money add constraint fk_user
foreign key(uid) references user(uid); # 기존에서 외래키만 지정가능 (무결성이 지켜져있는 상태에서)

# cascade on delete set null
drop table money;
create table money(
	mid int primary key auto_increment,
    income int,
    uid int,
    foreign key (uid) references user(uid)
    on update cascade on delete set null # user id업데이트 시 money것도 업데이트, 삭제되면 null로 변경
);
insert into money(income, uid)
values (100, 1), (200, 3);
select * from user;
select * from money;

# uid 3을 5로 바꾸기
update user
set uid = 5
where uid = 3;
select * from money; # user를 따라 3이 5로 바뀜

# uid 5 삭제하기
delete from user
where uid=5
limit 1;
select * from money; # 변경된 user에 의해 null로 변경

### functions : 올림, 반올림, 버림
## ceil(), round(), truncate()
select ceil(12.345); # 자리수 설정 안됨
select round(12.345, 2); # 자리수 설정 됨
select truncate(12.345, 2); # 자리수 설정 해야함

use world;
select code, name, population, surfacearea
		, round(population / surfacearea, 1) as pps
from country;

## DATE FORMAT
## sakila 데이터베이스 (mysql 공식페이지 샘플데이터)
# sakila-schema, sakila-data sql파일 실행하여 sakila 파일을 업로드한다
use sakila;
select amount, payment_date
		, date_format(payment_date, "%Y-%m") as monthly
from payment;
# 월별 총매출 구할때 데이터 포맷을 사용한다.
select sum(amount), date_format(payment_date, "%Y-%m") as monthly
from payment
group by monthly;

## concat
use world;
select code, name, concat(name, "(", code, ")") as fullname, population
from country
where population >= 10000*10000;

## count
select count(code)
from country;

# function : if, case when then
# if(조건, true, false)
# 국가인구가 1억이 넘으면 "big", 아니면 "small"을 출력
select code, name, population
		, if(population > 10000*10000, "big", "small") as scale
from country;

# 국가인구가 1억이 넘으면 "big", 5천만이 넘으면 "medium", 아니면 "small"을 출력
select code, name, population
	, case
		when population >= 10000*10000 then "big"
        when population >= 5000*10000 then "medium"
        else "small"
	end as scale
from country;

## GROUP BY
# 특정 컬럼을 기준으로 중복되는 데이터를 결합 > 다른 컬럼은 결합함수로 데이터를 결합
# 특정 컬럼, 결합 함수
# 결합함수 : count, max, min, average, sum ...
use world;
# 국가별 도시의 갯수를 출력하세요. (먼저 출력 후에 어떻게할지 본다)
select countrycode, count(countrycode) as city_count
from city
group by countrycode
order by city_count desc
limit 5;

# country 테이블 : 대륙별 총 gnp, 총 인구수를 출력
select continent, sum(gnp) as total_gnp, sum(population) as total_ppl
		, sum(gnp) / sum(population) as gdp # 1인당 총 생산
from country
group by continent
order by gdp desc;

# having = group by에 조건을 넣고 싶을때
# 5억 이상의 인구가 있는 대륙을 출력
select continent, sum(population) as total_ppl
from country
group by continent
having total_ppl >= 5*10000*10000;


## JOIN
use bda;

drop table user;
create table user(
	uid int primary key,
    name varchar(20)
);

drop table addr;
create table addr(
	aid int primary key,
    addr_name varchar(20),
    uid int
);

insert into user(uid, name)
values (1, "jin"), (2, "po"), (3, "alice");
select * from user;

insert into addr(aid, addr_name, uid)
values (1, "seoul", 1), (2, "pusan", 2), (3, "daegu", 4), (4, "pusan", 5);
select * from addr;

## inner join
select user.uid, user.name, addr.addr_name
from user
join addr # inner는 생략가능
on user.uid = addr.uid; # where나 on을 사용, 둘 중 하나 가능

#inner join에 한해서 join없이 from에 두 테이블을 나란히 적어도 된다.
select user.uid, user.name, addr.addr_name
from user, addr
where user.uid = addr.uid;

## left join - 먼저 사용된 테이블을 기준으로 left join
select user.uid, user.name, addr.addr_name
from user
left join addr
on user.uid = addr.uid;

## right join - 먼저 사용된 테이블을 기준으로 right join
select addr.uid, user.name, addr.addr_name # addr의 uid를 기준으로 right이기 때문에 addr.uid사용
from user
right join addr
on user.uid = addr.uid;

# world 데이터베이스
# 도시인구가 900만 이상인 도시의 국가코드, 국가이름, 국가인구수, 도시이름, 도시인구수 출력
# 추가문제 : 해당 도시의 국가 총인구에 대한 도시인구 비율 출력
use world;

select country.code, country.name as country_name, country.population as country_population
		, city.name as city_name, city.population as city_population
		, (city.population / country.population *100) as rate
from country
join city
on country.code = city.countrycode
having city.population >= 900*10000
order by city.population desc;

# table alias
select c1.code, c1.name as country_name, c1.population as country_population
		, c2.name as city_name, c2.population as city_population
		, (c2.population / c1.population *100) as rate
from country as c1
join city as c2
on c1.code = c2.countrycode
having c2.population >= 900*10000
order by c2.population desc;

## UNION : 세로 방향으로 데이터를 결합하고 중복데이터 제거
use bda;

select name
from user
union
select addr_name
from addr;
# union all은 중복데이터 제거하지 않음
select name
from user
union all
select addr_name
from addr;

# union을 이용해서 outer join을 할 수 있습니다.
select user.uid, user.name, addr.addr_name
from user
left join addr
on user.uid = addr.uid
union
select addr.uid, user.name, addr.addr_name
from user
right join addr
on user.uid = addr.uid;

