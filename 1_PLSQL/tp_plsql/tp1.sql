ALTER table Dept add constraint Dept_pk primary key(n_dept);

ALTER table Emp  add constraint Emp_pk primary key(num);

/*nécessité d'ajouter le dep 100 pour que les clés étrangères collent à toutes les clés primaires
possibilité de supprimer aussi l'employé qui pose problème*/

insert into dept values (100, 'direction', 'autres');

alter table Emp add constraint Emp_ndept foreign key (n_dept) references Dept(n_dept) on delete cascade;

alter table Emp add constraint Emp_num foreign key (n_sup) references Emp(num) on delete cascade;
--I) TRIGGERS LMD
--1.création de TRIGGER qui verifie que le salaire est toujours positif
create or replace trigger verif_salaire 
after insert or update of salaire on emp
for each row
begin
if (:new.salaire <0)
then raise_application_error(-20010,'salaire ne peut pas etre négatif');
end if;
end;
/

--test d'insertion
INSERT INTO EMP VALUES('MARTINE',16710,'directeur',25717,'23/05/90',-20000,NULL,30);


--supprimer déclencheur
drop trigger verif_salaire;

--2.Trigger vérifiant salaire>1000 à rennes
CREATE OR REPLACE TRIGGER VERIF_SALAIRE_SUP_1000_RENNES
    after INSERT OR UPDATE OF salaire ON EMP
    FOR EACH ROW
    WHEN (NEW.N_DEPT = 10)
    BEGIN
    IF (:NEW.salaire < 1000)
        THEN raise_application_error(-20010,'SALAIRE INSUFFISANT');
    END IF;
    END;
    /
--test du trigger:
INSERT INTO EMP VALUES('GARDARIN',17155,'ingenieur',24533,'22/03/1985',400,NULL,10);
--3 trigger verifiant que la date du jour n'est pas un samedi ou un dimanche.
--procédure 
create or replace procedure jours_ouvrable is
BEGIN
IF (to_char(sysdate,'day') ='samedi') or (to_char(sysdate,'day')='dimanche') 
THEN
    raise_application_error(-20010, 'modification interdite le ' ||to_char(sysdate,'day'));
    end if;
end;
/




create or replace trigger verif_jour_ouvrable
after delete or insert or update on emp
BEGIN
jours_ouvrable;
END;
/

--Test
INSERT INTO EMP VALUES ('test',21831,'administratif', 16712,'10/09/08',1500,NULL,30);
--4- creation table historique et d'un trigger l'alimentant

--creation de la table
CREATE TABLE historique_dept (
    dateOperation VARCHAR(20),
    nomUsager VARCHAR(20),
    typeOperation varchar(20)
);
--creation du trigger:
CREATE or replace TRIGGER historique_dept
after insert or update or delete on dept for each ROW
DECLARE
typeOperation VARCHAR(20);
BEGIN
if inserting then
    typeOperation := 'insertion';
elsif updating then
    typeOperation := 'update';
elsif deleting then 
    typeOperation := 'delete';
end if ;
insert into historique_dept values ( sysdate, user,typeOperation);
end;
/
--test du trigger
insert into dept values(999, 'R&D','californie');
update dept set lieu='etranger' where n_dept=120;


-- --5-Vous construirez un trigger nommé cascade qui porte sur la table Dept et qui se charge à chaque
-- évènement de suppression ou de modification d’un département (n dept) dans Dept de suppri-
-- mer ou de modifier dans la table Emp, les tuples d’employés dépendants de ce département.
-- Pensez ensuite à annuler les effets des suppressions ou modifications par rollback sur la tran-
-- saction.

create or replace trigger cascade 
after delete or update on dept for each ROW
DECLARE
    olddept dept.N_DEPT%TYPE;
    newdept dept.N_DEPT%TYPE;
BEGIN
    olddept := :old.N_DEPT;
    newdept := :new.N_DEPT;
    if deleting THEN
        delete from Emp where N_DEPT = olddept;
    elsif updating THEN
        UPDATE Emp SET N_DEPT = newdept where N_DEPT = olddept;
    end if;
end;
/

--test
update dept set n_dept= 115 where n_dept = 120;
--II)- TRIGGERS LDD
-- Vous construirez un trigger qui se déclenche au niveau de votre schéma utilisateur et qui affiche
-- un message indiquant un changement du modèle à chaque ordre de création.

--TP2
--1-Vous exploiterez certaines fonctionnalités (EXECUTE IMMEDIATE) du langage SQL
--dit dyna-mique pour supprimer tous les triggers définis jusqu’alors, à l’aide d’une procédure adaptée.

create or replace PROCEDURE supprimerTousTrigger IS
CURSOR trigger_cursor IS SELECT trigger_name from user_triggers;
BEGIN
FOR t in trigger_cursor loop
    EXECUTE IMMEDIATE 'drop trigger ' || t.trigger_name;
END loop;
end;
/    


select object_name from user_procedures;
--permet d'afficher le noms de toutes les procédures de l'utilisateurs;

--3-Curseurs procedures et fonctions.
--3.1 procedure empmoyeDuDepartement

create or replace PROCEDURE employesdudepartement (departement in number, res out varchar(1000))is
DECLARE
    CURSOR dept_cursor is SELECT nom from emp where n_dept = departement;
    res = dept_cursor.nom;
BEGIN
    dbms_output.put_line(res);
end;
/

