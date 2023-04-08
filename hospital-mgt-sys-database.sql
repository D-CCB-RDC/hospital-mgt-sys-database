use master;
go
drop database db_hmsys
go
if not exists(select * from sys.databases where name='db_hmsys')
	create database db_hmsys;
go
use db_hmsys;
go
create table t_company
(
	company_id nvarchar(50),
	company_name nvarchar(50),
	logo nvarchar(max),
	adresse nvarchar(max),
	email nvarchar(50),
	telephone nvarchar(15),
	legal_info nvarchar(max)
	constraint pk_company primary key (company_id)
)
go