
create or replace package packageControle
function blocksNumberInDataCache return integer ;
function blocksNumberPerUser (username varchar) return integer ;
function blocksNumberPerObject (objectname varchar, username varchar) return integer; 
procedure mostSignificantUser (blocks# out integer, username out varchar) ;

end packageControle;
/
--fonction1 
create or replace package body packageControle 
as

function blocksNumberInDataCache
return number
is
begin 
declare 
res number;
begin 
select count(BLOCK#) into res from v$bh;
return res;
end;
end;
--fonction2
create or replace function blocksNumberPerUser(username in varchar)
return number
is
begin
declare 
res number;
Cursor c is
select count(BLOCK#) from dba_objects, v$bh where OBJD=OBJECT_ID and  dba_objects.OWNER= username;
begin
open c;
fetch c into res;
return res;
end;
end;
--fonction3
create or replace function blocksNumberPerObject(username in varchar, objectname in varchar)
return number
is
begin
declare 
res number;
Cursor c is
select count(BLOCK#) from dba_objects, v$bh where OBJD=OBJECT_ID and  dba_objects.OWNER= username and dba_objects.OBJECT_NAME=objectname;
begin
open c;
fetch c into res;
return res;
end;
end;
/

end packageControle;
/
--question2
--la requete affiche l'utilisateur qui a plus de block dans la bd

--partie3
set linesize 200 --200 caractéres affichés sur une ligne physique
col parsing_schema_name for a20 --c'est la taille de la colonne(20 caractéres)


--derniere question
select USERNAME, last_login from dba_users  where  USERNAME  IN (select parsing_schema_name from v$sqlarea);

