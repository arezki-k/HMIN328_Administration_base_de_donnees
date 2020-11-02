/*
1.4
Mémoire ”LibraryCache”
Tous les ordres SQL (mais pas que) transitent par la m ́emoire ”LibraryCache”. Vous exploiterez
les vues aff ́erentes `
a cette zone m ́emoire : v$sqlarea, v$sql et v$sql plan pour tracer et  ́evaluer les
derni`eres requˆetes trait ́ees par le syst`eme. Diff ́erents exemples de requˆete (allant dans ce sens) sont
donn ́es
*/


select username ,to_char(logon_time, 'DD/MM/YYYY HH24:MI:SS') as log_time ,
, program, sql_text
from v$session , v$sqlarea
where v$session.sql_address = v$sqlarea.address
order by username, program
;

/*

LOG_TIME	    USERNAME			   PROGRAM
------------------- ------------------------------ ------------------------------------------------
SQL_TEXT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
25/11/2016 13:53:18 JMUNOZAVENDA		   sqlplus@s3 (TNS V1-V3)
SELECT COUNT(*) FROM commune

27/11/2016 17:15:00 LORTOLE			   sqlplus@x2go1 (TNS V1-V3)
select to_char(logon_time, 'DD/MM/YYYY HH24:MI:SS') as log_time , username, program, sql_text from v$session , v$sqlarea where v$session.sql_address = v$sqlarea.address order by username, program

27/11/2016 16:53:49 MMAIGA			   sqlplus@x2go1 (TNS V1-V3)
 explain plan for SELECT NOM_COM,latitude,longitude FROM COMMUNE     WHERE COMMUNE.DEP IN (SELECT DEP FROM DEPARTEMENT WHERE NOM_DEP ='HERAULT' OR NOM_DEP ='GARD')

*/


select sql_id, disk_reads
from v$sql
where rownum <20
order by disk_reads desc
;

/*

SQL_ID	      DISK_READS
------------- ----------
afm869hqqn071	      57
7k43r6dgpc05d	      51
57pfs5p8xc07w	      35
afm869hqqn071	      16
afm869hqqn071	       7
57pfs5p8xc07w	       4
57pfs5p8xc07w	       3
5m6mu5pd9w028	       1
57pfs5p8xc07w	       0
57pfs5p8xc07w	       0
57pfs5p8xc07w	       0

SQL_ID	      DISK_READS
------------- ----------
57pfs5p8xc07w	       0
57pfs5p8xc07w	       0
57pfs5p8xc07w	       0
57pfs5p8xc07w	       0
8z9kxmpvdc06p	       0
1fkh93md0802n	       0
57pfs5p8xc07w	       0
1anz5txss402h	       0

19 rows selected.

*/


select r.sql_id, disk_reads, elapsed_time, username
from v$sql r, v$session s
where s.sql_id = r.sql_id and type='USER'
;

/*

SQL_ID	      DISK_READS ELAPSED_TIME USERNAME
------------- ---------- ------------ ------------------------------
2y55u8k9msfqc	     166       160259 JMUNOZAVENDA
gtqug0ky3f2wy	       0	 5637 LORTOLE


*/

select distinct(parsing_schema_name)
from v$sqlarea
where parsing_schema_name like  'L%' ;

/*

PARSING_SCHEMA_NAME
------------------------------
LORTOLE
LLOAS

*/
select parsing_schema_name, substr(sql_text,1,20) from v$sqlarea where
parsing_schema_name ='IMOUGENOT'
;




/*

PARSING_SCHEMA_NAME	       SUBSTR(SQL_TEXT,1,20
------------------------------ --------------------
IMOUGENOT		       SELECT PT.VALUE FROM
IMOUGENOT		       SELECT STATISTIC# S,
IMOUGENOT		       select column_name,
IMOUGENOT		       SELECT USERENV('SESS
IMOUGENOT		       explain plan for sel
IMOUGENOT		       explain plan for sel
IMOUGENOT		       create index idx_dep
IMOUGENOT		       DELETE FROM PLAN_TAB
IMOUGENOT		       explain plan for sel
IMOUGENOT		       SELECT DISTINCT SID
IMOUGENOT		       SELECT /*+ opt_param

11 rows selected.


*/

select parsing_schema_name, substr(sql_text,1,20)
from v$sqlarea
where parsing_schema_name =  'LORTOLE';

/*
PARSING_SCHEMA_NAME	       SUBSTR(SQL_TEXT,1,20
------------------------------ --------------------
LORTOLE 		       SELECT NOM_COM,NOM_D
LORTOLE 		       SELECT SQL_FULLTEXT,
LORTOLE 		       select parsing_schem
LORTOLE 		       select parsing_schem
LORTOLE 		       SELECT FIRST_LOAD_TI
LORTOLE 		       select parsing_schem
LORTOLE 		       SELECT /*+ opt_param
LORTOLE 		       select to_char(logon
LORTOLE 		       select username , to
LORTOLE 		       select sql_id, disk_
LORTOLE 		       select parsing_schem

PARSING_SCHEMA_NAME	       SUBSTR(SQL_TEXT,1,20
------------------------------ --------------------
LORTOLE 		       select Distinct(pars
LORTOLE 		       insert into plan_tab
LORTOLE 		       select sid from v$se
LORTOLE 		       select parsing_schem
LORTOLE 		       SELECT B.SID FROM V$
LORTOLE 		       select /*+ opt_param
LORTOLE 		       declare nom_user_var
LORTOLE 		       declare nom_user_var
LORTOLE 		       select to_char(logon
LORTOLE 		       SELECT B.CLIENT_IDEN
LORTOLE 		       SELECT SQL_FULLTEXT,

PARSING_SCHEMA_NAME	       SUBSTR(SQL_TEXT,1,20
------------------------------ --------------------
LORTOLE 		       select parsing_schem

23 rows selected.
*/

set linesize 300 ;


select sql_FullText,(cpu_time/100000) "Cpu Time (s)"
, (elapsed_time/1000000) "Elapsed time (s)"
, fetches,buffer_gets,disk_reads,executions
FROM v$sqlarea
WHERE
Parsing_Schema_Name ='IMOUGENOT'
AND rownum <50
order by 3 desc
;

/*

SQL_FULLTEXT									 Cpu Time (s) Elapsed time (s)	  FETCHES BUFFER_GETS DISK_READS EXECUTIONS
-------------------------------------------------------------------------------- ------------ ---------------- ---------- ----------- ---------- ----------
create index idx_dep on commune (dep)						     128.3005	     12.923413		0     2103032	    2079	  2
SELECT PT.VALUE FROM SYS.V_$SESSTAT PT WHERE PT.SID=:1 AND PT.STATISTIC# IN (8,6       .63986	       .111534	      376	   69	       1	188
select column_name, num_distinct, high_value from dba_tab_col_statistics where t       .47993	       .049331		4	   78	       0	  2
SELECT /*+ opt_param('parallel_execution_enabled','false') /			       .45997	       .042515	      409	 1334	       5	 95


SELECT DISTINCT SID FROM V$MYSTAT						       .20996	       .033531	       12	  113	       5	 12
DELETE FROM PLAN_TABLE WHERE STATEMENT_ID=:1					       .11999	       .031435		0	  988	       2	166
SELECT STATISTIC# S, NAME FROM SYS.V_$STATNAME WHERE NAME IN ('recursive calls',       .04999	       .010356	       24	   63	       0	 12
explain plan for select /*+ use_merge(commune departement)/ nom_com, nom_dep fr       .03999	       .004208		0	   14	       0	  1
explain plan for select /*+ ordered use_nl(commune departement) /  nom_com, nom	  .02	       .003235		0	   14	       0	  1

SQL_FULLTEXT									 Cpu Time (s) Elapsed time (s)	  FETCHES BUFFER_GETS DISK_READS EXECUTIONS
-------------------------------------------------------------------------------- ------------ ---------------- ---------- ----------- ---------- ----------
explain plan for select  nom_com, nom_dep from commune, departement where commun       .02999	       .002928		0	    5	       0	  1
SELECT USERENV('SESSIONID') FROM DUAL							  .01	       .002903	       12	    6	       0	 12

11 rows selected.


*/


select sql_FullText,(cpu_time/100000) "Cpu Time (s)"
, (elapsed_time/1000000) "Elapsed time (s)"
, fetches,buffer_gets,disk_reads,executions
FROM v$sqlarea
WHERE
Parsing_Schema_Name ='LORTOLE'
AND rownum <50
order by 3 desc
;

/*

SQL_FULLTEXT									 Cpu Time (s) Elapsed time (s)	  FETCHES BUFFER_GETS DISK_READS EXECUTIONS
-------------------------------------------------------------------------------- ------------ ---------------- ---------- ----------- ---------- ----------
SELECT B.CLIENT_IDENTIFIER, B.SID, B.USERNAME, B.STATUS, B.TYPE, B.SERVER FROM V    336.38872	     33.507184	   244538	   14	       0     244538
select to_char(logon_time, 'DD/MM/YYYY HH24:MI:SS') as log_time , username, prog     18.72715	      1.895982		6	   82	       3	  3
SELECT SQL_FULLTEXT,CPU_TIME/100000,(ELAPSED_TIME/1000000),FETCHES,BUFFER_GETS,E     17.10739	       1.72327		4	    6	       0	  4
declare 									       9.1786	       .929644		0	    6	       0	  2
nom_user_var varchar2(100);
query_var varchar2(1000);
cpu_var number;
el

SELECT SQL_FULLTEXT,(CPU_TIME/100000) "Cpu Time (s)",(ELAPSED_TIME/1000000) "Ela      8.23875	       .843401	       36	    2	       0	  5
declare 									      8.01877		.80629		0	    0	       0	  2

SQL_FULLTEXT									 Cpu Time (s) Elapsed time (s)	  FETCHES BUFFER_GETS DISK_READS EXECUTIONS
-------------------------------------------------------------------------------- ------------ ---------------- ---------- ----------- ---------- ----------
nom_user_var varchar2(100);
query_var varchar2(1000);
cpu_var number;
el

select to_char(logon_time, 'DD/MM/YYYY HH24:MI:SS') as log_time ,		      5.59916	       .563914		2	    4	       0	  1
username, prog

select username ,								       5.2292	       .524333		2	    4	       0	  1
to_char(logon_time, 'DD/MM/YYYY HH24:MI:SS') as log_time ,
pro

SQL_FULLTEXT									 Cpu Time (s) Elapsed time (s)	  FETCHES BUFFER_GETS DISK_READS EXECUTIONS
-------------------------------------------------------------------------------- ------------ ---------------- ---------- ----------- ---------- ----------

SELECT FIRST_LOAD_TIME,V$SQL.SQL_ID, DISK_READS, ELAPSED_TIME,CPU_TIME,EXECUTION      2.44964	       .250385		4	   57	       1	  4
select parsing_schema_name, substr(sql_text,1,20) from v$sqlarea where parsing_s      1.55973	       .223213	      138	    2	       0	  2
select parsing_schema_name, substr(sql_text,1,20) from v$sqlarea		       .28997	       .123077	      557	    2	       0	  2
select Distinct(parsing_schema_name)						      1.04984	       .109587		2	    2	       0	  1
from v$sqlarea
where parsing_schema_name li

select parsing_schema_name, substr(sql_text,1,20)				      1.04984	       .106976		3	    2	       0	  1
from v$sqlarea
where parsing_s

SQL_FULLTEXT									 Cpu Time (s) Elapsed time (s)	  FETCHES BUFFER_GETS DISK_READS EXECUTIONS
-------------------------------------------------------------------------------- ------------ ---------------- ---------- ----------- ---------- ----------

select parsing_schema_name, substr(sql_text,1,20) from v$sqlarea where		      1.01985	       .103812		1	    2	       0	  1
parsing_s

select parsing_schema_name							       .94984	       .099125		3	    2	       0	  1
from v$sqlarea
where parsing_schema_name like	'L%'

SELECT /*+ opt_param('parallel_execution_enabled','false') /			       .87983	       .077652	      954	 2225	       0	141



SQL_FULLTEXT									 Cpu Time (s) Elapsed time (s)	  FETCHES BUFFER_GETS DISK_READS EXECUTIONS
-------------------------------------------------------------------------------- ------------ ---------------- ---------- ----------- ---------- ----------
SELECT NOM_COM,NOM_DEP,NOM_REG FROM COMMUNE, DEPARTEMENT,REGION 		       .52994	       .075014	      738	 4902	    2073	  2
WHERE	COMMUNE.

select parsing_schema_name, substr(sql_text,1,20) from v$sqlarea		       .24996	       .055829	      227	    2	       0	  1
insert into plan_table (statement_id, timestamp, operation, options,object_node,       .34994	       .035478		0	  615	       0	287
select /*+ opt_param('parallel_execution_enabled',				       .19998	       .021506		0	  205	       0	171


select sql_id, disk_reads from v$sql where rownum <20 order by disk_reads desc	       .07999	       .007971		3	   40	       1	  1
SELECT B.SID FROM V$SESSION B WHERE B.USERNAME = 'LORTOLE'				  .05	       .006459		9	    2	       0	  8
select sid from v$session								  .02	       .003121		7	    2	       0	  2

SQL_FULLTEXT									 Cpu Time (s) Elapsed time (s)	  FETCHES BUFFER_GETS DISK_READS EXECUTIONS
-------------------------------------------------------------------------------- ------------ ---------------- ---------- ----------- ---------- ----------
select sql_FullText,(cpu_time/100000) "Cpu Time (s)"				       .02999	       .003051		0	    2	       0	  1
, (elapsed_time/1000000) "E


24 rows selected.


*/





/*

Vous construirez dif ́erentes fonctions permettant de disposer d’informations sur les activit ́es d’un
usager en particulier et sur les requˆetes les plus coˆ
uteuses. Vous pouvez aussi tester tout l’int ́erˆet des
variables li ́ees.

*/
CREATE OR REPLACE PACKAGE Pkg_Archi_Oracle
IS
  -- Procédures publiques
    procedure proc_get_user_connected;
end Pkg_Archi_Oracle ;
/

desc Pkg_Archi_Oracle ;

CREATE OR REPLACE PACKAGE BODY Pkg_Archi_Oracle IS
  procedure proc_get_user_connected
  is
  cursor get_user_connected is
  select username ,to_char(logon_time, 'DD/MM/YYYY HH24:MI:SS') as log_time , program, sql_text
  from v$session , v$sqlarea
  where v$session.sql_address = v$sqlarea.address
  order by username, program;
  begin
  for tup in get_user_connected
  loop
  dbms_output.put_line('Connected user : '||tup.username||'    '||tup.log_time);
  end loop ;
  end proc_get_user_connected;
  end Pkg_Archi_Oracle ;
/

desc Pkg_Archi_Oracle ;

/*
PROCEDURE PROC_GET_USER_CONNECTED
*/

set serveroutput on ;
execute Pkg_Archi_Oracle.proc_get_user_connected ;

/*
Connected user : LORTOLE    09/12/2016 05:15:27
*/
