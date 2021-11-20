## Sub Query : 쿼리 안에 쿼리
# select
use world;
# 전체 나라수, 전체 도시수, 전체 언어수를 출력(가로방향)
select (select count(code) from country) as total_country,
	   (select count(countrycode) from city) as total_city,
	   (select count(distinct(language)) from countrylanguage) as total_language
from dual; # from절에 쓸게 없을때 dual을 사용함.

# from
# 인구수가 900만 이상인 도시의 국가코드, 국가이름, 도시이름, 도시인구수를 출력
# city-contry join (240*4000 테이블), city.population >= 900*10000
select country.code, country.name, city.name, city.population
from city
join country
on city.countrycode = country.code
having city.population >= 900*10000;
# 위 커리와 실행결과가 똑같다. 데이터가 많을 경우 가져오는 속도가 매우 빨라진다.
# city.population >= 900*10000 (6 테이블), city-country join (240*6 테이블)
select country.code, country.name, city.name, city.population
from ( select countrycode, name, population
	   from city
       where population >= 900*10000 ) as city
join country
on city.countrycode = country.code;

# where
# 900만 이상 인구의 도시 국가코드, 국가이름, 대통령이름을 출력
select code, name, headofstate
from country
where code in ( select countrycode
			    from city
                where population >= 900*10000 );
# code in : 안에 포함되는 경우를 데려오는 조건

## VIEW
# 실제 데이터를 갖지 않고, 쿼리를 줄여주는 용도로 사용 됩니다.
# 데이터 수정이나 인덱스 설정이 불가
# 가상의 테이블이기 때문에 테이블처럼 사용할 수 있다.
select country.code, country.name, city.name, city.population
from ( select countrycode, name, population
	   from city
       where population >= 900*10000 ) as city
join country
on city.countrycode = country.code;
# city_900라는 뷰 생성
create view city_900 as
select countrycode, name, population
from city
where population >= 900*10000;
# 뷰를 이용
select country.code, country.name, city2.name, city2.population
from city_900 as city2
join country
on city2.countrycode = country.code;

## INDEX
# B-Tree 알고리즘
# 장점 : 데이터를 빠르게 검색
# 단점 : 많이 사용하면 수정과 추가, 삭제가 느려집니다.
#       저장공간을 10% 정도 더 차지
# 서비스에서 where에 많이 사용되는 컬럼을 인덱스로 설정 (ex. 날짜데이터)

# cli환경에서 employee데이터베이스를 서버를 통해 전송함
use employee;
select count(*) from salaries;
# 인덱스 확인
show index from salaries;
# 인덱스의 종류 :
# 클러스터형 인덱스 : 정렬용도, 검색 속도 향상에 큰 도움이 되지 않는다. cardinality 매우큼
# 보조(세컨더리) 인덱스 : 일부 데이터만 추출해서 만듦, 검색 속도 향상에 도움된다.

# 770ms (시퀄프로에서 측정된 값 - 정확)
select * from salaries where to_date < "1986-01-01";
# 인덱스 생성은 시간이 좀 걸림
create index tdate on salaries (to_date);
show index from salaries;
# 41ms (인덱스 추가했더니 속도가 향상됨)
select * from salaries where to_date < "1986-01-01";
# 인덱스 삭제
drop index tdate on salaries;
show index from salaries;
# 다시 삭제했더니 느려짐 = 인덱스의 효과가 확실히 있다.
select * from salaries where to_date < "1986-01-01";

# 실행계획 : explain 명령어를 통해 어떻게 검색하는지 볼 수 있다.
# type = all : full search 진행, possible_keys : 키값 사용여부
# rows : 검색하려는 대상의 수, filtered : 몇프로 검색되는지(예상치), where절 사용
explain select * from salaries where to_date < "1986-01-01";
create index tdate on salaries (to_date);
# possible_keys = tdate를 사용
explain select * from salaries where to_date < "1986-01-01";


## TRIGGER
# 특정 테이블을 감시하고 있다가 설정한 조건이 감지되면 미이 작성해 놓은 쿼리가 실행 되도록 하는 방법
# 새로운 주니어 개발자가 왔는데 사고칠 것 같은 경우, 실수를 복원할 수 있도록 함.
# user 테이블에 delete나 update 쿼리를 실행하려고 할때, 실행결과들이 backup테이블로 옮겨지도록 함.
# 보통은 하루정도 단위로 사용
use bda;

drop table chat;
create table chat(
	cid int primary key auto_increment,
    msg varchar(20)
);

drop table chat_backup;
create table chat_backup(
	cbid int primary key auto_increment,
    backup_msg varchar(20),
    backup_date timestamp default current_timestamp
);

insert into chat(msg) values ("hello"), ("hi"), ("my name is song!"), ("hi");
select * from chat;

# delimiter 특수문자 ~ end 특수문자 : 쿼리의 종결을 특수문자로 선태, 세미클론 두 번 써야할 것 같을 때 사용
# backup 트리거 생성
# chat테이블에서 delete가 실행되면
# chat_backup테이블에 추가
# old는 삭제되기 전에 선택된 행
delimiter |
	create trigger backup 
	before delete on chat 
	for each row begin
		insert into chat_backup(backup_msg) 
		values (old.msg); 
end |

select * from chat;
select * from chat_backup;

delete from chat where msg like "h%" limit 10;

# show triggers는 나중에 실행해야한다. 실행에서 쿼리선택이 잘 되지 않는다.
# 새로운 쿼리에서 (컨트롤 + tab) 실행을 해봐야할 것 같다.
show triggers;


## BACK UP
# crontab과 .sh파일을 이용하여 scp통해 논리적백업

## syncronization (replication)
# MASTER와 SLAVE 관계

