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
---------------------ici commence la logique de la table t_company---------------------------

create procedure afficher t_company
	as 
	select top 20
		company_id as 'company_id',
		company_name as 'company_name',
		logo as 'logo',
		adresse as 'adresse',
		email as 'email',
		telephone as 'telephone',
		legal_info as 'legal_info'
	from t_company
		order by company_id desc
go
create procedure rechercher company_name
	@company_name nvarchar(50)
	as
	select top 20
		company_id as 'company_id',
		company_name as 'company_name',
		logo as 'logo',
		adresse as 'adresse',
		email as 'email',
		telephone as 'telephone',
		legal_info as 'legal_info'
	from t_company
	   where
	   		company_name like '%'+@company_name+%
		order by company_id desc				
go
create procedure enregistrer company_name
		@company_id nvarchar(50),
		@company_name nvarchar(50),
		@logo nvarchar(max),
		@adresse nvarchar(max),
		@email nvarchar(50),
		@telephone nvarchar(15),
		@legal_info nvarchar(max)
	as
		merge into t_company
			using (select @company_id as x_id) as x_source
			on(x_source.x_id=t_company.company_id)
			when matched then
				update set	
					company_name=@company_name
					logo =@logo
					adresse=@adresse
					email=@email
					telephone=@telephone
					legal_info=@ legal_info
			when not matched then
				insert
					(company_name, logo, adresse, telephone, legal_info)
				values
					(@company_name, @logo, @adresse, @telephone, @legal_info)
go
create procedure supprimer t_company
	@company_id int
	as
		delete from t_company
			where company_id like @company_id
go			
-----------------------ici se termine la logique de la table t_company--------------------------
go

create table t_users
	(
		user_id int identity,
		first_name nvarchar(15),
		last_name nvarchar(25),
		position_id nvarchar(20),
		level_id nvarchar(10),
		passwords nvarchar(20),
		isactive nvarchar(30),
		email nvarchar(50),
		telephone nvarchar(15),
		company_id nvarchar(50)
	constraint pk_users primary key (user_id)
)
go
-------------------ici commence la logique du table t_users-----------------
create procedure afficher t_users
	as
		select top 20
			user_id as 'user_id',
			first_name  as 'first_name',
			last_name  as 'last_name',
			position_id as 'position',
			level_id  as 'level_id',
			passwords  as 'passwords',
			isactive  as 'isactive',
			email  as 'email',
			telephone  as 'email',
			company_id  as 'company_id'
        from t_users
		    order by user_id desc
go
create procedure rechercher first_name and last_name
	@first_name nvarchar(20) and last_name nvarchar(20)
	as
		select top 20
			user_id as 'user_id',
			first_name  as 'first_name',
			last_name  as 'last_name',
			position_id as 'position',
			level_id  as 'level_id',
			passwords  as 'passwords',
			isactive  as 'isactive',
			email  as 'email',
			telephone  as 'email',
			company_id  as 'company_id'
	from  t_users
	    where
		  	first_name and last_name like '%'+@first_name+'%' and '%'+last_name+'%'	
		order by user_id desc
go
create procedure enregistrer t_users
	@user_id int identity,
	@first_name nvarchar(15),
	@last_name nvarchar(25),
	@position_id nvarchar(20),
	@level_id nvarchar(10),
	@passwords nvarchar(20),
	@isactive nvarchar(30),
	@email nvarchar(50),
	@telephone nvarchar(15),
	@company_id nvarchar(50)
    as
		merge into t_users	
			using (select @user_id as x_id) as x_source
			on(x_source.x_id=t_users.user_id)
			when matched then 
				update set
					first_name=@first_name
					last_name=@last_name
					position_id=@position_id
					level_id=@level_id
					passwords=@passwords
					isactive=@isactive
					email=@email
					telephone=@telephone
					company_id=@company_id
			when not master then
			   insert
			      (first_name, last_name, position_id, level_id, passwords, isactive, email, telephone, company_id)
			   values
			      (@first_name, @last_name, @position_id, @level_id, @passwords, @isactive, @email, @telephone, @company_id)

go
create procedure supprimer t_users
	@user_id int
	as
		delete from t_users
			where user_id like @user_id
go
-------------------ici se termine la logique du table t_user-------------------			

create table t_position
(
	position_id nvarchar(40),
	descriptions nvarchar(max)
	constraint pk_position primary key (position_id)
)
go

-----------------ici commence la logique de la table t_position----------------
go
create procedure afficher position
	as
		select top 10 
			position_id as 'position_id',
			descriptions as 'descriptions'
		from t_position
			order by position_id desc
go
create procedure rechercher position
	@position_id
	as
		select top 10
			position_id as 'position_id',
			descriptions as 'descriptipons'
	from t_position
		where
			position_id like '%+@position_id+@'
		order by position_id desc
go
create procedure  enregistrer position
	@position_id nvarchar(40),
	@descriptions nvarchar(max)
	as
		merge into t_position
			using (select @position_id as x_id) as x_source
			on(x_source.x_id=t_position.position_id)
			when matched then
				update set
					descriptions=@descriptions
			when not matched then
				insert
					(descriptions)
				values
					(@descriptions)
go
create procedure supprimer t_position
	@position_id nvarchar(40)
	as
		delete from t_position
			when position_id like @position_id						
go			
----------------ici se termine la logique de la table t_position-----------------
create table t_level
(
	level_id nvarchar(40),
	descriptions nvarchar(max)
	constraint pk_level primary key (level_id)
)
go
-----------------ici commence la logique de la table t_level----------------------
create procedure afficher level_id
	as
		select top 10
			level_id as 'level_id',
			descriptions as 'descriptions'
		from t_level
			order by level_id desc
go
create procedure  rechercher level_id
	@level_id
	as
		select top 20
			level_id as 'level_id',
			descriptions as 'level_id'
		from t_level
			where
				level_id like '%'+level_id+'%' 
			order by level_id desc
go
create procedure enregistrer level_id
	@level_id nvarchar(40),
	@descriptions nvarchar(max)
	as
		merge into t_level
			using(select @level_id as x_id) as x_source
			on(x_source.x_id=t_level.level_id)
			when matched then
				update set
					descriptions=@descriptions
			when not matched then
				insert 
					(descriptions)
				values
					(descriptions)
-----------------ici se termine la logique de la table t_level----------------------