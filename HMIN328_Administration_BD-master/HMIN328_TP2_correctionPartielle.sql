--Q1 trigger pour debuter
create or replace trigger pop_2010_positive
before insert or update of pop_2010 on Commune
for each row
begin
if (:new.pop_2010 < 0)
then raise_application_error(-20100,'Pb pour : '||:new.pop_2010||' valeur positive attendue');
end if;
end; 
/


--Q2 trigger dates ouvrables
create or replace trigger ouvrable
after insert or delete or update on Commune for each row 
begin 
if (to_char(sysdate,'DAY')='JEUDI') or  (to_char(sysdate,'DAY')='VENDREDI')
then raise_application_error(-20001,to_char(sysdate,'DAY')||' jour non ouvrable');
end if;
end;
/

prompt reecriture avec appel procedure sans arguments
prompt avec test sur les heures ouvrables
CREATE OR REPLACE PROCEDURE securite_dml
IS
BEGIN
  IF TO_CHAR (SYSDATE, 'HH24:MI') NOT BETWEEN '08:00' AND '18:00'
        OR TO_CHAR (SYSDATE, 'DAY') IN ('MERCREDI', 'VENDREDI') THEN
	RAISE_APPLICATION_ERROR (-20205, 
		'vous ne pouvez faire de modification que lors des heures ouvrables');
ELSE DBMS_OUTPUT.PUT_LINE('ecriture autorisee les '||to_char(sysdate,'DAY'));
  END IF;
END;
/

CREATE OR REPLACE TRIGGER ouvrable
  BEFORE INSERT OR UPDATE OR DELETE ON Commune
BEGIN
  securite_dml;
END;
/

--Q3  trigger sur le monitoring

drop table historique;
create table historique (dateOperation date, typeOperation varchar(15), nomUser varchar(15), AnciennumEmploye number, NouveauNumEmploye number);



create or replace trigger monitor_historique
after insert or delete or update on employe for each row
declare
typeOp        varchar(15);
BEGIN
    if inserting then
        typeOp := 'Insertion';
    elsif updating then
        typeOp := 'Modification';
    elsif deleting then
        typeOp := 'Suppression';
    end if;
insert into historique values (sysdate, typeOp, user, :old.num, :new.num);
end;
/

--Q4 trigger cascade 
prompt trigger sur les delete/ update en cascade

create or replace trigger cascade
before delete or update of nom_f on fonction
for each row
begin
if deleting then
delete from employe where fonction=:old.nom_f;
elsif updating then 
update employe set fonction=:new.nom_f where fonction=:old.nom_f;
end if;
end;
/


 
