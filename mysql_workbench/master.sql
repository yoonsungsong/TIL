create database mydb1;
show databases;

show master status;

# 슬래이브 생성 후 진행
use mydb1;

create table user(
	data varchar(20)
);

insert into user values ("data1"), ("data2");

select * from user;
