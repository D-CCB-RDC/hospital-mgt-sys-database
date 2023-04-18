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
		names nvarchar(100),
		position_id nvarchar(20),
		level_id nvarchar(10),
		passwords nvarchar(20),
		isactive bit,
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
			names as 'names',
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
create procedure rechercher_names
	@names nvarchar(100)
	as
		select top 20
			user_id as 'user_id',
			names as 'names',
			position_id as 'position',
			level_id  as 'level_id',
			passwords  as 'passwords',
			isactive  as 'isactive',
			email  as 'email',
			telephone  as 'email',
			company_id  as 'company_id'
	from  t_users
	    where
		  	names like '%'+@names+'%'
		order by user_id desc
go
create procedure enregistrer_users
	@user_id int,
	@names nvarchar(100),
	@position_id nvarchar(20),
	@level_id nvarchar(50),
	@passwords nvarchar(50),
	@isactive bit,
	@email nvarchar(50),
	@telephone nvarchar(15),
	@company_id nvarchar(50)
    as
		merge into t_users	
			using (select @user_id as x_id) as x_source
			on(x_source.x_id=t_users.user_id)
			when matched then 
				update set
					names=@names,
					position_id=@position_id,
					level_id=@level_id,
					passwords=@passwords,
					isactive=@isactive,
					email=@email
					telephone=@telephone
					company_id=@company_id
			when not matched then
			   insert
			      (names, position_id, level_id, passwords, isactive, email, telephone, company_id)
			   values
			      (@names, @position_id, @level_id, @passwords, @isactive, @email, @telephone, @company_id)
go
create procedure supprimer_users
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
create procedure afficher_position
	as
		select top 10 
			position_id as 'position_id',
			descriptions as 'descriptions'
		from t_position
			order by position_id desc
go
create procedure rechercher_position
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
create procedure  enregistrer_position
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
create procedure supprimer_position
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
create procedure afficher_level_id
	as
		select top 10
			level_id as 'level_id',
			descriptions as 'descriptions'
		from t_level
			order by level_id desc
go
create procedure  rechercher_level_id
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
create procedure enregistrer_level_id
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
					(@descriptions)
go
create procedure supprimer_level
	@level_id nvarchar(40)
	as
		delete from t_level
			where level_id like @level_id			
-----------------ici se termine la logique de la table t_level----------------------
go
---------------- Hospital Management System-Registration-----------------------------
create table t_patient
(
	id_patient int identity,
	patient_type_id int,
	names nvarchar(100),
	gender nvarchar(50),
	birthday_date nvarchar date,
	nationality nvarchar(50),
	father_names nvarchar(30),
	mother_names nvarchar(30),
	profession nvarchar(30),
	adress nvarchar(max),
	telephone nvarchar(15),
	reference_name nvarchar(50),
	reference_phone nvarchar(15),
	attach_hospital nvarchar(50),
    blood_group nvarchar(10),
	access_level nvarchar(50),
	company_id nvarchar(50),
	status boolean
	constraint pk_patient primary key (id_patient)
)
go
-------------------ici commence la logique de la table t_patient----------------
create procedure afficher_patient
	as
	select top 20
		id_patient as 'id_patient'
		patient_type_id as 'patient_type_id',
		names as 'names',
		gender as 'gender',
		birthday_date  as 'birthday_date',
		nationality as 'nationality',
		father_names as 'father_names',
		mother_names as 'mother_names',
		profession as 'profession',
		adress as 'adress',
		telephone as 'telephone',
		reference_name 'reference_name',
		reference_phone as 'reference',
		attach_hospital as 'attach_hospital',
		blood_group  as 'blood_group',
		access_level as 'access_level',
		company_id as 'company_id',
		status as 'status'
	from  t_patient
		order by id_patient desc
go
create procedure rechercher_patient
	@names nvarchar(100)
	as
		select top 20
			id_patient as 'id_patient'
			patient_type_id as 'patient_type_id',
			names as 'names',
			gender as 'gender',
			birthday_date  as 'birthday_date',
			nationality as 'nationality',
			father_names as 'father_names',
			mother_names as 'mother_names',
			profession as 'profession',
			adress as 'adress',
			telephone as 'telephone',
			reference_name 'reference_name',
			reference_phone as 'reference',
			attach_hospital as 'attach_hospital',
			blood_group  as 'blood_group',
			access_level as 'access_level',
			company_id as 'company_id',
			status boolean
	from t_patient	
		where
			names like @names
		order by id_patient desc
go
create procedure enregistrer_patient
	@id_patient int,
	@patient_type_id int,
	@names nvarchar(100),
	@gender nvarchar(50),
	@birthday_date nvarchar date,
	@nationality nvarchar(50),
	@father_names nvarchar(30),
	@mother_names nvarchar(30),
	@profession nvarchar(30),
	@adress nvarchar(max),
	@telephone nvarchar(15),
	@reference_name nvarchar(50),
	@reference_phone nvarchar(15),
	@attach_hospital nvarchar(50),
    @blood_group nvarchar(10),
	@access_level nvarchar(50),
	@company_id nvarchar(50)
	@status boolean
	as
		merge into t_patient
			using (select @names x_id) as x_source
			on(x_source.x_id=t_patient.names)
			when matched then
				update set
					patient_type_id=@patient_type_id,
					names=@names
					gender=@gender,
					birthday_date=@birthday_date,
					nationality=@nationality,
					father_names=@father_names,
					mother_names=@mother_names,
					profession=@profession,
					adress=@adress,
					telephone=@telephone,
					reference=@reference,
					reference_phone=@reference_phone,
					attach_hospital=@attach_hospital,
					blood_group=@blood_group,
					access_level=@access_level,
					company_id=@company_id
			when not matched then
				insert
					(patient_type_id, names, gender, birthday_date, 
					nationality, father_names, mother_names, profession, reference, reference_phone, attach_hospital, blood_group, access_level, company_id)
				values	
					(@patient_type_id, @names, @gender, @birthday_date, 
					@nationality, @father_names, @mother_names, @profession, @reference, @reference_phone, @attach_hospital, @blood_group, @access_level, @company_id)
go
create procedure supprimer_patient
	@id_patient int
	as
		delete from t_patient
			where id_patient like @id_patient
go				
-------------------ici se termine la logique de la table t_patient----------------
go
create table t_patient_type
(
	patient_type_id int identity,
	descriptipons nvarchar(max),
	status boolean
	constraint pk_patient primary key(patient_type_id)
)
go
-----------------------ici commence la logique de la table patient_type-----------------
create procedure afficher_patient_type
	as
		select top 10
			patient_type_id as 'patient_type_id',
			descriptipons as 'descriptions'
		from patient_type
			order by patient_type_id desc
go
create procedure rechercher_patient_type_id
	@patient_type_id
	as
		select top 10
			patient_type_id as 'patient_type_id',
			descriptions as 'descriptions'	
		from patient_type
			where
				descriptions like '%'+descriptions+'%'
			order by patient_type_id desc
go
create procedure enregistrer_patient_type
	@patient_type_id int,
	@descriptions nvarchar(max)
	as
		merge into patient_type
			using (select @patient_type_id as x_id) as x_source
			on(x_source.x_id=t_patient_type.patient_type_id)
			when matched then
				update set
					descriptions=@descriptions
			when not matched then
				insert
					(descriptions)
				values	
					(@descriptions)
go					
create procedure supprimer_patient_type
	@patient_type_id
	as
		delete from t_patient
			where patient_type_id like @patient_type_id
go
-----------------------ici se termine la logique de la table patient_type---------------
go
create table t_clinical_information
(
	clinical_info_id nvarchar(50),
	height int,
	weights int,
	imc nvarchar(50),
	patient_id int,
	other_information nvarchar(max),
	access_level nvarchar(50),
	company_id nvarchar(50)
	constraint pk_clinical_info primary key (clinical_info_id)
)
go
----------------ici commence la logique de la table t_clinical_information------------------------
create procedure afficher_clinical_info
	as
		select top 20
			clinical_info_id as 'clinical_info_id',
			height  as 'height',
			weights as 'weights',
			imc as 'imc',
			patient_id as 'patient_id',
			other_information as 'other_information',
			access_level as 'access_level',
			company_id as 'company_id'
		from t_clinical_information
			order by clinical_info_id desc
go
create procedure rechercher_clinical_info_id
	as
		select top 10
			clinical_info_id as 'clinical_info_id',
			height as 'heigth',
			weights as 'weigths',
			imc as 'imc',
			patient_id as 'patient_id',
			other_information as 'other_information',
			access_level as 'access_level',
			company_id as 'access_level'
		from t_clinical_information
			where
				patient_id like '%'+clinical_info_id+'%'
			order by clinical_info_id desc
go
create procedure enregistrer_clinical_info_id	
	@clinical_info_id nvarchar(50),
	@height int,
	@weights int,
	@imc nvarchar(50),
	@patient_id int,
	@other_information nvarchar(max),
	@access_level nvarchar(50),
	@company_id nvarchar(50)
	as
		merge into t_clinical_information
			using(select @clinical_info_id as x_id) as x_source
			on(x_source.x_id=t_clinical_information.clinical_info_id)
			when matched then
				update set
					height=@height,
					weights=@weights
					imc=@imc,
					patient_id=@patient_id,
					other_information=@other_information,
					access_level=@access_level,
					company_id=@company_id
			when matched then
				insert
					(height, weights , imc, patient_id, other_information, access_level, company_id)
				values
					(@height, @weights , @imc, @patient_id, @other_information, @access_level, @company_id);
go
create procedure supprimer_clinical_information
	@clinical_info_id nvarchar(50)
	as
		delete from t_clinical_information
			where clinical_info_id like @clinical_info_id
go
------------------------ici se termine la logique de la table t_clinical_information------------------------------------
go			
create table t_checking_medical
(
	id_checking_medical int identity,
	id_company nvarchar(50),
	access_level nvarchar(40),
	id_patient int,
	id_departement_test nvarchar(50),
	id_test_medical nvarchar(50),
	date_checking date,
	descriptions_checking nvarchar(max)
	constraint pk_checking_medical primary key (id_checking_medical)
)
go
-----------------ici commence la logique de la table t_checking_medical------------------
create procedure afficher_id_checking_medical
	as
		select top 20
			id_checking_medical as 'id_checking_medical',
			id_company as 'id_company',
			access_level as 'access_level',
			id_patient as 'id_patient',
			id_departement_test as 'id_departement-test',
			id_test_medical as 'id_test_medical',
			date_checking as 'date_checking',
			descriptions_checking as 'descriptions_checking'
		from t_checking_medical
			order by id_checking_medical desc	
go
create procedure rechercher_id_checking_medical
	@id_patient
	as
		select top 20
			id_checking_medical as 'id_checking_medical',
			id_company as 'id_company',
			access_level as 'access_level',
			id_patient as 'id_patient',
			id_departement_test as 'id_departement-test',
			id_test_medical as 'id_test_medical',
			date_checking as 'date_checking',
			descriptions_checking as 'descriptions_checking'
		from t_checking_medical
			where 
				id_patient like '%'+@id_patient+'%'
			order by id_checking_medical desc
go
create procedure enregistrer_checking_medical	
	@id_checking_medical int,
	@id_company nvarchar(50),
	@access_level nvarchar(40),
	@id_patient int,
	@id_departement_test nvarchar(50),
	@id_test_medical nvarchar(50),
	@date_checkin date,
	@descriptions_checking nvarchar(max)
		as 
			merge into  t_checking_medical
				using (select @id_checking_medical as x_id) as x_source
				on(x_source.x_id=t_checking_medical.id_checking_medical)
				when matched then
					update set
						id_company=@id_company,
						access_level=@access_level,
						id_patient=@id_patient,
						id_departement=@id_departement,
						id_test_medical=@id_test_medical,
						descriptions=@descriptions		
			    when not matched then
					insert
						(id_checking_medical, access_level, id_patient, id_departement, id_test_medical, descriptions)	
					values
						(@id_checking_medical, @access_level, @id_patient, @id_departement, @id_test_medical, @descriptions);
go	
create procedure supprimer_id_checking_medical	
	@id_checking_medical
	as
		delete from t_checking_medical
			where id_checking_medical like @id_checking_medical
go										
-----------------ici se termine la logique de la table t_checking_medical----------------
create table t_resultat_checking
(
	id_resultat_checking int identity,
	id_checking_medical int,
	date_resultats date,
	descriptions nvarchar(max)
	constraint pk_resultat_checking primary key(id_resultat_checking)
)
go
----------------ici commence la logique de la  table t_resultat_checking------------------
create procedure afficher_resultat_checking
    as
	select top 20
		id_resultat_checking as 'id_resultat_checking',
		id_checking_medical as 'id_checking_medical',
		date_resultats as 'date_resultats',
		descriptions as 'descriptions'
	from t_resultat_checking
		other_information by id_resultat_checking desc
go
create procedure rechercher_resultat_checking
	@id_checking_medical int
	as
		select top 20		
			id_resultat_checking as 'id_resultat_checking',
			id_checking_medical as 'id_checking',
			date_resultats as 'date_resultats',
			descriptions as 'descriptions'
		from t_resultat_checking
			where
				id_resultat_checking like '%'+@id_resultat_checking+'%'
			order by id_resultat_checking desc
go
create procedure enregistrer_resultat_checking
	@id_resultat_checking int,
	@id_checking_medical int,
	@date_resultats date,
	@descriptions nvarchar(max)
	as
		merge into t_resultat_checking	
			using (select @id_resultat_checking as x_id) as x_source
			on(x_source.x_id=t_resultat_checking.id_resultat_checking)
			when matched then
				update set 
					id_checking_medical=@id_checking_medical,
					date_resultats=@date_resultats,
					descriptions=@descriptions
			when not matched then
				insert
					(id_checking_medical, date_resultats, descriptions)
				values
					(@id_checking_medical, @date_resultats, @descriptions)
go
create procedure supprimer_resultat_checking
    @id_resultat_checking int
	as
		delete from t_resultat_checking
			where id_resultat_checking like @id_resultat_checking												
----------------ici se termine la logique de la table t_resultat_checking-----------------
go
create table t_interpretations_resultats
(
	id_interpretations int identity,
	id_resultat_checking int,
	descriptions nvarchar(max),
	observations nvarchar(max),
	decision_medical nvarchar(100)
	constraint pk_interpretations_resultats primary key (id_interpretations)
)
go
create procedure afficher_interpretations
	as
	select top 20
		id_interpretations as 'id_interpretations',
		id_resultat_checking as 'id_resultat_checking',
		descriptions as 'descriptions',
		observations as 'observations',
		decision_medical as 'decision_medical'
	from t_interpretations_resultats
		order by id_interpretations desc
go
create procedure rechercher_interpretations
	@id_resultat_checking int
	as
		select top 20
			id_interpretations as 'id_interpretations',
			id_resultat_checking as 'id_resultat_checking',
			descriptions as 'descriptions',
			observations as 'observations',
			decision_medical as 'decision_medical'
        from t_interpretations_resultats
			where
				id_resultat_checking like '%'+@id_resultat_checking
			order by id_interpretations desc	
go
create procedure enregistrer_interpretations_resultats
	@id_interpretations int,
	@id_resultat_checking int,
	@descriptions nvarchar(max),
	@observations nvarchar(max),	
    @decision_medical nvarchar(100)
	as
		merge into t_interpretations_resultats
			using (select @id_interpretations as x_id) as x_source
			on(x_source.x_id=t_interpretations_resultats.id_interpretations)
			when matched then
				update set
					id_resultat_checking=@id_resultat_checking,
					descriptions=@descriptions,
					observations=@observations,
					decision_medical=@decision_medical
			when not matched  then
				insert
					(id_resultat_checking, descriptions, observations, decision_medical)
				values
					(@id_resultat_checking, @descriptions, @observations, @decision_medical)
go
create procedure supprimer_interpretations_resultats
	@id_interpretations int
    as
		delete from t_interpretations_resultats
			where id_interpretations like @id_interpretations
go
-------------------ici se termine la logique de la table t_interpretations_resultats------------------------------
go
create table t_prix_tests_medicaux
(
	id_prix_test int,
	id_company nvarchar(50),
	id_test_medical int,
	prix_usd money,
	prix_fc money,
	active_status nvarchar(50),
	date_enregistrement date
	constraint pk_prix_test_medicaux primary key (id_prix_test)
go
-------------------ici commence la logique de table t_prix_tests_medicaux-------------------
create procedure afficher_prix_tests_medicaux	
	as 
		select top 20
			id_prix_test as 'id_prix_test',
			id_company as 'id_company',
			id_test_medical as 'id_test_medical',
			prix_usd as 'prix_usd',
			prix_fc as 'prix_fc',
			active_status as 'active_status',
			date_enregistrement as 'date_enregistrement'
		from t_prix_tests_medicaux
			order by id_prix_test desc
go
create procedure rechercher_prix_tests_medicaux			
	@id_company nvarchar(50),
	@active_status bit
	as
		select top 20
			id_prix_test as 'id_prix_test',
			id_company as 'id_company',
			id_test_medical as 'id_test_medical',
			prix_usd as 'prix_usd',
			prix_fc as 'prix_fc',
			active_status as 'active_status',
			date_enregistrement as 'date_enregistrement'
		from t_prix_tests_medicaux
			where
				id_company like '%'+@id_company+'%' and active_status = true
			order by id_prix_test desc					
)
go
create procedure enregistrer_prix_tests_medicaux
	@id_prix_test int,
	@id_company nvarchar(50),
	@id_test_medical int,
	@prix_usd money,
	@prix_fc money,
	@active_status nvarchar(50),
	@date_enregistrement date	
	as
		merge into t_prix_tests_medicaux
			using(select @id_prix_test as x_id) as x_source
			on(x_source.x_id=t_prix_tests_medicaux.id_prix_test)
		when not matched then
			insert
				(id_checking_medical, id_test_medical,
				 prix_usd, prix_fc, active_status, date_enregistrement)
			values
				
				(@id_checking_medical, @id_test_medical,
				 @prix_usd, @prix_fc, @active_status, @date_enregistrement)
go
create procedure supprimer_prix_tests_medicaux
	@id_prix_test int
	as
		delete from t_prix_tests_medicaux
			where id_prix_test like @id_prix_test
----------------------ici se termine la logique de la table t_prix_test_medicaux--------------------------
go	
create table t_departement_tests
(
	id_departement_test nvarchar(50),
	descriptions nvarchar(max)
	constraint pk_Departement_tests primary key (id_departement_test)
)
---------------------ici commence la logique de table t_departement_tests-----------------------------------
create procedure afficher_departement_tests
	as
		select top 50
			id_departement_test as 'id_departement-tests',
			descriptions as 'descriptions'
		from t_Departement_tests
			order by id_departement_test desc
go
create procedure rechercher_id_departement_test	
	@id_departement_test
	as
		select top 20
	    	id_departement_test as 'id_departement_tests',
	    	descriptions as 'descriptions'
	from t_interpretations_resultats
		where
			id_departement_tests like '%'+@id_departement_tests+'%'
		order by id_departement_tests
go
create procedure enregistrer_id_departement_tests
	@id_departement_tests nvarchar(50),
	@descriptions	nvarchar(max)
	as
		merge into t_departement_tests	
			using (select @id_departement_tests as x_id) as x_source
			on(x_source.x_id=t_Departement_tests.id_departement_tests)
			when matched then
				update set
					descriptions=@descriptions
			when not matched then
				insert
					(descriptions)
				values
					(@descriptions)
go
create procedure supprimer_departement_tests
	@id_departement_tests
	as
		delete from t_departement_tests
			where id_departement_tests like @id_departement_tests
go
------------------------ici se termine la logique de la table t_Departement_tests----------------------------	
create table t_test_medicaux
(
	id_test_medical nvarchar(40),
	descriptions nvarchar(max)
	constraint pk_test_medicaux primary key (id_test_medical)
)	
go
------------------------ici commence la logique de la table t_test_medicaux--------------------------
create procedure afficher_test_medicaux
	as
		select top 20
			id_test_medical as 'id_test_medical',
			descriptions as 'descriptions'
		from t_test_medicaux
			order by id_test_medical desc
go
create procedure rechercher_id_test_medical
	@id_test_medical nvarchar(40),
	as
		select top 20
			id_test_medical as 'id_test_medical',
			descriptions as 'descriptions'
		from t_test_medicaux
			where
				id_test_medical '%'+@id_test_medical+'%'
			order by id_test_medical desc
go
create procedure enregistrer_test_medicaux
	@id_test_medical nvarchar(40),
	@descriptions nvarchar(max)
	as
		merge into t_prix_test_medicaux
			using (select @id_test_medical as x_id) as x_source
			on (x_source.x_id=t_prix_test_medicaux.id_test_medical)
			when matched then
				update set
					descriptions=@descriptions
			when not matched then
				insert
					(descriptions)
				values
					(@descriptions)											 	
go
create procedure supprimer_prix_test_medicaux
	@id_test_medical
	as
		delete from t_prix_test_medicaux
			where id_test_medical like @id_test_medical
go
----------------------------ici se termine la logique de la table t_prix_test_medicaux--------------
create table t_procurement
(
	procurement_id nvarchar(50),
	procurement_date date,
	consumption_limit_date date,
	expiration_date date,
	product_id 

)

----------------------- TABLES -----------------------

create table procurement (
    procurement_id int identity,
    procurement_date date,
    consumption_limit_date date,
    expiration_date date,
    product_id int,
    shape_id int,
    category_id int,
    container_id int,
    quantity int,
    supplier_id,
    total_quantity int,
    access_level nvarchar(50),
    company_id int,
    purchase_unit_price money,
    sale_unit_price money,
    fabrication_date date,
    active_status boolean,
    constraint pk_procurement primary key (procurement_id)
);

create table product (
    product_id int identity,
    designation nvarchar(max),
    qty_alert int,
    constraint pk_products primary key (product_id)
);

create table shape (
    shape_id int identity,
    designation nvarchar(max),
    constraint pk_shape primary key (shape_id)
);

create table category (
    category_id int identity,
    designation nvarchar(max),
    constraint pk_designation primary key (category_id)
);

create table container (
    container_id int identity,
    designation nvarchar(max),
    constraint pk_container primary key (container_id)
);

create table supplier (
    supplier_id int identity,
    names nvarchar(max),
    phone nvarchar(15),
    addresses nvarchar(max),
    email nvarchar(max),
    constraint pk_supplier primary key (supplier_id)
);

create table order_details (
    order_details_id int identity,
    order_id int,
    procurement_id int,
    order_date date,
    quantity int,
    total_quantity int,
    access_level nvarchar(50),
    company_id int,
    constraint pk_order_details primary key (order_details_id)
);

create table order (
    order_id int identity,
    order_date date,
    quantity int,
    total_quantity date,
    access_level nvarchar(50),
    comapny_id int,
    constraint pk_order primary key (order_id)
);

----------------------- FOREIGN KEYS -----------------------

alter table procurement
add constraint fk_products_procurement
foreign key (product_id)
references product(product_id);

alter table procurement
add constraint fk_shape_procurement
foreign key (shape_id)
references shape(shape_id);

alter table procurement
add constraint fk_category_procurement
foreign key (category_id)
references category(category_id);

alter table procurement
add constraint fk_container_procurement
foreign key (container_id)
references container(container_id);

alter table procurement
add constraint fk_supplier_procurement
foreign key (supplier_id)
references supplier(supplier_id);

alter table order_details
add constraint fk_procurement_order_details
foreign key (procurement_id)
references procurement(procurement_id);

alter table order
add constraint fk_order_details_order
foreign key (order_details_id)
references order_details(order_details_id);

----------------------- LOGIC -----------------------

----------------------- DISPLAY PROCEDURES -----------------------

create procedure afficher_procurement
	as 
	select top 20
		procurement_id as 'Procurement Id.',
        procurement_date as 'Procurement Date',
        consumption_limit_date as 'Cunsumption limit Date',
        expiration_date as 'Expiration Date',
        product_id as 'Product Id.',
        shape_id as 'Shape Id.',
        category_id as 'Category Id.',
        container_id as 'Container id.',
        quantity as 'Quantity',
        supplier_id as 'Supplier Id.',
        total_quantity as 'Total Quantity',
        access_level as 'Access Level',
        company_id as 'Company Id.',
        purchase_unit_price as 'Product Unit Price',
        sale_unit_price as 'Sale Unit Price',
        fabrication_date as 'Fabrication Date',
        active_status as 'Active Status'
	from procurement
		order by procurement_id desc;
go

create procedure afficher_product
	as 
	select top 20
		product_id as 'Product Id.',
        designation as 'Designation',
        qty_alert as 'Quantity Alert'
	from product
		order by product_id desc;
go

create procedure afficher_shape
	as 
	select top 20
		shape_id as 'Shape Id.',
        designation as 'Designation',
	from shape
		order by shape_id desc;
go

create procedure afficher_category
	as 
	select top 20
		category_id as 'Category Id.',
        designation as 'Designation',
	from category
		order by category_id desc;
go

create procedure afficher_container
	as 
	select top 20
		container_id as 'Container Id.',
        designation as 'Designation',
	from container
		order by container_id desc;
go

create procedure afficher_supplier
	as 
	select top 20
		supplier_id as 'Supplier Id.',
        names as 'Names',
        phone as 'Phone Number',
        addresses as 'Physical Address',
        email as 'Email Addrerss'
	from supplier
		order by supplier_id desc;
go

create procedure afficher_order_details
	as 
	select top 20
		order_details_id as 'Order Details Id.',
        order_id as 'Order Id.',
        procurememt_id as 'Procurement Id.',
        order_date as 'Order Date',
        quantity as 'Quantity',
        total_quantity as 'Total Quantity',
        access_level as 'Access Level',
        company_id as 'Company Id.'
	from order_details
		order by order_details_id desc;
go

create procedure afficher_order
	as 
	select top 20
        order_id as 'Order Id.',
        order_date as 'Order Date',
        quantity as 'Quantity',
        total_quantity as 'Total Quantity',
        access_level as 'Access Level',
        company_id as 'Company Id.'
	from order_details
		order by order_details_id desc;
go

----------------------- RESEARCH PROCEDURES -----------------------

create procedure rechercher_procurement
	@procurement_id int,
    @procurement_date date,
    @expiration_date date,
    @supplier_id int
	as
	select top 20
		procurement_id as 'Procurement Id.',
        procurement_date as 'Procurement Date',
        consumption_limit_date as 'Cunsumption limit Date',
        expiration_date as 'Expiration Date',
        product_id as 'Product Id.',
        shape_id as 'Shape Id.',
        category_id as 'Category Id.',
        container_id as 'Container id.',
        quantity as 'Quantity',
        supplier_id as 'Supplier Id.',
        total_quantity as 'Total Quantity',
        access_level as 'Access Level',
        company_id as 'Company Id.',
        purchase_unit_price as 'Product Unit Price',
        sale_unit_price as 'Sale Unit Price',
        fabrication_date as 'Fabrication Date',
        active_status as 'Active Status'
	from procurement
	   where
	   		procurement_id like '%'+@procurement_id+'%',
            procurement_date like '%'+@procurement_date+'%',
            expiration_date like '%'+@expiration_date+'%',
            supplier_id like '%'+@supplier_id+'%'
		order by procurement_id desc;			
go

create procedure rechercher_product
    @product_id int
    as
        select top 20 
            product_id as 'Product Id.',
            designation as 'Designation',
            qty_alert as 'Quantity Alert'
        from product
            where
                product_id like '%' + @product_id + '%'
            order by product_id desc;
go

create procedure rechercher_shape
    @shape_id int
    as
        select top 20
            shape_id as 'Shape Id.',
            designation as 'Designation'
        from shape
            where
                shape_id like '%' + shape_id + '%'
            order by shape_id desc;
go

create procedure rechercher_category
    @category_id int
    as
        select top 20
            category_id as 'Category_id',
            designation as 'Designation'
        from category
            where
                category_id like '%' + @category_id + '%'
            order by category_id desc;
go

create procedure rechercher_container
    @container_id int
    as
        select top 20
            container_id as 'Container Id.',
            designation as 'Designation'
        from container
            where
                container_id like '%' + @container_id + '%'
            order by container_id desc;
go

create procedure rechercher_supplier
    @supplier_id int,
    @names nvarchar(max)
    as
        select top 20
            supplier_id as 'Supplier Id.',
            names as 'Names',
            phone as 'Phone Number',
            addresses as 'Physical Address',
            email as 'Email Address'
        from supplier
            where
                supplier_id like '%' + @supplier_id + '%',
                names like '%' + @names + '%'
            order by supplier_id desc;
go

create procedure rechercher_order_details
    @order_details_id int,
    @order_id int,
    @company_id int
    as
        select top 20
            order_details_id as 'Order Details Id.',
            order_id as 'Order Id.',
            procurement_id as 'Procurement Id.'
            order_date as 'Order Date',
            quantity as 'Quantity',
            total_quantity as 'Total Quantity',
            access_level as 'Access Level',
            company_id as 'Company Id.'
        from order_details
            where
                order_details_id like '%' + @order_details_id + '%',
                order_id like '%' + @order_id + '%',
                company_id like '%' + @company_id + '%'
            order by order_details_id desc;
go

create procedure rechercher_order
    @order_id int,
    @order_date date
    as
        select top 20
            order_id as 'Order Id.',
            order_date as 'Order Date',
            quantity as 'Quantity',
            total_quantity as 'Total Quantity',
            access_level as 'Access Level',
            company_id as 'Company Id.'
        from order
            where
                order_id like '%' + @order_id + '%',
                order_date like '%' + order_date + '%'
            order by order_id desc;
go

----------------------- REGISTER PROCEDURES -----------------------

create procedure enregistrer_procurement
    @procurement_id int,
    @procurement_date date,
    @consumption_limit_date date,
    @expiration_date date,
    @product_id int,
    @shape_id int,
    @category_id int,
    @container_id int,
    @quantity int,
    @supplier_id int,
    @total_quantity int,
    @access_level nvarchar(50),
    @company_id int,
    @purchase_unit_price money,
    @sale_unit_price money,
    @fabrication_date date,
    @active_status boolean
	as
		merge into procurement
			using (select @procurement_id as x_id) as x_source
			on(x_source.x_id = procurement.procurement_id)
			when matched then
				update set	
					procurement_id = @procurement_id,
                    procurement_date = @procurement_date,
                    consumption_limit_date = @consumption_limit_date,
                    expiration_date = @expiration_date,
                    product_id = @product_id,
                    shape_id = @shape_id,
                    category_id = @category_id,
                    container_id = @container_id,
                    quantity = @quantity,
                    supplier_id = @supplier_id,
                    total_quantity = @total_quantity,
                    access_level = @access_level,
                    company_id = @company_id,
                    purchase_unit_price = @purchase_unit_price,
                    sale_unit_price = @sale_unit_price,
                    fabrication_date = @fabrication_date,
                    active_status = true
			when not matched then
				insert
					(procurement_id, procurement_date, consumption_limit_date, expiration_date, product_id, shape_id, category_id, container_id, quantity, supplier_id, total_quantity, access_level, company_id, purchase_unit_price, sale_unit_price, fabrication_date, active_status)
				values
					(@procurement_id, @procurement_date, @consumption_limit_date, @expiration_date, @product_id, @shape_id, @category_id, @container_id, @quantity, @supplier_id, @total_quantity, @access_level, @company_id, @purchase_unit_price, @sale_unit_price, @fabrication_date, @active_status);
go

create procedure enregistrer_product
	@product_id int,
	@designation nvarchar(max),
	@qty_alert nvarchar(50)
	as
		merge into product
			using (select @product_id as x_id) as x_source
			on (x_source.x_id = product.product_id)
			when matched then
				update set
					product_id = @product_id,
					designation = @designation,
					qty_alert = @qty_alert
			when not matched then
				insert
					(product_id, designation, qty_alert)
				values
					(@product_id, @designation, @qty_alert);
go

create procedure enregistrer_shape
	@shape_id int,
	@designation nvarchar(max)
	as
		merge into shape
			using (select @shape_id as x_id) as x_source
			on (x_source.x_id = shape.shape_id)
			when matched then
				update set
					shape_id = @shape_id,
					designation = @designation
			when not matched then
				insert
					(shape_id, designation)
				values
					(@shape_id, @designation);
go

create procedure enregistrer_category
	@category_id int,
	@designation nvarchar(max)
	as
		merge into category
			using (select @category_id as x_id) as x_source
			on (x_source.x_id = category.category_id)
			when matched then
				update set
					category_id = @category_id,
					designation = @designation
			when not matched then
				insert
					(category_id, designation)
				values
					(@category_id, @designation);
go

create procedure enregistrer_container
	@container_id int,
	@designation nvarchar(max)
	as
		merge into container
			using (select @container_id as x_id) as x_source
			on (x_source.x_id = container.container_id)
			when matched then
				update set
					container_id = @container_id,
					designation = @designation
			when not matched then
				insert
					(container_id, designation)
				values
					(@container_id, @designation);
go

create procedure enregistrer_supplier
	@supplier_id int,
	@names nvarchar(max),
	@phone nvarchar(15),
	@addresses nvarchar(max),
	@email nvarchar(max)
	as
		merge into supplier
			using (select @supplier_id as x_id) as x_source
			on (x_source.x_id = supplier.supplier)
			when not matched then
				update set 
					supplier_id = @supplier_id,
					names = @names,
					phone = @phone,
					addresses = @addresses,
					email = @email
			when not matched then
				insert
					(supplier_id, names, phone, addresses, email) 
				into
					(@supplier_id, @names, @phone, @addresses, @email);
go

create procedure enregistrer_order_details
	@order_details_id int,
	@order_id int,
	@procurememt_id int,
	@order_date date,
	@quantity int,
	@total_quantity int,
	@access_level nvarchar(50),
	@company_id int
	as
		merge into order_details
			using (order_details_id as x_id) as x_source
			on (x_source.x_id = order_details.order_details_id)
			when matched then
				update set
					order_details_id = @order_details_id,
					order_id = @order_id,
					procurement_id = @procurement_id,
					order_date = @order_date,
					quantity = @quantity,
					total_quantity = @total_quantity,
					access_level = @access_level,
					comapny_id = @comapny_id
			when not matched then
				insert
					(order_date, order_id, order_id, procurement_id, order_date, quantity, total_quantity, access_level, comapny_id)
				values
					(@order_date, @order_id, @order_id, @procurement_id, @order_date, @quantity, @total_quantity, @access_level, @comapny_id);
					
----------------------- DELETE PROCEDURES -----------------------

create procedure supprimer_procurement
	@procurement_id int
	as
		merge into procurement
            using (@procurement_id as x_id) as x_source
            on (x_source.x_id = procurement.procurement_id)
            when matched then
                update set
			        active_status = false;
go