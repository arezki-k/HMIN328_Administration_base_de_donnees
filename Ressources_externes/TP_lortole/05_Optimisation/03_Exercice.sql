/*
Exercice 3
*/


/*
1. Exprimez la requête donnez le nom, la latitude et la longitude des communes qui se situent
dans les départements de l’Hérault et du Gard sous différentes formes (expression d’une semi-
jointure) :
-sous forme de jointure
-sous forme de requête imbriquée (test de vacuité (exists) et test d’appartenance (in)).
Quelle est l’écriture qui vous semble la moins coûteuse (utilisez settiming et explain ) ?
Quels sont les opérateurs physiques exploités respectivement pour exprimer la jointure ?
Exploiter les directives (hint) pour forcer le choix d’un opérateur (par exempleuse nl).

Construisez sur papier un arbre algébrique puis les plans physiques correspondant à chaque plan d’exécution choisi.

*/


/* sous forme de jointure */
select 	nom_com ,	longitude ,	latitude
from commune C , departement D
where C.dep = D.dep and (D.nom_dep='HERAULT' OR D.nom_dep='GARD')
;

explain plan for select 	nom_com ,	longitude ,	latitude
from commune C , departement D
where C.dep = D.dep and (D.nom_dep='HERAULT' OR D.nom_dep='GARD')
;

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
|   0 | SELECT STATEMENT   |		 |   757 | 28766 |   584   (1)| 00:00:08
 |

|*  1 |  HASH JOIN	   |		 |   757 | 28766 |   584   (1)| 00:00:08
 |

|*  2 |   TABLE ACCESS FULL| DEPARTEMENT |     2 |    26 |     3   (0)| 00:00:01
 |

|   3 |   TABLE ACCESS FULL| COMMUNE	 | 36318 |   886K|   581   (1)| 00:00:07
 |

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--


Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("C"."DEP"="D"."DEP")
   2 - filter("D"."NOM_DEP"='GARD' OR "D"."NOM_DEP"='HERAULT')

16 rows selected.


*/

/* -sous forme de requête imbriquée (test de vacuité (exists) et test d’appartenance (in)).  */
select 	nom_com ,	longitude ,	latitude
from commune C
where C.dep in  ( select dep from departement D where D.nom_dep='HERAULT' OR D.nom_dep='GARD')
;

explain plan for select 	nom_com ,	longitude ,	latitude
from commune C
where C.dep in  ( select dep from departement D where D.nom_dep='HERAULT' OR D.nom_dep='GARD')
;
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
|   0 | SELECT STATEMENT   |		 |   757 | 28766 |   584   (1)| 00:00:08
 |

|*  1 |  HASH JOIN	   |		 |   757 | 28766 |   584   (1)| 00:00:08
 |

|*  2 |   TABLE ACCESS FULL| DEPARTEMENT |     2 |    26 |     3   (0)| 00:00:01
 |

|   3 |   TABLE ACCESS FULL| COMMUNE	 | 36318 |   886K|   581   (1)| 00:00:07
 |

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--


Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("C"."DEP"="DEP")
   2 - filter("D"."NOM_DEP"='GARD' OR "D"."NOM_DEP"='HERAULT')

16 rows selected.

*/


select 	nom_com ,	longitude ,	latitude
from commune C
where exists  ( select * from departement D where C.dep = D.dep and (D.nom_dep='HERAULT' OR D.nom_dep='GARD'))
;

explain plan for select 	nom_com ,	longitude ,	latitude
from commune C
where exists  ( select * from departement D where C.dep = D.dep and (D.nom_dep='HERAULT' OR D.nom_dep='GARD'))
;
select plan_table_output from table(dbms_xplan.display()) ;

/*

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 1911161922

--------------------------------------------------------------------------------
----

| Id  | Operation	     | Name	   | Rows  | Bytes | Cost (%CPU)| Time
   |

--------------------------------------------------------------------------------
----


PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |		   |   757 | 28766 |   584   (1)| 00:00:
08 |

|*  1 |  HASH JOIN RIGHT SEMI|		   |   757 | 28766 |   584   (1)| 00:00:
08 |

|*  2 |   TABLE ACCESS FULL  | DEPARTEMENT |	 2 |	26 |	 3   (0)| 00:00:
01 |

|   3 |   TABLE ACCESS FULL  | COMMUNE	   | 36318 |   886K|   581   (1)| 00:00:
07 |

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
----


Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("C"."DEP"="D"."DEP")
   2 - filter("D"."NOM_DEP"='GARD' OR "D"."NOM_DEP"='HERAULT')

16 rows selected.


*/

/*
2. Ecrivez la requête donnez le nom et la population 2010 des communes qui ont plus d’habitants
que le nombre moyen d’habitants par commune. Exploitez le plan d’exécution pour cette requête.
Quelles sont les opérations exploitées par l’optimiseur ?
*/

select nom_com , pop_2010
from commune
where pop_2010 > ( select avg(pop_2010) from commune)
;

explain plan for select nom_com , pop_2010
from commune
where pop_2010 > ( select avg(pop_2010) from commune)
;

select plan_table_output from table(dbms_xplan.display()) ;

/*

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 3021606514

-------------------------------------------------------------------------------
| Id  | Operation	    | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |	      |  1816 | 38136 |  1163	(1)| 00:00:14 |
|*  1 |  TABLE ACCESS FULL  | COMMUNE |  1816 | 38136 |   582	(1)| 00:00:07 |
|   2 |   SORT AGGREGATE    |	      |     1 |     9 | 	   |	      |
|   3 |    TABLE ACCESS FULL| COMMUNE | 36318 |   319K|   582	(1)| 00:00:07 |
-------------------------------------------------------------------------------


PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter("POP_2010"> (SELECT AVG("POP_2010") FROM "COMMUNE"
	      "COMMUNE"))

16 rows selected.


*/


/*
3. Ecrivez la requête de différentes manières : donnez le nom des communes, le nom de leur
département et de leur région respectifs lorsque ces communes sont situées dans les régions Midi-
Pyrénées, Languedoc-Roussillon et Provence-Alpes-Côte d’Azur. Commentez les plans d’exécution obtenus.
*/


select nom_reg from region;

select nom_com , nom_dep , nom_reg
from commune C , departement D , region R
where R.reg = D.reg  and C.dep = D.dep
and (R.nom_reg='LANGUEDOC-ROUSSILLON' or R.nom_reg = 'PROVENCE-ALPES-COTE D''AZUR' or R.nom_reg='MIDI-PYRENEES')


explain plan for select nom_com , nom_dep , nom_reg
from commune C , departement D , region R
where R.reg = D.reg  and C.dep = D.dep
and (R.nom_reg='LANGUEDOC-ROUSSILLON' or R.nom_reg = 'PROVENCE-ALPES-COTE D''AZUR' or R.nom_reg='MIDI-PYRENEES')
;

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
|   0 | SELECT STATEMENT	      | 	    |  4035 |	169K|	587   (1
)| 00:00:08 |

|*  1 |  HASH JOIN		      | 	    |  4035 |	169K|	587   (1
)| 00:00:08 |

|   2 |   MERGE JOIN		      | 	    |	 11 |	319 |	  6  (17
)| 00:00:01 |

|*  3 |    TABLE ACCESS BY INDEX ROWID| REGION	    |	  3 |	 42 |	  2   (0
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
   3 - filter("R"."NOM_REG"='LANGUEDOC-ROUSSILLON' OR "R"."NOM_REG"='MIDI-PYRENE

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
ES'

	      OR "R"."NOM_REG"='PROVENCE-ALPES-COTE D''AZUR')
   5 - access("R"."REG"="D"."REG")
       filter("R"."REG"="D"."REG")

23 rows selected.


*/




select nom_com , nom_dep , nom_reg
from commune C , departement D , region RR
where  C.dep = D.dep and D.reg=RR.reg and
D.reg in (select reg
  from region R
  where R.nom_reg='LANGUEDOC-ROUSSILLON' or R.nom_reg = 'PROVENCE-ALPES-COTE D''AZUR' or R.nom_reg='MIDI-PYRENEES')


explain plan for select nom_com , nom_dep , nom_reg
from commune C , departement D , region RR
where  C.dep = D.dep and D.reg=RR.reg and
D.reg in (select reg
  from region R
  where R.nom_reg='LANGUEDOC-ROUSSILLON' or R.nom_reg = 'PROVENCE-ALPES-COTE D''AZUR' or R.nom_reg='MIDI-PYRENEES')

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
|   0 | SELECT STATEMENT	      | 	    |  4035 |	169K|	587   (1
)| 00:00:08 |

|*  1 |  HASH JOIN		      | 	    |  4035 |	169K|	587   (1
)| 00:00:08 |

|   2 |   MERGE JOIN		      | 	    |	 11 |	319 |	  6  (17
)| 00:00:01 |

|*  3 |    TABLE ACCESS BY INDEX ROWID| REGION	    |	  3 |	 42 |	  2   (0
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
   3 - filter("R"."NOM_REG"='LANGUEDOC-ROUSSILLON' OR "R"."NOM_REG"='MIDI-PYRENE

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
ES'

	      OR "R"."NOM_REG"='PROVENCE-ALPES-COTE D''AZUR')
   5 - access("R"."REG"="D"."REG")
       filter("R"."REG"="D"."REG")

23 rows selected.


*/



select nom_com , nom_dep
from commune C , departement D
where  C.dep = D.dep  and
D.reg in (select reg
  from region R
  where R.nom_reg='LANGUEDOC-ROUSSILLON' or R.nom_reg = 'PROVENCE-ALPES-COTE D''AZUR' or R.nom_reg='MIDI-PYRENEES')


explain plan for select nom_com , nom_dep
from commune C , departement D
where  C.dep = D.dep and
D.reg in (select reg
  from region R
  where R.nom_reg='LANGUEDOC-ROUSSILLON' or R.nom_reg = 'PROVENCE-ALPES-COTE D''AZUR' or R.nom_reg='MIDI-PYRENEES')

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
|   0 | SELECT STATEMENT	      | 	    |  4035 |	169K|	587   (1
)| 00:00:08 |

|*  1 |  HASH JOIN		      | 	    |  4035 |	169K|	587   (1
)| 00:00:08 |

|   2 |   MERGE JOIN		      | 	    |	 11 |	319 |	  6  (17
)| 00:00:01 |

|*  3 |    TABLE ACCESS BY INDEX ROWID| REGION	    |	  3 |	 42 |	  2   (0
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
   3 - filter("R"."NOM_REG"='LANGUEDOC-ROUSSILLON' OR "R"."NOM_REG"='MIDI-PYRENE

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
ES'

	      OR "R"."NOM_REG"='PROVENCE-ALPES-COTE D''AZUR')
   5 - access("R"."REG"="D"."REG")
       filter("R"."REG"="D"."REG")

23 rows selected.


*/


explain plan for select /*+ ordered */ nom_com , nom_dep
from commune C , departement D
where  C.dep = D.dep and
D.reg in (select reg
  from region R
  where R.nom_reg='LANGUEDOC-ROUSSILLON' or R.nom_reg = 'PROVENCE-ALPES-COTE D''AZUR' or R.nom_reg='MIDI-PYRENEES')

select plan_table_output from table(dbms_xplan.display()) ;



/*

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 70998721

--------------------------------------------------------------------------------
-----

| Id  | Operation	      | Name	    | Rows  | Bytes | Cost (%CPU)| Time
    |

--------------------------------------------------------------------------------
-----


PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT      | 	    |	407K|	 11M|  1746   (1)| 00:00
:21 |

|*  1 |  HASH JOIN	      | 	    |	407K|	 11M|  1746   (1)| 00:00
:21 |

|   2 |   TABLE ACCESS FULL   | DEPARTEMENT |	101 |	202 |	  3   (0)| 00:00
:01 |

|   3 |   MERGE JOIN CARTESIAN| 	    |	108K|  2979K|  1741   (1)| 00:00
:21 |

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------

|*  4 |    TABLE ACCESS FULL  | REGION	    |	  3 |	 42 |	  3   (0)| 00:00
:01 |

|   5 |    BUFFER SORT	      | 	    | 36318 |	496K|  1738   (1)| 00:00
:21 |

|*  6 |     TABLE ACCESS FULL | COMMUNE     | 36318 |	496K|	579   (0)| 00:00
:07 |

--------------------------------------------------------------------------------


*/


select nom_com
from commune C
where  C.dep in (select dep
  from departement R
  where D.reg in (select reg
  from region R
  where R.nom_reg='LANGUEDOC-ROUSSILLON' or R.nom_reg = 'PROVENCE-ALPES-COTE D''AZUR' or R.nom_reg='MIDI-PYRENEES'))
  ;


explain plan for select nom_com
from commune C , departement D
where  C.dep in (select dep
  from departement R
  where D.reg in (select reg
  from region R
  where R.nom_reg='LANGUEDOC-ROUSSILLON' or R.nom_reg = 'PROVENCE-ALPES-COTE D''AZUR' or R.nom_reg='MIDI-PYRENEES'))
  ;

select plan_table_output from table(dbms_xplan.display()) ;

/*
PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
Plan hash value: 70998721

--------------------------------------------------------------------------------
-----

| Id  | Operation	      | Name	    | Rows  | Bytes | Cost (%CPU)| Time
    |

--------------------------------------------------------------------------------
-----


PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT      | 	    |	407K|	 11M|  1746   (1)| 00:00
:21 |

|*  1 |  HASH JOIN	      | 	    |	407K|	 11M|  1746   (1)| 00:00
:21 |

|   2 |   TABLE ACCESS FULL   | DEPARTEMENT |	101 |	202 |	  3   (0)| 00:00
:01 |

|   3 |   MERGE JOIN CARTESIAN| 	    |	108K|  2979K|  1741   (1)| 00:00
:21 |

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------

|*  4 |    TABLE ACCESS FULL  | REGION	    |	  3 |	 42 |	  3   (0)| 00:00
:01 |

|   5 |    BUFFER SORT	      | 	    | 36318 |	496K|  1738   (1)| 00:00
:21 |

|*  6 |     TABLE ACCESS FULL | COMMUNE     | 36318 |	496K|	579   (0)| 00:00
:07 |

--------------------------------------------------------------------------------

PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
-----


Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("D"."REG"="REG")
   4 - filter("R"."NOM_REG"='LANGUEDOC-ROUSSILLON' OR
	      "R"."NOM_REG"='MIDI-PYRENEES' OR "R"."NOM_REG"='PROVENCE-ALPES-COT
E D''AZUR')


PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------
   6 - filter("C"."DEP" IS NOT NULL)

21 rows selected.

*/
