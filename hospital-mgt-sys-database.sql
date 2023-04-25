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
	legal_info nvarchar(max),
	active_status bit,
	constraint pk_company primary key (company_id)
);
go
---------------------ici commence la logique de la table t_company---------------------------
create procedure afficher_t_company
	as 
	select top 20
		company_id as 'Company Id.',
		company_name as 'Company Name',
		logo as 'Logo',
		adresse as 'Address',
		email as 'Email',
		telephone as 'Phone Number',
		legal_info as 'Legal Informations'
	from t_company
		order by company_id desc
	where active_status = 1;
go

create procedure rechercher_company_name
	@company_name nvarchar(50)
	as
	select top 20
		company_id as 'Company Id',
		company_name as 'Company Name',
		logo as 'Logo',
		adresse as 'Address',
		email as 'Email',
		telephone as 'Phone Number',
		legal_info as 'Legal Informations',
		active_status as 'Active Status'
	from t_company
	   where
	   		company_name like '%'+@company_name+'%'
		order by company_id desc;			
go

create procedure enregistrer_company
		@company_id nvarchar(50),
		@company_name nvarchar(50),
		@logo nvarchar(max),
		@adresse nvarchar(max),
		@email nvarchar(50),
		@telephone nvarchar(15),
		@legal_info nvarchar(max),
		@active_status bit
	as
		merge into t_company
			using (select @company_id as x_id) as x_source
			on(x_source.x_id = t_company.company_id)
			when matched then
				update set	
					company_name = @company_name,
					logo = @logo,
					adresse = @adresse,
					email = @email,
					telephone = @telephone,
					legal_info = @ legal_info,
					active_status = 1
			when not matched then
				insert
					(company_name, logo, adresse, telephone, legal_info, active_status)
				values
					(@company_name, @logo, @adresse, @telephone, @legal_info, 1);
go

create procedure supprimer_company
	@comapny_id int
	as
		merge into t_company
            using (@company_id as x_id) as x_source
            on (x_source.x_id = t_company.company_id)
            when matched then
                update set
			        active_status = 0;
go

-----------------------ici se termine la logique de la table t_company--------------------------

create table t_users (
	user_id int identity,
	names nvarchar(100),
	position_id nvarchar(20),
	level_id nvarchar(10),
	passwords nvarchar(20),
	isactive bit,
	email nvarchar(50),
	telephone nvarchar(15),
	company_id nvarchar(50),
	active_status bit,
	constraint pk_users primary key (user_id)
);
go
-------------------ici commence la logique du table t_users-----------------

create procedure afficher_t_users
as
	select top 20
		user_id as 'User Id',
		names as 'Names',
		position_id as 'Position',
		level_id  as 'Level Id',
		passwords  as 'Passwords',
		isactive  as 'Status',
		email  as 'email',
		telephone  as 'email',
		company_id  as 'Company Id',
	from t_users
		order by user_id desc
	where active_status = 1;
go

create procedure rechercher_names
	@names nvarchar(100)
	as
		select top 20
			user_id as 'User Id',
			names as 'Names',
			position_id as 'Position',
			level_id  as 'Level Id',
			passwords  as 'Passwords',
			isactive  as 'Status',
			email  as 'email',
			telephone  as 'email',
			company_id  as 'Company Id',
			active_status as 'Active Status'
	from  t_users
	    where
		  	names like '%'+@names+'%'
		order by user_id desc;
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
					email=@email,
					telephone=@telephone,
					company_id=@company_id,
					active_status = 1;
			when not matched then
			   insert
			      (names, position_id, level_id, passwords, isactive, email, telephone, company_id, active_status)
			   values
			      (@names, @position_id, @level_id, @passwords, @isactive, @email, @telephone, @company_id, 1);
go

create procedure supprimer_user
	@user_id int
	as
		merge into t_users
            using (@user_id as x_id) as x_source
            on (x_source.x_id = t_users.user_id)
            when matched then
                update set
			        active_status = 0;
go

-------------------ici se termine la logique du table t_users-------------------		

create table t_position
(
	position_id nvarchar(40),
	descriptions nvarchar(max),
	active_status bit,
	constraint pk_position primary key (position_id)
);
go

-----------------ici commence la logique de la table t_position----------------

create procedure afficher_position
	as
		select top 10 
			position_id as 'Position Id.',
			descriptions as 'Descriptions'
		from t_position
			order by position_id desc
		where active_status = 1;
go

create procedure rechercher_position
	@descriptions
	as
		select top 10
			position_id as 'Position Id.',
			descriptions as 'Descriptions',
			active_status as 'Active Status'
	from t_position
		where
			descriptions like '%'+@descriptions+'%'
		order by position_id desc;
go

create procedure enregistrer_position
	@position_id nvarchar(40),
	@descriptions nvarchar(max)
	as
		merge into t_position
			using (select @position_id as x_id) as x_source
			on(x_source.x_id=t_position.position_id)
			when matched then
				update set
					descriptions = @descriptions,
					active_status = 1
			when not matched then
				insert
					(descriptions, active_status)
				values
					(@descriptions, 1);
go

create procedure supprimer_position
	@position_id int
	as
		merge into t_position
            using (@position_id as x_id) as x_source
            on (x_source.x_id = t_position.position_id)
            when matched then
                update set
			        active_status = 0;
go			
----------------ici se termine la logique de la table t_position-----------------

create table t_level
(
	level_id nvarchar(40),
	descriptions nvarchar(max),
	active_status bit,
	constraint pk_level primary key (level_id)
);
go
-----------------ici commence la logique de la table t_level----------------------
create procedure afficher_level_id
	as
		select top 10
			level_id as 'Level Id',
			descriptions as 'Descriptions'
		from t_level
			order by level_id desc
		where active_status = 1;
go

create procedure rechercher_level_id
	@descriptions
	as
		select top 20
			level_id as 'Level Id',
			descriptions as 'Descriptions',
			active_status as 'Active Status'
		from t_level
			where
				descriptions like '%'+@descriptions+'%'
			order by level_id desc;
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
					descriptions = @descriptions,
					active_status = 1
			when not matched then
				insert 
					(descriptions, active_status)
				values
					(@descriptions, 1);
go

create procedure supprimer_level
	@user_id int
	as
		merge into t_level
            using (@level_id as x_id) as x_source
            on (x_source.x_id = t_level.level_id)
            when matched then
                update set
			        active_status = 0;
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
	active_status bit,
	constraint pk_patient primary key (id_patient)
);
go
-------------------ici commence la logique de la table t_patient----------------

create procedure afficher_patient
	as
	select top 20
		id_patient as 'Patient Id',
		patient_type_id as 'Patient Id Type',
		names as 'Names',
		gender as 'Gender',
		birthday_date  as 'Birthday Date',
		nationality as 'Nationality',
		father_names as 'Father Names',
		mother_names as 'Mother Names',
		profession as 'Profession',
		adress as 'Address',
		telephone as 'Phone Number',
		reference_name 'Reference Name',
		reference_phone as 'Reference',
		attach_hospital as 'Attached Hospital',
		blood_group  as 'Blood Group',
		access_level as 'Access Level',
		company_id as 'Company Id'
	from  t_patient
		order by id_patient desc
	where active_status = 1;
go

create procedure rechercher_patient
	@names nvarchar(100)
	as
		select top 20
			id_patient as 'Patient Id',
			patient_type_id as 'Patient Id Type',
			names as 'Names',
			gender as 'Gender',
			birthday_date  as 'Birthday Date',
			nationality as 'Nationality',
			father_names as 'Father Names',
			mother_names as 'Mother Names',
			profession as 'Profession',
			adress as 'Address',
			telephone as 'Phone Number',
			reference_name 'Reference Name',
			reference_phone as 'Reference',
			attach_hospital as 'Attached Hospital',
			blood_group  as 'Blood Group',
			access_level as 'Access Level',
			company_id as 'Company Id',
			active_status as 'Active Status'
	from t_patient	
		where
			names like @names
		order by id_patient desc;
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
	@company_id nvarchar(50),
	@status bit
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
					company_id=@company_id,
					active_status=1
			when not matched then
				insert
					(patient_type_id, names, gender, birthday_date, nationality, father_names, mother_names, profession, reference, reference_phone, attach_hospital, blood_group, access_level, company_id, active_status)
				values	
					(@patient_type_id, @names, @gender, @birthday_date, @nationality, @father_names, @mother_names, @profession, @reference, @reference_phone, @attach_hospital, @blood_group, @access_level, @company_id, 1);
go

create procedure supprimer_patient
	@patient_id int
	as
		merge into t_patient
            using (@patient_id as x_id) as x_source
            on (x_source.x_id = t_patient.patient_id)
            when matched then
                update set
			        active_status = 0;
go				
-------------------ici se termine la logique de la table t_patient----------------

create table t_patient_type
(
	patient_type_id int identity,
	descriptions nvarchar(max),
	status bit,
	constraint pk_patient primary key(patient_type_id)
);
go
-----------------------ici commence la logique de la table patient_type-----------------
create procedure afficher_patient_type
	as
		select top 10
			patient_type_id as 'Patient Type Id.',
			descriptions as 'Descriptions'
		from patient_type
			order by patient_type_id desc
		where active_status = 1;
go

create procedure rechercher_patient_type_id
	@descriptions
	as
		select top 10
			patient_type_id as 'Patient Type Id',
			descriptions as 'Descriptions',
			active_status as 'Active Status'
		from patient_type
			where
				descriptions like '%'+descriptions+'%'
			order by patient_type_id desc;
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
					descriptions = @descriptions,
					active_status = 1
			when not matched then
				insert
					(descriptions, active_status)
				values	
					(@descriptions, 1);
go			

create procedure supprimer_patient_type
	@patient_type_id int
	as
		merge into t_patient_type
            using (@patient_type_id as x_id) as x_source
            on (x_source.x_id = t_patient_type.patient_type_id)
            when matched then
                update set
			        active_status = 0;
go
-----------------------ici se termine la logique de la table patient_type---------------

create table t_clinical_information
(
	clinical_info_id nvarchar(50),
	height int,
	weights int,
	imc nvarchar(50),
	patient_id int,
	other_information nvarchar(max),
	access_level nvarchar(50),
	company_id nvarchar(50),
	active_status bit,
	constraint pk_clinical_info primary key (clinical_info_id)
);
go

----------------ici commence la logique de la table t_clinical_information------------------------
create procedure afficher_clinical_info
	as
		select top 20
			clinical_info_id as 'Clinical Info Id.',
			height  as 'Height',
			weights as 'Weight',
			imc as 'IMC',
			patient_id as 'Patient Id',
			other_information as 'Other Informations',
			access_level as 'Access Level',
			company_id as 'Company Id'
		from t_clinical_information
			order by clinical_info_id desc
		where active_status = 1;
go

create procedure rechercher_clinical_info_id
	as
		select top 10
			clinical_info_id as 'Clinical Info Id.',
			height as 'Heigth',
			weights as 'Weigth',
			imc as 'IMC',
			patient_id as 'Patient Id',
			other_information as 'Other Informations',
			access_level as 'Access Level',
			company_id as 'Company Id',
			active_status as 'Active Status'
		from t_clinical_information
			where
				patient_id like '%'+clinical_info_id+'%'
			order by clinical_info_id desc;
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
					company_id=@company_id,
					active_status = 1
			when matched then
				insert
					(height, weights , imc, patient_id, other_information, access_level, company_id, active_status)
				values
					(@height, @weights , @imc, @patient_id, @other_information, @access_level, @company_id, 1);
go

create procedure supprimer_clinical_info
	@clinical_info_id int
	as
		merge into t_patient_type
            using (@clinical_info_id as x_id) as x_source
            on (x_source.x_id = t_clinical_information.clinical_info_id)
            when matched then
                update set
			        active_status = 0;
go
------------------------ici se termine la logique de la table t_clinical_information------------------------------------
			
create table t_checking_medical
(
	id_checking_medical int identity,
	company_id nvarchar(50),
	access_level nvarchar(40),
	id_patient int,
	id_departement_test nvarchar(50),
	id_test_medical nvarchar(50),
	date_checking date,
	descriptions_checking nvarchar(max),
	active_status bit,
	constraint pk_checking_medical primary key (id_checking_medical)
);
go

-----------------ici commence la logique de la table t_checking_medical------------------
create procedure afficher_id_checking_medical
	as
		select top 20
			id_checking_medical as 'Id Medical Checking',
			company_id as 'Company Id',
			access_level as 'Access Level',
			id_patient as 'Patient Id',
			id_departement_test as 'Test Department',
			id_test_medical as 'Medical Test Id',
			date_checking as 'Checking Date',
			descriptions_checking as 'Checking Description'
		from t_checking_medical
			order by id_checking_medical desc
		where active_status = 1;
go

create procedure rechercher_id_checking_medical
	@id_patient
	as
		select top 20
			id_checking_medical as 'Id Medical Checking',
			company_id as 'Company Id',
			access_level as 'Access Level',
			id_patient as 'Patient Id',
			id_departement_test as 'Test Department',
			id_test_medical as 'Medical Test Id',
			date_checking as 'Checking Date',
			descriptions_checking as 'Checking Description',
			active_status as 'Active Status'
		from t_checking_medical
			where 
				id_patient like '%'+@id_patient+'%'
			order by id_checking_medical desc;
go

create procedure enregistrer_checking_medical	
	@id_checking_medical int,
	@company_id nvarchar(50),
	@access_level nvarchar(40),
	@id_patient int,
	@id_departement_test nvarchar(50),
	@id_test_medical nvarchar(50),
	@date_checking date,
	@descriptions_checking nvarchar(max)
		as 
			merge into  t_checking_medical
				using (select @id_checking_medical as x_id) as x_source
				on(x_source.x_id=t_checking_medical.id_checking_medical)
				when matched then
					update set
						company_id=@company_id,
						access_level=@access_level,
						id_patient=@id_patient,
						id_departement=@id_departement,
						id_test_medical=@id_test_medical,
						date_checking=@date_checking,
						descriptions=@descriptions,
						active_status=1	
			    when not matched then
					insert
						(id_checking_medical, access_level, id_patient, id_departement, id_test_medical, date_checking, descriptions, active_status)	
					values
						(@id_checking_medical, @access_level, @id_patient, @id_departement, @id_test_medical, @date_checking, @descriptions, 1);
go

create procedure supprimer_checking_medical
	@id_checking_medical int
	as
		merge into t_checking_medical
            using (@id_checking_medical as x_id) as x_source
            on (x_source.x_id = t_checking_medical.id_checking_medical)
            when matched then
                update set
			        active_status = 0;
go									
-----------------ici se termine la logique de la table t_checking_medical----------------
create table t_resultat_checking
(
	id_resultat_checking int identity,
	id_checking_medical int,
	date_resultats date,
	descriptions nvarchar(max),
	active_status bit,
	constraint pk_resultat_checking primary key(id_resultat_checking)
);
go
----------------ici commence la logique de la  table t_resultat_checking------------------
create procedure afficher_resultat_checking
    as
	select top 20
		id_resultat_checking as 'Checking Results Id.',
		id_checking_medical as 'Medical Checking Id.',
		date_resultats as 'Rsults Date',
		descriptions as 'Descriptions'
	from t_resultat_checking
		other_information by id_resultat_checking desc
	where active_status = 1;
go

create procedure rechercher_resultat_checking
	@id_checking_medical int
	as
		select top 20		
			id_resultat_checking as 'Checking Results Id.',
			id_checking_medical as 'Medical Checking Id.',
			date_resultats as 'Rsults Date',
			descriptions as 'Descriptions',
			active_status as 'Active Status'
		from t_resultat_checking
			where
				id_resultat_checking like '%'+@id_resultat_checking+'%'
			order by id_resultat_checking desc;
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
					descriptions=@descriptions,
					active_status=1
			when not matched then
				insert
					(id_checking_medical, date_resultats, descriptions, active_status)
				values
					(@id_checking_medical, @date_resultats, @descriptions, 1);
go

create procedure supprimer_resultat_checking
	@id_resultat_checking int
	as
		merge into t_checking_medical
            using (@id_resultat_checking as x_id) as x_source
            on (x_source.x_id = t_resultat_checking.id_resultat_checking)
            when matched then
                update set
			        active_status = 0;
go
----------------ici se termine la logique de la table t_resultat_checking-----------------

create table t_interpretations_resultats
(
	id_interpretations int identity,
	id_resultat_checking int,
	descriptions nvarchar(max),
	observations nvarchar(max),
	decision_medical nvarchar(100),
	active_status bit,
	constraint pk_interpretations_resultats primary key (id_interpretations)
)
go
create procedure afficher_interpretations
	as
	select top 20
		id_interpretations as 'Interpretations Id.',
		id_resultat_checking as 'Checking Results Id.',
		descriptions as 'Descriptions',
		observations as 'Observations',
		decision_medical as 'Medical Decision'
	from t_interpretations_resultats
		order by id_interpretations desc
	where id_interpretations = 1;
go

create procedure rechercher_interpretations
	@id_resultat_checking int
	as
		select top 20
			id_interpretations as 'Interpretations Id.',
			id_resultat_checking as 'Checking Results Id.',
			descriptions as 'Descriptions',
			observations as 'Observations',
			decision_medical as 'Medical Decision',
			active_status as 'Active Status'
        from t_interpretations_resultats
			where
				id_resultat_checking like '%'+@id_resultat_checking+'%'
			order by id_interpretations desc;
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
					decision_medical=@decision_medical,
					active_status=1
			when not matched  then
				insert
					(id_resultat_checking, descriptions, observations, decision_medical, active_status)
				values
					(@id_resultat_checking, @descriptions, @observations, @decision_medical, 1);
go

create procedure supprimer_interpretation_medical
	@id_interpretations int
	as
		merge into t_interpretations_resultats
            using (@id_interpretations as x_id) as x_source
            on (x_source.x_id = t_interpretations_resultats.id_interpretations)
            when matched then
                update set
			        active_status = 0;
go
-------------------ici se termine la logique de la table t_interpretations_resultats------------------------------
go
create table t_prix_tests_medicaux
(
	id_prix_test int,
	company_id nvarchar(50),
	id_test_medical int,
	prix_usd money,
	prix_fc money,
	date_enregistrement date,
	active_status bit,
	constraint pk_prix_test_medicaux primary key (id_prix_test)
);
go
-------------------ici commence la logique de table t_prix_tests_medicaux-------------------
create procedure afficher_prix_tests_medicaux	
	as 
		select top 20
			id_prix_test as 'Medical Test Id.',
			company_id as 'Company Id.',
			id_test_medical as 'Medical Test Id.',
			prix_usd as 'Price USD',
			prix_fc as 'Price UCF',
			active_status as 'Active Status',
			date_enregistrement as 'Register Date'
		from t_prix_tests_medicaux
			order by id_prix_test desc
		where active_status = 1;
go

create procedure rechercher_prix_tests_medicaux			
	@id_test_medical nvarchar(50)
	as
		select top 20
			id_prix_test as 'Medical Test Id.',
			company_id as 'Company Id.',
			id_test_medical as 'Medical Test Id.',
			prix_usd as 'Price USD',
			prix_fc as 'Price UCF',
			date_enregistrement as 'Register Date',
			active_status as 'Active Status'
		from t_prix_tests_medicaux
			where
				company_id like '%'+@company_id+'%'
			order by id_prix_test desc;			
go

create procedure enregistrer_prix_tests_medicaux
	@id_prix_test int,
	@company_id nvarchar(50),
	@id_test_medical int,
	@prix_usd money,
	@prix_fc money,
	@date_enregistrement date
	as
		merge into t_prix_tests_medicaux
			using(select @id_prix_test as x_id) as x_source
			on(x_source.x_id=t_prix_tests_medicaux.id_prix_test)
		when matched then
			update set
				company_id = @company_id,
				id_test_medical = @id_test_medical,
				prix_usd = @prix_usd,
				prix_fc = @prix_fc,
				date_enregistrement = @date_enregistrement,
				active_status = 1;
		when not matched then
			insert
				(id_checking_medical, id_test_medical, prix_usd, prix_fc, active_status, date_enregistrement)
			values
				
				(@id_checking_medical, @id_test_medical, @prix_usd, @prix_fc, 1, @date_enregistrement);
go

create procedure supprimer_prix_test_medicaux
	@id_prix_test int
	as
		merge into t_test_medicaux
            using (@id_prix_test as x_id) as x_source
            on (x_source.x_id = t_prix_test_medicaux.id_prix_test)
            when matched then
                update set
			        active_status = 0;
go
----------------------ici se termine la logique de la table t_prix_test_medicaux--------------------------

create table t_departement_tests
(
	id_departement_test nvarchar(50),
	descriptions nvarchar(max),
	active_status bit,
	constraint pk_Departement_tests primary key (id_departement_test)
)
---------------------ici commence la logique de table t_departement_tests-----------------------------------
create procedure afficher_departement_tests
	as
		select top 50
			id_departement_test as 'Test departement Id.',
			descriptions as 'Descriptions'
		from t_Departement_tests
			order by id_departement_test desc
		where active_status = 1;
go

create procedure rechercher_id_departement_test	
	@id_departement_test
	as
		select top 20
	    	id_departement_test as 'Test departement Id.',
	    	descriptions as 'Descriptions',
			active_status as 'Active Status'
	from t_interpretations_resultats
		where
			id_departement_test like '%'+@id_departement_test+'%'
		order by id_departement_test;
go

create procedure enregistrer_id_departement_test
	@id_departement_test nvarchar(50),
	@descriptions	nvarchar(max)
	as
		merge into t_departement_tests	
			using (select @id_departement_test as x_id) as x_source
			on(x_source.x_id=t_Departement_tests.id_departement_test)
			when matched then
				update set
					descriptions=@descriptions
			when not matched then
				insert
					(descriptions, active_status)
				values
					(@descriptions, 1);
go

create procedure supprimer_departement_tests
	@id_departement_test int
	as
		merge into t_checking_medical
            using (@id_checking_medical as x_id) as x_source
            on (x_source.x_id = t_departement_tests.id_departement_test)
            when matched then
                update set
			        active_status = 0;
go

------------------------ici se termine la logique de la table t_Departement_tests----------------------------	
create table t_test_medicaux
(
	id_test_medical nvarchar(40),
	descriptions nvarchar(max),
	active_status bit,
	constraint pk_test_medicaux primary key (id_test_medical)
);
go
------------------------ici commence la logique de la table t_test_medicaux--------------------------
create procedure afficher_test_medicaux
	as
		select top 20
			id_test_medical as 'Medical Test Id.',
			descriptions as 'Descriptions'
		from t_test_medicaux
			order by id_test_medical desc
		where active_status = 1;
go

create procedure rechercher_id_test_medical
	@id_test_medical nvarchar(40),
	as
		select top 20
			id_test_medical as 'Medical Test Id.',
			descriptions as 'Descriptions',
			active_status as 'Active Status'
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
					(descriptions, active_status)
				values
					(@descriptions, 1);											 	
go

create procedure supprimer_test_medicaux
	@id_test_medical int
	as
		merge into t_test_medicaux
            using (@id_test_medical as x_id) as x_source
            on (x_source.x_id = t_test_medicaux.id_test_medical)
            when matched then
                update set
			        active_status = 0;
go
----------------------------ici se termine la logique de la table t_prix_test_medicaux--------------

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
    active_status bit,
    constraint pk_procurement primary key (procurement_id)
);

create table product (
    product_id int identity,
    designation nvarchar(max),
    qty_alert int,
	active_status bit,
    constraint pk_products primary key (product_id)
);

create table shape (
    shape_id int identity,
    designation nvarchar(max),
	active_status bit,
    constraint pk_shape primary key (shape_id)
);

create table category (
    category_id int identity,
    designation nvarchar(max),
	active_status bit,
    constraint pk_designation primary key (category_id)
);

create table container (
    container_id int identity,
    designation nvarchar(max),
	active_status bit,
    constraint pk_container primary key (container_id)
);

create table supplier (
    supplier_id int identity,
    names nvarchar(max),
    phone nvarchar(15),
    addresses nvarchar(max),
    email nvarchar(max),
	active_status bit,
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
	active_status bit,
    constraint pk_order_details primary key (order_details_id)
);

create table order (
    order_id int identity,
    order_date date,
    quantity int,
    total_quantity date,
    access_level nvarchar(50),
    comapny_id int,
	active_status bit,
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
        fabrication_date as 'Fabrication Date'
	from procurement
		order by procurement_id desc
	where active_status = 1;
go

create procedure afficher_product
	as 
	select top 20
		product_id as 'Product Id.',
        designation as 'Designation',
        qty_alert as 'Quantity Alert'
	from product
		order by product_id desc
	where active_status = 1;
go

create procedure afficher_shape
	as 
	select top 20
		shape_id as 'Shape Id.',
        designation as 'Designation'
	from shape
		order by shape_id desc
	where active_status = 1;
go

create procedure afficher_category
	as 
	select top 20
		category_id as 'Category Id.',
        designation as 'Designation'
	from category
		order by category_id desc
	where active_status = 1;
go

create procedure afficher_container
	as 
	select top 20
		container_id as 'Container Id.',
        designation as 'Designation'
	from container
		order by container_id desc
	where active_status = 1;
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
		order by supplier_id desc
	where active_status = 1;
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
		order by order_details_id desc
	where active_status = 1;
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
		order by order_details_id desc
	where active_status = 1;
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
    @active_status bit
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
                    fabrication_date = @fabrication_date
			when not matched then
				insert
					(procurement_id, procurement_date, consumption_limit_date, expiration_date, product_id, shape_id, category_id, container_id, quantity, supplier_id, total_quantity, access_level, company_id, purchase_unit_price, sale_unit_price, fabrication_date, active_status)
				values
					(@procurement_id, @procurement_date, @consumption_limit_date, @expiration_date, @product_id, @shape_id, @category_id, @container_id, @quantity, @supplier_id, @total_quantity, @access_level, @company_id, @purchase_unit_price, @sale_unit_price, @fabrication_date, 1);
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
					(product_id, designation, qty_alert, active_status)
				values
					(@product_id, @designation, @qty_alert, 1);
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
					(shape_id, designation, active_status)
				values
					(@shape_id, @designation, 1);
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
					(category_id, designation, active_status)
				values
					(@category_id, @designation, 1);
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
					(container_id, designation, active_status, active_status)
				values
					(@container_id, @designation, 1);
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
					(supplier_id, names, phone, addresses, email, active_status) 
				into
					(@supplier_id, @names, @phone, @addresses, @email, 1);
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
					(order_date, order_id, order_id, procurement_id, order_date, quantity, total_quantity, access_level, comapny_id, active_status)
				values
					(@order_date, @order_id, @order_id, @procurement_id, @order_date, @quantity, @total_quantity, @access_level, @comapny_id, 1);
go

create procedure enregistrer_order
	@order_id int,
	@order_date date,
	@quantity int,
	@total_quantity int,
	@access_level nvarchar(50),
	@comapny_id int
	as
		merge into order
			using (order_id as x_source) as x_source
			on (x_source.x_id = order.order_id)
			when matched then
				update set
					order_id = @order_id,
					order_date = @order_date,
					quantity = @quantity
					total_quantity = @total_quantity,
					access_level = @access_level,
					company_id = @company_id
			when not matched
				insert
					(order_id, order_date, quantity, total_quantity, access_level, company_id, active_status)
				values
					(@order_id, @order_date, @quantity, @total_quantity, @access_level, @company_id, 1);
go
				
----------------------- DELETE PROCEDURES -----------------------

create procedure supprimer_procurement
	@procurement_id int
	as
		merge into procurement
            using (@procurement_id as x_id) as x_source
            on (x_source.x_id = procurement.procurement_id)
            when matched then
                update set
			        active_status = 0;
go

create procedure supprimer_order_details
	@order_details_id int
	as
		merge into order_details
            using (@order_details_id as x_id) as x_source
            on (x_source.x_id = order_details.order_details_id)
            when matched then
                update set
			        active_status = 0;
go

create procedure supprimer_order
	@order_id int
	as
		merge into order
            using (@order_id as x_id) as x_source
            on (x_source.x_id = order.order_id)
            when matched then
                update set
			        active_status = 0;
go

create procedure supprimer_product
	@product_id int
	as
		merge into product
            using (@product_id as x_id) as x_source
            on (x_source.x_id = product.product_id)
            when matched then
                update set
			        active_status = 0;
go

create procedure supprimer_shape
	@shape_id int
	as
		merge into shape
            using (@shape_id as x_id) as x_source
            on (x_source.x_id = shape.shape)
            when matched then
                update set
			        active_status = 0;
go

create procedure supprimer_category
	@category_id int
	as
		merge into category
            using (@category_id as x_id) as x_source
            on (x_source.x_id = category.category_id)
            when matched then
                update set
			        active_status = 0;
go

create procedure supprimer_container
	@container_id int
	as
		merge into container
            using (@container_id as x_id) as x_source
            on (x_source.x_id = container.container_id)
            when matched then
                update set
			        active_status = 0;
go

create procedure supprimer_supplier
	@supplier_id int
	as
		merge into supplier
            using (@supplier_id as x_id) as x_source
            on (x_source.x_id = supplier.supplier_id)
            when matched then
                update set
			        active_status = 0;
go