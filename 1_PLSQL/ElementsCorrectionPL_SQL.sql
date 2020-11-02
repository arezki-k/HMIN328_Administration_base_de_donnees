set serveroutput on

create or replace trigger exo1
before insert or update on emp
for each row
begin
dbms_output.put_line('maj le '||to_char(sysdate,'DAY'));
end;
/

-- test insertion
insert into emp (num, nom, salaire) values (1,'Martin',2000);

create or replace trigger exo1
before insert or update on emp
for each row
begin
dbms_output.put_line('maj le '||to_char(sysdate,'DAY')||'  '||:new.nom);
end;
/



create or replace trigger exo1
before insert or update on emp
for each row
begin
if :new.salaire <0 or :new.salaire is null
then raise_application_error(-20001,'salaire positif et renseigne uniquement');
else 
dbms_output.put_line('salaire ok');
end if;
end;
/

insert into emp (num, nom, salaire) values (2,'Martin',-100);
insert into emp (num, nom, salaire) values (2,'Martin',null);


-- exemple utilisation curseur implicite

create or replace trigger exo2
before insert or update on emp
for each row
declare 
numD emp.n_dept%type;
begin
select n_dept into numD from dept where lieu = 'Rennes';
if :new.n_dept = numD
then 
if :new.salaire < 1000
then raise_application_error (-20001, 'pas assez');
end if;
end if;
end;
/

-- test erreur
insert into emp (num, nom, salaire, n_dept) values (2,'Martin',100,10);

-- test de possibilite erreur : trop de tuples correspondant a Rennes
insert into dept values (100,'conception','Rennes');



create table historique (dateOperation date, usager varchar(20), typeOperation varchar(20));

create or replace trigger exo4
before insert or update or delete on dept
for each row
begin
if inserting  then insert into historique values (sysdate, user,'insertion');
elsif deleting then insert into historique values (sysdate,user,'suppression');
else insert into historique values (sysdate, user, 'modification');
end if;
end;
/

insert into dept values (200,'certification', 'Montpellier');
update dept set lieu = 'Lunel' where n_dept = 200;
delete from dept where n_dept = 200;

select * from historique;


create or replace procedure JoursEtHeuresOuvrables
as
begin
if to_char(sysdate, 'DAY')='VENDREDI'
then raise_application_error(-20001,'rien ne se fait le vendredi');
end if ;
end ;
/

create or replace trigger ouvrable
before insert or update or delete on emp
for each row
begin
JoursEtHeuresOuvrables;
end;
/

insert into emp (num, nom) values (-1,'Titi');


-- drop trigger exo2;

create or replace trigger exo5
before delete or update on dept
for each row
begin
if deleting then delete from emp where n_dept = :old.n_dept;
elsif updating then update emp set n_dept = :new.n_dept where n_dept = :old.n_dept;
end if;
end ;
/

select num, nom, n_dept from emp where n_dept = 10;
update dept set n_dept = 110 where n_dept = 10;

delete from dept where n_dept = 110;

rollback;





DROP TABLE QuiSeConnecte;
CREATE TABLE QuiSeConnecte
(
c_user varchar2(60),
os_user varchar2(60),
ip_address varchar2(20),
c_date date
);





CREATE OR REPLACE TRIGGER logon_db
after logon ON DATABASE
declare
o_user QuiSeConnecte.os_user%type ;
i_address QuiSeConnecte.ip_address%type ;
session_user QuiSeConnecte.c_user%type ;

begin
select sys_context('USERENV','OS_USER') into o_user from dual ;
select sys_context('USERENV','SESSION_USER') into session_user from dual ;
select sys_context('USERENV','IP_ADDRESS') into i_address from dual ;
INSERT INTO QuiSeConnecte VALUES (session_user, o_user,i_address,sysdate);
commit;
end;
/

select c_user, os_user, ip_address, TO_CHAR(c_date,'YYYY-MM-DD HH24:MI:SS')
from quiseconnecte;



select trigger_name, owner from dba_triggers where owner like 'E20180010750';
select trigger_name, owner from dba_triggers where owner like 'E20180010750';

select trigger_name, owner from dba_triggers where owner like 'P00000009432';


drop trigger P00000009432.logon_db;


CREATE OR REPLACE PROCEDURE DELETE_ALL_TRIGGERS 
as
cursor curseur is select trigger_name from user_triggers;
begin
    FOR rec in curseur
    LOOP 
        EXECUTE IMMEDIATE 'DROP TRIGGER '||rec.trigger_name; 
      END LOOP;
end;
/

exec DELETE_ALL_TRIGGERS



CREATE OR REPLACE PROCEDURE AFFICHE_TABLES (owner_t in  varchar)
as
cursor curseur is select table_name, owner from all_tables where owner = owner_t;
begin
    FOR rec in curseur
    LOOP 
        DBMS_OUTPUT.PUT_LINE('-- '||rec.table_name||'  '||rec.owner); 
      END LOOP;
end;
/

exec AFFICHE_TABLES('E20180010750');

exec AFFICHE_TABLES('P00000009432');



CREATE OR REPLACE PROCEDURE AFFICHE_USERS 
as
cursor curseur is select username, user_id from dba_users;
begin
    FOR rec in curseur
    LOOP 
        DBMS_OUTPUT.PUT_LINE('-- '||rec.username||'  '||rec.user_id); 
      END LOOP;
end;
/


CREATE OR REPLACE PROCEDURE AFFICHE_CONNEXIONS 
as
cursor curseur is select sid, username, osuser from v$session where type ='USER';
begin
    FOR rec in curseur
    LOOP 
        DBMS_OUTPUT.PUT_LINE('-- '||rec.username||'  '||rec.osuser); 
      END LOOP;
end;
/

exec AFFICHE_CONNEXIONS



create or replace procedure p_list
is
cursor c is select table_name from user_tables;
begin
for t in c
loop
dbms_output.put_line(t.table_name);
end loop;
end;
/

exec p_list


-- execute immediate pour le drop

create or replace procedure t_supp
is
cursor c is select trigger_name from user_triggers;
begin
for t in c
loop
execute immediate 'drop trigger '||t.trigger_name;
dbms_output.put_line(t.trigger_name||'  supprime');
end loop;
exception
when others then dbms_output.put_line(sqlerrm);
end;
/

exec t_supp


create or replace procedure tab_supp (tabl_name varchar)
is
cursor c is select table_name from user_tables where table_name = upper(tabl_name);
begin
for t in c
loop
execute immediate 'drop table '||t.table_name||'  cascade constraints';
dbms_output.put_line(t.table_name||'  supprime');
end loop;
exception
when others then dbms_output.put_line(sqlerrm);
end;
/

exec tab_supp('quiseconnecte');


