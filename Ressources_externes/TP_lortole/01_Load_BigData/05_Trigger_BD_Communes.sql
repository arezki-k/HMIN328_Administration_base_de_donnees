create or replace trigger Alert_Region
	after delete or insert or update
	on Region for each row
	begin
	dbms_output.put_line('fin de operation');
	end ;
	/

	create or replace trigger Alert_Departement
		after delete or insert or update
		on Departement for each row
		begin
		dbms_output.put_line('fin de operation');
		end ;
		/
		create or replace trigger Alert_Commune
			after delete or insert or update
			on Commune for each row
			begin
			dbms_output.put_line('fin de operation');
			end ;
			/


---Creation d'un declencheur Ouvrable

create or replace procedure P_Ouvrable is
	begin
	if (to_char(sysdate,'DY')='SAT') or (to_char(sysdate,'DY')='SUN')
	then
	raise_application_error(-20010, 'Modification interdite le '||to_char(sysdate,'DAY') ) ;
	else
	dbms_output.put_line(to_char(sysdate,'DY') || '  Modification autorisee');
	end if ;
	end ;
	/

	create or replace trigger Ouvrable_Region
		before delete or insert or update on Region
		begin
		P_Ouvrable;
		end ;
		/

		create or replace trigger Ouvrable_Departement
			before delete or insert or update on Departement
			begin
			P_Ouvrable;
			end ;
			/

			create or replace trigger Ouvrable_Commune
				before delete or insert or update on Commune
				begin
				P_Ouvrable;
				end ;
				/

-- Creation d'un declencheur Verif pop

create or replace procedure Verif_Pop(val1 in number) is
	begin
	if ( val1 < 0 )
	then
	raise_application_error(-20022, val1 ||' une population ne peut etre inferieur à 0') ;
	else
	dbms_output.put_line(val1 || 'population superieur à 0');
	end if ;
	end ;
	/


	create or replace trigger Verif_Commune_pop_2010
		before insert or update of pop_2010 on Commune
		for each row
		begin
		Verif_Pop(:new.pop_2010);
		end ;
		/

-- Creation d'un declencheur Historique

DROP TABLE historique_Region
;
create table historique_Region (dateOperation date, typeOperation
	varchar(15), nomUser varchar(15), AnciennumRegion number,
	NouveauNumRegion number) ;
create or replace trigger monitor_hist_Region
	after insert or delete or update on Region for each row
	declare
	typeOp varchar(15);
	BEGIN
	if inserting then
	typeOp :=  'Insertion';
	elsif updating then
	typeOp := 'Modification';
	elsif deleting then
	typeOp := 'Suppression';
	end if ;
	insert into historique_Region values (sysdate, typeOp,
		user, :old.reg, :new.reg);
	end ;
	/



	DROP TABLE historique_Departement
	;
	create table historique_Departement (dateOperation date, typeOperation
		varchar(15), nomUser varchar(15), AnciennumDepartement number,
		NouveauNumDepartement number) ;
	create or replace trigger monitor_hist_Departemenent
		after insert or delete or update on Departement for each row
		declare
		typeOp varchar(15);
		BEGIN
		if inserting then
		typeOp :=  'Insertion';
		elsif updating then
		typeOp := 'Modification';
		elsif deleting then
		typeOp := 'Suppression';
		end if ;
		insert into historique_Departement values (sysdate, typeOp,
			user, :old.dep, :new.dep);
		end ;
		/

		DROP TABLE historique_Commune
		;
		create table historique_Commune (dateOperation date, typeOperation
			varchar(15), nomUser varchar(15), AnciennumCommune number,
			NouveauNumCommune number) ;
		create or replace trigger monitor_hist_Commune
			after insert or delete or update on Commune for each row
			declare
			typeOp varchar(15);
			BEGIN
			if inserting then
			typeOp :=  'Insertion';
			elsif updating then
			typeOp := 'Modification';
			elsif deleting then
			typeOp := 'Suppression';
			end if ;
			insert into historique_Commune values (sysdate, typeOp,
				user, :old.com, :new.com);
			end ;
			/


			--4


	create or replace procedure P_Cascade_Region_Dep(reg in varchar) is
	begin
	DELETE FROM Departement
	WHERE reg = reg;
	end;
	/

	create or replace trigger Trig_Cascade_Region_Dep
		before delete on Region
		for each row
		begin
		P_Cascade_Region_Dep(:new.reg);
		end ;
		/


/*
-- Creation de declencheurs Before D et After D

create or replace trigger Before_D
before insert on EMP for each row
begin
:new.nom := upper( :new.nom);
dbms_output.put_line('bravo vous venez d inserer le tuple '|| :new.nom) ;
end ;
/


create or replace trigger After_D
after insert on EMP for each row
begin
:new.nom := upper( :new.nom);
dbms_output.put_line('bravo vous venez d inserer le tuple '|| :new.nom) ;
end ;
/

-- Creation d'un declencheur Global update

create table log (
txt varchar2(20), date_maj date, user_maj varchar2(15) ) ;
create or replace trigger Global_update
before update on EMP
begin
insert into log values ('update trigger', sysdate, user) ;
end ;
/
update EMP set nom = nom || 't'
where substr(nom,1,1) = 'M' ;
-- un seul enregistrement dans log quel que soit le nombre de tuples modifies.
select * from log ;
drop table log ;



*/