use master;
go
drop database db_hmsys
go
if not exists(select * from sys.databases where name='db_hmsys')
	create database db_hmsys;
go
use db_hmsys;
go