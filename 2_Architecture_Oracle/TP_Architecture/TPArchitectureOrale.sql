show ALL;
set linesize 200;
set pagesize 50;


--1.consultation des vues dynamiques:
select name from v$fixed_table where name like 'V$%';

--L'ordre SQL donn ́e ci-dessous permet de lister l'ensemble des vues statiques
SELECT table_name,comments
FROM dictionaryWHERE table_name like 'DBA_%'
ORDER BY table_name;

--1.1 Consultation d'ordres generales:
/*1. consulter la vue portant sur l'instance (v$instance) et r ́epondre `a 
des interrogations telles que :quel est le nom de l'hˆote sur 
lequel tourne l'instance, et depuis quand l'instance est d ́emarr ́ee,*/
desc v$instance;
select host_name,STARTUP_TIME from v$instance;
select * from v$instance;
rlwrap sqlplus E20160010237/ipsmaster2019@oracle.etu.umontpellier.fr:1523/pmaster

/*2. consulter la vue portant sur la base de donn ́ees (v$database) et r ́epondre `a des interrogationstelles que : 
quel est le nom de la base et exploite t'elle le mode archive,*/

desc v$database;
SELECT name from v$database;
select name,ARCHIVELOG_COMPRESSION from v$database;


/*3. consulter la vue (v$option) portant sur les fonctionnalit ́es du serveur de donn ́ees et r ́epondre `ades 
interrogations telles que : de quelles options disposons-nous?*/
desc v$option;
select * from v$option;

/*4. consulter la vue (v$version) portant sur la version du SGBD Oracle sous-jacent*/
desc v$version;
select * from v$version;



/*5. consulter l'attribut server de la vue v$session pour connaˆıtre l'architecture client-serveur retenuepour 
servir les connexions utilisateurs (architecture d ́edi ́ee ou partag ́ee)*/
desc v$session;
SELECT server from v$session;rlwrap sqlplus E20160010237/ipsmaster2019@oracle.etu.umontpellier.fr:1523/pmaster
 --1.2 tructures m ́emoire et processus de tˆaches de fond
 /*. consulter les vues portant sur la m ́emoire SGA (v$sga, v$sgainfo, v$sgastat 
 ou show SGA) etr ́epondrrlwrap sqlplus E20160010237/ipsmaster2019@oracle.etu.umontpellier.fr:1523/pmaster tampon de journalisation (bufferredo) ? 
 Exploiter aussi une commande de type show parameter sharedpoolsize1
*/

desc v$sga;
desc v$sgastat;rlwrap sqlplus E20160010237/ipsmaster2019@oracle.etu.umontpellier.fr:1523/pmaster
select * from v$sga;
select name, bytes/1024/1024 as Mo from v$sgainfo;

/*
NAME                        rlwrap sqlplus E20160010237/ipsmaster2019@oracle.etu.umontpellier.fr:1523/pmaster          BYTES RES     CON_ID
-------------------------------- ---------- --- ----------
Fixed SGA Size                      8797928 No           0
Redo Buffers                        7979008 No           0
Buffer Cache Size                 889192448 Yes          0
In-Memory Area Size                       0 No           0
Shared Pool Size                  419430400 Yes          0
Large Pool Size                    33554432 Yes          0
Java Pool Size                     16777216 Yes          0
Streams Pool Size                  33554432 Yes          0
Shared IO Pool Size         rlwrap sqlplus E20160010237/ipsmaster2019@oracle.etu.umontpellier.fr:1523/pmaster       67108864 Yes          0
Data Transfer Cache Size                  0 Yes          0
Granule Size                       16777216 No           0
Maximum SGA Size                 3221225472 No           0
Startup overhead in Shared Pool   200813752 No           0
Free SGA Memory Available        1811939328              0

14 lignes selectionnees.
*/

show parameter shared_pool_size;
show parameter;

--2. Pour aller plus dans le d ́etail, vous pouvez consulter la vue v$sgastat 
select * from v$sgastat;
--3.nterroger les vues v$sql, v$sqlarea, v$sqltext qui sontassoci ́ees `a la ”library cache” 
--(sharedpool) et identifiez les informations contenues dans la ”library cache” et donc son rˆole
desc v$sql;
desc v$sqlarea;
desc v$sqltext;
select 'library cache' from v$sql;
select * from v$sql where 'library cache'='library cache';

--4.une requˆete vous est donn ́ee pour identifier les processus d'arri`ere-plan 
--interagissant avec lesstructures m ́emoire et les fichiers de donn ́ees
select p.pid, bg.name, bg.description, p.program 
from v$bgprocess bg, v$process p
where bg.paddr = p.addr order by p.pid;

--5.avoir la connaissance de divers param`etres portant sur l'instance : 
--select name, value fromv$parameter. Par exemple, trouver la taille 
--du bloc de donn ́ees qui va ˆetre l'unit ́e d' ́echangemont ́ee en m ́emoire vive.
--rlwrap sqlplus E20160010237/ipsmaster2019@oracle.etu.umontpellier.fr:1523/pmaster
desc v$parameter;
select name,value from v$parameter where value='TRUE';

--1.3 Lien entre les structures logique et physique
--1. consulter les tablespaces d ́efinis (dbatablespaces)
desc dba_tablespaces;
select tablespace_name from dba_tablespaces;

--2. consulter l'emplacement des fichiers de donn ́ees (v$datafile)
desc v$datafile;
select NAME, ENABLED from v$datafile;

--3. consulter l'emplacement des fichiers journaux (v$logfile)
desc v$logfile;
select * from v$logfile;

--4. consulter l'emplacement des fichiers de contrˆole (v$controlfile) 
desc v$controlfile;
select * from v$controlfile;
select name from v$controlfile;

--5. Faire le lien entre espace de table et fichier de donnees : 
--select tablespacename, filename fromdbadatafiles. 
--Combien de fichiers sont asservis `a chaque tablespace? 
desc dba_data_files;
select file_name, tablespace_name, bytes/1024/1024 as MO from dba_data_files;

--1.4- Tampon de donn ́ees ”data buffer cache”
select file#, block#, class#, dirty, objd, object_name, owner from v$bh, dba_objects 
where dirty = 'Y' and objd = object_id;

--=> expliquer le résulatat obtenue:

--lister les blocs de données nous appartenant se situant en mémoire cache.
select object_name, object_id from dba_objects, v$bh 
where object_id=objd and owner='E20160010237';


--1.5-M ́emoire ”LibraryCache

--tracer et evaluer les dernieres requetes
select to_char(logon_time, 'DD/MM/YYYY HH24:MI:SS') , 
username, program, sql_text from v$session , v$sqlarea where 
v$session.sql_address = v$sqlarea.address order by username, program;


select sql_id, disk_reads from v$sql where rownum <20 order by disk_reads desc;

select r.sql_id, disk_reads, elapsed_time, username, osuser from v$sql r, 
v$session s where s.sql_id = r.sql_id and type='USER';

select parsing_schema_name, substr(sql_text,1,150) from
v$sqlarea where parsing_schema_name ='E20160010106';

--1.6-Exploiter les vues usertables et dbatables
desc user_tables;
desc dba_tables;

--verifier que toutes les tables sont situées dans la meme tablespace:
select TABLESPACE_NAME , table_name from user_tables;


--combien de bloc de données sont utilisés pour stocker les données de chaqu'une des tables:
select TABLESPACE_NAME , table_name, blocks from user_tables;
select count(blocks) from user_tables;
-- => 18 blocks sont utilisés pour toutes les tables utilisateur.

--rafraichir le scheme d'une table
analyze table emp compute STATISTICS;
--rafraichir le scheme de toutes les tables:
exec dbms_stats.gather_schema_stats('E20160010237');

--1.6.2- créer table test:
create table test(num varchar(3), commentaire varchar(97));

create or replace procedure remplissage (compteur number) is
i number;
comme char(97);
begin
comme := 'cot_';
for i in 0 .. compteur
loop
comme := dbms_random.value || i ;
insert into test values (i,comme);
end loop;
end;
/

exec remplissage(999)



--
select table_name, blocks, empty_blocks from user_tables where table_name = 'TEST';
select NUM_ROWS, table_name, blocks, empty_blocks, avg_row_len from user_tables;

--1.6.3: 
/*SQL> create table test(num varchar(3), commentaire varchar(97));

Table creee.

SQL> analyze table test compute statistics;

Table analysee.
*/

/*
Est-ce que la longueur des tuples de cette table est variable? 
Relever le nombre de blocs utilis ́es,allou ́es mais inutilises apres:
*/
--la creation de la table
select NUM_ROWS, table_name, blocks, empty_blocks, avg_row_len from user_tables where table_name = 'TEST';


/*
SQL> select NUM_ROWS, table_name, blocks, empty_blocks, avg_row_len from user_tables where table_name = 'TEST';

  NUM_ROWS TABLE_NAME                                                                                                                           BLOCKS EMPTY_BLOCKS AVG_ROW_LEN
---------- -------------------------------------------------------------------------------------------------------------------------------- ---------- ------------ -----------
         0 TEST                                                                                                                                      0            0           0

*/

--insertion de 50 lignes:
exec remplissage(50);
analyze table test compute STATISTICS;

--resultats:
/*
  NUM_ROWS TABLE_NAME                                                                                                                           BLOCKS EMPTY_BLOCKS AVG_ROW_LEN
---------- -------------------------------------------------------------------------------------------------------------------------------- ---------- ------------ -----------
        51 TEST                                                                                                                                      5            3         104
*/
--insertiond de 100 lignes sup:
exec remplissage(100);
analyze table test compute STATISTICS;
/*
  NUM_ROWS TABLE_NAME                                                                                                                           BLOCKS EMPTY_BLOCKS AVG_ROW_LEN
---------- -------------------------------------------------------------------------------------------------------------------------------- ---------- ------------ -----------
       152 TEST                                                                                                                                      5            3         104

*/

--insertion de 100 lignes sup:
 exec remplissage(100);
analyze table test compute STATISTICS;

/*
  NUM_ROWS TABLE_NAME                                                                                                                           BLOCKS EMPTY_BLOCKS AVG_ROW_LEN
---------- -------------------------------------------------------------------------------------------------------------------------------- ---------- ------------ -----------
       253 TEST                                                                                                                                      5            3         104
*/

