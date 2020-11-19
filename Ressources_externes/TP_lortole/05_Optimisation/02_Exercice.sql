/*
Exercice 2
*/


Vous traiterez au travers d’un plan d’exécution les requêtes suivantes :
/*
1. donnez toutes les informations concernant les communes dont le nom commence par ’MO’
*/


explain plan for select * from commune where nom_com like 'MO%' ;
select plan_table_output from table(dbms_xplan.display()) ;


/*

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

*/

/*
2. donnez les noms et les numéros de département des communes dont la population de 2010 est supérieure à 50 000 habitants
*/


select D.dep , D.nom_dep from commune C , departement D where pop_2010 >50000 and D.Dep = C.dep;


explain plan for select /*+ ordered */D.dep , D.nom_dep from commune C , departement D where pop_2010 >50000 and D.Dep = C.dep;
select plan_table_output from table(dbms_xplan.display()) ;


explain plan for select D.dep , D.nom_dep from commune C , departement D where pop_2010 >50000 and D.Dep = C.dep;
select plan_table_output from table(dbms_xplan.display()) ;

/*

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

   1 - access("D"."DEP"="C"."DEP")
   3 - filter("POP_2010">50000)

16 rows selected.

*/


/*
3. donnez toutes les informations concernant les départements dont le numéro de département est compris entre 25 et 45
*/

select D.dep , D.nom_dep from departement D where D.Dep >= 25 and D.Dep <= 45 ;


explain plan for select D.dep , D.nom_dep from departement D where D.Dep >= 25 and D.Dep <= 45 ;
select plan_table_output from table(dbms_xplan.display()) ;

/*

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
|   0 | SELECT STATEMENT  |		|     1 |    13 |     3   (0)| 00:00:01
|

|*  1 |  TABLE ACCESS FULL| DEPARTEMENT |     1 |    13 |     3   (0)| 00:00:01
|

--------------------------------------------------------------------------------
-


Predicate Information (identified by operation id):

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
---------------------------------------------------

   1 - filter(TO_NUMBER("D"."DEP")>=25 AND TO_NUMBER("D"."DEP")<=45)

13 rows selected.


*/

/*
4. donnez pour les communes, leur nom, et le nom de leur département d’appartenance et de leurrégion d’appartenance
*/

select R.nom_reg ,D.nom_dep , C.nom_Com
from commune C , departement D , region R
where C.dep = D.dep and R.reg = D.reg ;

explain plan for select R.nom_reg ,D.nom_dep , C.nom_Com
from commune C , departement D , region R
where C.dep = D.dep and R.reg = D.reg ;
select plan_table_output from table(dbms_xplan.display()) ;

/*

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 2135887298

--------------------------------------------------------------------------------
-------------

| Id  | Operation		      | Name	    | Rows  | Bytes | Cost (%CPU
)| Time     |

--------------------------------------------------------------------------------
-------------


PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT	      | 	    | 36318 |  1525K|	587   (1
)| 00:00:08 |

|*  1 |  HASH JOIN		      | 	    | 36318 |  1525K|	587   (1
)| 00:00:08 |

|   2 |   MERGE JOIN		      | 	    |	101 |  2929 |	  6  (17
)| 00:00:01 |

|   3 |    TABLE ACCESS BY INDEX ROWID| REGION	    |	 27 |	378 |	  2   (0
)| 00:00:01 |

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------

|   4 |     INDEX FULL SCAN	      | PK_REGION   |	 27 |	    |	  1   (0
)| 00:00:01 |

|*  5 |    SORT JOIN		      | 	    |	101 |  1515 |	  4  (25
)| 00:00:01 |

|   6 |     TABLE ACCESS FULL	      | DEPARTEMENT |	101 |  1515 |	  3   (0
)| 00:00:01 |

|   7 |   TABLE ACCESS FULL	      | COMMUNE     | 36318 |	496K|	581   (1

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
)| 00:00:07 |

--------------------------------------------------------------------------------
-------------


Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("C"."DEP"="D"."DEP")
   5 - access("R"."REG"="D"."REG")

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
       filter("R"."REG"="D"."REG")

21 rows selected.


*/

CREATE INDEX index_com_dep
ON Commune (dep)
;


CREATE INDEX index_dep_reg
ON Departement (reg)
;

explain plan for select R.nom_reg ,D.nom_dep , C.nom_Com
from commune C , departement D , region R
where C.dep = D.dep and R.reg = D.reg ;
select plan_table_output from table(dbms_xplan.display()) ;

/*
5. donnez le nombre de communes par numéro et nom de département
*/

select D.dep , D.nom_dep , count(C.code_insee)
from commune C , departement D
where C.dep = D.dep
group by D.dep, D.nom_dep
;

explain plan for select D.dep , D.nom_dep , count(C.code_insee)
from commune C , departement D
where C.dep = D.dep
group by D.dep, D.nom_dep
;
select plan_table_output from table(dbms_xplan.display()) ;


/*

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 3506396006

--------------------------------------------------------------------------------
---

| Id  | Operation	    | Name	  | Rows  | Bytes | Cost (%CPU)| Time
  |

--------------------------------------------------------------------------------
---


PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |		  |  6857 |   100K|   586   (1)| 00:00:0
8 |

|   1 |  HASH GROUP BY	    |		  |  6857 |   100K|   586   (1)| 00:00:0
8 |

|*  2 |   HASH JOIN	    |		  | 36318 |   532K|   584   (1)| 00:00:0
8 |

|   3 |    TABLE ACCESS FULL| DEPARTEMENT |   101 |  1313 |	3   (0)| 00:00:0
1 |

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------

|   4 |    TABLE ACCESS FULL| COMMUNE	  | 36318 | 72636 |   581   (1)| 00:00:0
7 |

--------------------------------------------------------------------------------
---


Predicate Information (identified by operation id):
---------------------------------------------------


PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
   2 - access("C"."DEP"="D"."DEP")

16 rows selected.


*/
