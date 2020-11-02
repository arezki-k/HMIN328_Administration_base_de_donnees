
Exercice 1 : 


 1. select code insee from commune ; 

explain plan for select /*+ full(commune) */ * from Commune ;

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 1326938554

-----------------------------------------------------------------------------
| Id  | Operation	  | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |	    | 36318 |	 12M|	582   (1)| 00:00:07 |
|   1 |  TABLE ACCESS FULL| COMMUNE | 36318 |	 12M|	582   (1)| 00:00:07 |
-----------------------------------------------------------------------------

8 rows selected.



explain plan for select /*+ full(commune) */ code_Insee from Commune ;

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 1326938554

-----------------------------------------------------------------------------
| Id  | Operation	  | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |	    | 36318 |	177K|	582   (1)| 00:00:07 |
|   1 |  TABLE ACCESS FULL| COMMUNE | 36318 |	177K|	582   (1)| 00:00:07 |
-----------------------------------------------------------------------------

8 rows selected.


2. select nom Com from commune ;

SQL> explain plan for select /*+ full(commune) */ nom_Com from commune ;

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 1326938554

-----------------------------------------------------------------------------
| Id  | Operation	  | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |	    | 36318 |	425K|	581   (1)| 00:00:07 |
|   1 |  TABLE ACCESS FULL| COMMUNE | 36318 |	425K|	581   (1)| 00:00:07 |
-----------------------------------------------------------------------------

8 rows selected.


SQL> explain plan for select nom_Com from commune ;

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 1326938554

-----------------------------------------------------------------------------
| Id  | Operation	  | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |	    | 36318 |	425K|	581   (1)| 00:00:07 |
|   1 |  TABLE ACCESS FULL| COMMUNE | 36318 |	425K|	581   (1)| 00:00:07 |
-----------------------------------------------------------------------------

8 rows selected.




3. select nom Com, code insee from commune ; 


SQL> explain plan for select nom_Com, code_insee from commune ;

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 1326938554

-----------------------------------------------------------------------------
| Id  | Operation	  | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |	    | 36318 |	602K|	582   (1)| 00:00:07 |
|   1 |  TABLE ACCESS FULL| COMMUNE | 36318 |	602K|	582   (1)| 00:00:07 |
-----------------------------------------------------------------------------

8 rows selected.

SQL> explain plan for select /*+ full(commune) */ nom_Com , code_insee from commune ;

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 1326938554

-----------------------------------------------------------------------------
| Id  | Operation	  | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |	    | 36318 |	602K|	582   (1)| 00:00:07 |
|   1 |  TABLE ACCESS FULL| COMMUNE | 36318 |	602K|	582   (1)| 00:00:07 |
-----------------------------------------------------------------------------

8 rows selected.

/*+ NO_INDEX(Commune) */ il fait exactement la meme chose que full . mais normalement full , ca utilise dans les join car on peut mettre plusieur tables en full .



4. select nom Com from commune where code insee=’34192’ ;


SQL> explain plan for select /*+ full(commune) */  nom_Com from commune where code_Insee = '34192' ;

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 1326938554

-----------------------------------------------------------------------------
| Id  | Operation	  | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |	    |	  1 |	 17 |	582   (1)| 00:00:07 |
|*  1 |  TABLE ACCESS FULL| COMMUNE |	  1 |	 17 |	582   (1)| 00:00:07 |
-----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------

   1 - filter("CODE_INSEE"='34192')

13 rows selected.


5. select nom Com from commune where code insee like ’34%’ ;

avec index : 

SQL> explain plan for select /*+ full(commune) */ nom_Com from commune where code_Insee like '34%' ; 

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 1326938554

-----------------------------------------------------------------------------
| Id  | Operation	  | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |	    |	 17 |	289 |	582   (1)| 00:00:07 |
|*  1 |  TABLE ACCESS FULL| COMMUNE |	 17 |	289 |	582   (1)| 00:00:07 |
-----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------

   1 - filter("CODE_INSEE" LIKE '34%')

13 rows selected.



sans index : 

SQL> explain plan for select  nom_Com from commune where code_Insee like '34%' ; 

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 3123005126

--------------------------------------------------------------------------------
----------

| Id  | Operation		    | Name	 | Rows  | Bytes | Cost (%CPU)|
Time	 |

--------------------------------------------------------------------------------
----------


PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT	    |		 |    17 |   289 |     5   (0)|
00:00:01 |

|   1 |  TABLE ACCESS BY INDEX ROWID| COMMUNE	 |    17 |   289 |     5   (0)|
00:00:01 |

|*  2 |   INDEX RANGE SCAN	    | PK_COMMUNE |    17 |	 |     2   (0)|
00:00:01 |

--------------------------------------------------------------------------------
----------

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------


Predicate Information (identified by operation id):
---------------------------------------------------

   2 - access("CODE_INSEE" LIKE '34%')
       filter("CODE_INSEE" LIKE '34%')

15 rows selected.



6. select nom Com from commune where code insee like ’%392’ ;

quand il n y a pas debut d un string il peut pas trouver par index donc ca change pas . 


sans index : 

SQL> explain plan for select /*+ full(commune) */ nom_Com from commune where code_insee like '%392' ; 

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 1326938554

-----------------------------------------------------------------------------
| Id  | Operation	  | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |	    |  1816 | 30872 |	582   (1)| 00:00:07 |
|*  1 |  TABLE ACCESS FULL| COMMUNE |  1816 | 30872 |	582   (1)| 00:00:07 |
-----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------

   1 - filter("CODE_INSEE" LIKE '%392')

13 rows selected.

avec index : 

SQL> explain plan for select  nom_Com from commune where code_insee like '%392' ; 

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 1326938554

-----------------------------------------------------------------------------
| Id  | Operation	  | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |	    |  1816 | 30872 |	582   (1)| 00:00:07 |
|*  1 |  TABLE ACCESS FULL| COMMUNE |  1816 | 30872 |	582   (1)| 00:00:07 |
-----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------

   1 - filter("CODE_INSEE" LIKE '%392')

13 rows selected.



7. select nom Com from commune where code insee >= 34 ;

sans index : 

SQL> explain plan for select /*+ full(commune) */ nom_Com from commune where code_insee >= 34 ;

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 1326938554

-----------------------------------------------------------------------------
| Id  | Operation	  | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |	    |  1816 | 30872 |	582   (1)| 00:00:07 |
|*  1 |  TABLE ACCESS FULL| COMMUNE |  1816 | 30872 |	582   (1)| 00:00:07 |
-----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------

   1 - filter(TO_NUMBER("CODE_INSEE")>=34)

13 rows selected.


avec index : 

SQL> explain plan for select nom_Com from commune where code_insee >= 34 ;

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 1326938554

-----------------------------------------------------------------------------
| Id  | Operation	  | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |	    |  1816 | 30872 |	582   (1)| 00:00:07 |
|*  1 |  TABLE ACCESS FULL| COMMUNE |  1816 | 30872 |	582   (1)| 00:00:07 |
-----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------

   1 - filter(TO_NUMBER("CODE_INSEE")>=34)

13 rows selected.


8. select nom Com from commune where code insee in (’09330’,’09331’,’09332’,’09334’) ;

sans index : 

SQL> explain plan for select /*+ full(commune) */ nom_Com from commune where code_insee in ('09330','09331','09332','09334') ;

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 1326938554

-----------------------------------------------------------------------------
| Id  | Operation	  | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |	    |	  4 |	 68 |	582   (1)| 00:00:07 |
|*  1 |  TABLE ACCESS FULL| COMMUNE |	  4 |	 68 |	582   (1)| 00:00:07 |
-----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------

   1 - filter("CODE_INSEE"='09330' OR "CODE_INSEE"='09331' OR
	      "CODE_INSEE"='09332' OR "CODE_INSEE"='09334')

14 rows selected.

avec index : 

SQL> explain plan for select nom_Com from commune where code_insee in ('09330','09331','09332','09334') ;

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 3876897031

--------------------------------------------------------------------------------
-----------

| Id  | Operation		     | Name	  | Rows  | Bytes | Cost (%CPU)|
 Time	  |

--------------------------------------------------------------------------------
-----------


PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT	     |		  |	4 |    68 |	6   (0)|
 00:00:01 |

|   1 |  INLIST ITERATOR	     |		  |	  |	  |	       |
	  |

|   2 |   TABLE ACCESS BY INDEX ROWID| COMMUNE	  |	4 |    68 |	6   (0)|
 00:00:01 |

|*  3 |    INDEX UNIQUE SCAN	     | PK_COMMUNE |	4 |	  |	5   (0)|
 00:00:01 |

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-----------


Predicate Information (identified by operation id):
---------------------------------------------------

   3 - access("CODE_INSEE"='09330' OR "CODE_INSEE"='09331' OR "CODE_INSEE"='0933
2'


PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
	      OR "CODE_INSEE"='09334')

16 rows selected.


_______________________________________________________________________________________



Exercice 2 : 

1.donnez toutes les informations concernant les communes dont le nom commence par ’MO’

select * from Commune where nom_Com like 'MO%' ;

avec index : 

SQL> explain plan for select * from Commune where nom_Com like 'MO%' ;

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 1326938554

-----------------------------------------------------------------------------
| Id  | Operation	  | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |	    |	  7 |  2513 |	581   (1)| 00:00:07 |
|*  1 |  TABLE ACCESS FULL| COMMUNE |	  7 |  2513 |	581   (1)| 00:00:07 |
-----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------

   1 - filter("NOM_COM" LIKE 'MO%')

13 rows selected.


sans index : 

SQL> explain plan for select /*+ full(commune) */ * from Commune where nom_Com like 'MO%' ;

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 1326938554

-----------------------------------------------------------------------------
| Id  | Operation	  | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |	    |	  7 |  2513 |	581   (1)| 00:00:07 |
|*  1 |  TABLE ACCESS FULL| COMMUNE |	  7 |  2513 |	581   (1)| 00:00:07 |
-----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------

   1 - filter("NOM_COM" LIKE 'MO%')

13 rows selected.


2. donnez les noms et les numéros de département des communes dont la population de 2010 est
supérieure à 50 000 habitants.

select d.nom_dep , d.dep , c.POP_2010 from Commune c, departement d where c.dep = d.dep and  c.POP_2010 > 50000 ; 


sans index : 

select plan for select /*+ use_ln (commune departement) */ d.nom_dep , d.dep , c.POP_2010 from Commune c, departement d where c.dep = d.dep and  c.POP_2010 > 50000 ;


SQL> explain plan for select /*+ use_merge(commune departement) */ d.nom_dep , d.dep , c.POP_2010 from Commune c, departement d where c.dep = d.dep and  c.POP_2010 > 50000 ;

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 174368243

--------------------------------------------------------------------------------
--

| Id  | Operation	   | Name	 | Rows  | Bytes | Cost (%CPU)| Time
 |

--------------------------------------------------------------------------------
--


PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |		 | 35507 |   832K|   585   (1)| 00:00:08
 |

|*  1 |  HASH JOIN	   |		 | 35507 |   832K|   585   (1)| 00:00:08
 |

|   2 |   TABLE ACCESS FULL| DEPARTEMENT |   101 |  1313 |     3   (0)| 00:00:01
 |

|*  3 |   TABLE ACCESS FULL| COMMUNE	 | 35507 |   381K|   582   (1)| 00:00:07
 |

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--


Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("C"."DEP"="D"."DEP")
   3 - filter("C"."POP_2010">50000)

16 rows selected.

avec index : 

SQL> explain plan for select  d.nom_dep , d.dep , c.POP_2010 from Commune c, departement d where c.dep = d.dep and  c.POP_2010 > 50000 ;

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 174368243

--------------------------------------------------------------------------------
--

| Id  | Operation	   | Name	 | Rows  | Bytes | Cost (%CPU)| Time
 |

--------------------------------------------------------------------------------
--


PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |		 | 35507 |   832K|   585   (1)| 00:00:08
 |

|*  1 |  HASH JOIN	   |		 | 35507 |   832K|   585   (1)| 00:00:08
 |

|   2 |   TABLE ACCESS FULL| DEPARTEMENT |   101 |  1313 |     3   (0)| 00:00:01
 |

|*  3 |   TABLE ACCESS FULL| COMMUNE	 | 35507 |   381K|   582   (1)| 00:00:07
 |

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--


Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("C"."DEP"="D"."DEP")
   3 - filter("C"."POP_2010">50000)

16 rows selected.


3. donnez toutes les informations concernant les départements dont le numéro de département est
compris entre 25 et 45. 


select * from departement where dep between 25 and 45 ; 

avec index : 

SQL> explain plan for select * from departement where dep between 25 and 45 ;

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 3134614689

--------------------------------------------------------------------------------
-

| Id  | Operation	  | Name	| Rows	| Bytes | Cost (%CPU)| Time
|

--------------------------------------------------------------------------------
-


PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |		|     1 |    20 |     3   (0)| 00:00:01
|

|*  1 |  TABLE ACCESS FULL| DEPARTEMENT |     1 |    20 |     3   (0)| 00:00:01
|

--------------------------------------------------------------------------------
-


Predicate Information (identified by operation id):

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
---------------------------------------------------

   1 - filter(TO_NUMBER("DEP")>=25 AND TO_NUMBER("DEP")<=45)

13 rows selected.


sans index : 

SQL> explain plan for select /*+ full(departement) */  *  from departement where dep between 25 and 45 ;

Explained.

SQL> select plan_table_output from table(dbms_xplan.display()) ;

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 3134614689

--------------------------------------------------------------------------------
-

| Id  | Operation	  | Name	| Rows	| Bytes | Cost (%CPU)| Time
|

--------------------------------------------------------------------------------
-


PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |		|     1 |    20 |     3   (0)| 00:00:01
|

|*  1 |  TABLE ACCESS FULL| DEPARTEMENT |     1 |    20 |     3   (0)| 00:00:01
|

--------------------------------------------------------------------------------
-


Predicate Information (identified by operation id):

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
---------------------------------------------------

   1 - filter(TO_NUMBER("DEP")>=25 AND TO_NUMBER("DEP")<=45)

13 rows selected.


4. donnez pour les communes, leur nom, et le nom de leur département d’appartenance et de leur
région d’appartenance 



______________________________________________________________________________________________

Exercice 3 : 

select c.nom_com , d.nom_dep , c.longitude , c.latitude from Commune c , departement d where c.dep = d.dep and d.nom_dep = 'HERAULT' OR d.nom_dep = 'GARD' ; 