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
		access_level as 'access_leve',
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
			access_level as 'access_leve',
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
					access_leve=@access_leve,
					company_id=@company_id
			when not matched then
				insert
					(patient_type_id, names, gender, birthday_date, 
					nationality, father_names, mother_names, profession, reference, reference_phone, attach_hospital, blood_group, access_leve, company_id)
				values	
					(@patient_type_id, @names, @gender, @birthday_date, 
					@nationality, @father_names, @mother_names, @profession, @reference, @reference_phone, @attach_hospital, @blood_group, @access_leve, @company_id)
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

