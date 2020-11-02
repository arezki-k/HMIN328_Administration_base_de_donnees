prompt Donner les espaces mémoires utilisateur, triés du plus petit conso. au plus grand

select owner,  sum(bytes)/1024/1024 as usedSpace from dba_segments where tablespace_name ='USERS'
group by owner order by 2;

-- variante tous tablespaces

select owner, tablespace_name,  sum(bytes)/1024/1024 as usedSpace from dba_segments
group by owner, tablespace_name order by 3;


-- 2 le plus gros consommateur

select owner,  sum(bytes)/1024/1024 as usedSpace from dba_segments 
where tablespace_name ='USERS'
group by owner having sum(bytes) >=ALL (select sum(bytes) 
from dba_segments where tablespace_name ='USERS' group by owner);

-- max(sum(bytes)) ecriture non conforme au standard SQL
 
select owner,  sum(bytes)/1024/1024 as usedSpace from dba_segments 
where tablespace_name ='USERS'
group by owner having sum(bytes) = (select max(sum(bytes)) 
from dba_segments where tablespace_name ='USERS' group by owner);


3 -- utiliser segment_type de dba_segments

select owner, count(*) from dba_segments where segment_type ='INDEX'
group by owner order by 2 asc; 

select owner, count(*) from dba_segments where segment_type ='INDEX'
and tablespace_name ='USERS'
group by owner order by 2 asc; 


select owner, count(*) from dba_segments where segment_type ='INDEX'
and tablespace_name ='USERS'
group by owner having count(*) = (select max(count(*)) from dba_segments 
where segment_type ='INDEX' and tablespace_name ='USERS' group by owner);

4-- Qui n'a pas créé d’objets dans son schéma utilisateur depuis plus d’un an (dba objects)

-- difference
select owner from dba_objects
minus
select owner from dba_objects where created >= '12-OCT-2017';

-- test de non appartenance
select distinct owner from dba_objects where owner not in 
(select owner from dba_objects where created >= '12-OCT-2017');


-- test de vacuité
select distinct owner from dba_objects d1 where not exists 
(select * from dba_objects d2 where created >= '12-OCT-2017' and d1.owner = d2.owner);


5-- 
select distinct owner from dba_objects d1 where not exists 
(select * from dba_objects d2 where last_ddl_time >= '12-OCT-2017' and d1.owner = d2.owner);

6-- 
select distinct owner from dba_segments where tablespace_name ='SYSTEM';

select distinct owner from dba_segments where tablespace_name ='SYSAUX';

select distinct owner from dba_segments where tablespace_name ='UNDOTBS1';

7--
select username, count(*) from v$session where type ='USER' 
and username is not null group by username having count(*) > 1;

8--
select username, s.sid from v$session s, v$lock l where s.sid = l.sid and block = 1; 


9--
select sql_id, substr(sql_text,1,40), cpu_time/1000000, disk_reads, buffer_gets from v$sql
where parsing_schema_name = 'IMOUGENOT' order by 3 ;

-- variante
col parsing_schema_name 15
select parsing_schema_name, sql_id, substr(sql_text,1,40), cpu_time/1000000, disk_reads, 
buffer_gets from v$sql where parsing_schema_name <> 'SYS'
order by 3 ;

10--


select sql_id, substr(sql_text,1,20), executions as rejouees, cpu_time/1000000, disk_reads, buffer_gets from v$sql
where parsing_schema_name = 'IMOUGENOT' and executions > 2 order by 3 ;


-- variable liée

variable nom_e varchar2(20)
exec :nom_e :='CODD'

select num, fonction from emp where nom = :nom_e;

exec :nom_e :='BALIN'

select num, fonction from emp where nom = :nom_e;


exec :nom_e :='DELOBEL'

select num, fonction from emp where nom = :nom_e;

exec :nom_e :='BARA'

select num, fonction from emp where nom = :nom_e;

-- 11 objets invalides pouvant entrainer des lenteurs au niveau du dictionary cache
select object_name, owner from dba_objects where status ='INVALID';

-- 12 et 13 privileges utilisateurs et système
-- privileges utilisateur
select grantee, grantor, owner, table_name, privilege from user_tab_privs;

-- privileges systeme

select username, privilege from user_sys_privs;

-- 14
Quels sont les rôles attribués (dba_roles et dba_sys_privs)

 select distinct username, granted_role from user_role_privs;

--- 15 a faire

16-- objet de quel utilisateur

-- correction partielle
select objd, count(block#), object_name, owner from v$bh, dba_objects
where objd = object_id and owner not in ('SYS', 'SYSMAN', 'XDB') group by objd, object_name, owner order by 2;

-- 17 a faire

-- 18 a faire


 










