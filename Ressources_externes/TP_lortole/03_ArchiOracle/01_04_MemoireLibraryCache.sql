/*
1.4
Mémoire ”LibraryCache”
Tous les ordres SQL (mais pas que) transitent par la m ́emoire ”LibraryCache”. Vous exploiterez
les vues aff ́erentes `
a cette zone m ́emoire : v$sqlarea, v$sql et v$sql plan pour tracer et  ́evaluer les
derni`eres requˆetes trait ́ees par le syst`eme. Diff ́erents exemples de requˆete (allant dans ce sens) sont
donn ́es
*/


select to_char(logon_time, 'DD/MM/YYYY HH24:MI:SS') as log_time , username, program, sql_text
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


select sql_id, disk_reads from v$sql where rownum <20 order by disk_reads desc
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


select r.sql_id, disk_reads, elapsed_time, username from v$sql r, v$session s where
s.sql_id = r.sql_id and type='USER'
;

/*

SQL_ID	      DISK_READS ELAPSED_TIME USERNAME
------------- ---------- ------------ ------------------------------
2y55u8k9msfqc	     166       160259 JMUNOZAVENDA
gtqug0ky3f2wy	       0	 5637 LORTOLE


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


set linesize 1000 ;


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





/*

Vous construirez diff ́erentes fonctions permettant de disposer d’informations sur les activit ́es d’un
usager en particulier et sur les requˆetes les plus coˆ
uteuses. Vous pouvez aussi tester tout l’int ́erˆet des
variables li ́ees.

*/
