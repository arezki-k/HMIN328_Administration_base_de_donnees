/*
Vous écrirez de deux manières différentes, la requête :
donnez les étudiants qui s’apprécient mutuellement (couples d’amis).
Vous en donnerez les expressions algébriques et
vous formulerez votre avis sur la requête qui vous semble la plus efficace.
*/

select A.numAmi , A.numEtudiant
from Apprecie A, Apprecie AA
where (A.numEtudiant = AA.numAmi and A.numAmi = AA.numEtudiant)
;

/*
NUMAMI	   NUMETUDIAN
---------- ----------
20102345   20101234
20112345   20101234
20101234   20102345
20101234   20112345
*/


explain plan for select A.numAmi , A.numEtudiant
from Apprecie A, Apprecie AA
where (A.numEtudiant = AA.numAmi and A.numAmi = AA.numEtudiant)
;

select plan_table_output from table (dbms_xplan.display()) ;

/*
PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 2115480132

----------------------------------------------------------------------------------
| Id  | Operation	   | Name	 | Rows  | Bytes | Cost (%CPU)| Time	 |
----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |		 |     7 |   196 |     1   (0)| 00:00:01 |
|   1 |  NESTED LOOPS	   |		 |     7 |   196 |     1   (0)| 00:00:01 |
|   2 |   INDEX FULL SCAN  | APPRECIE_PK |     7 |    98 |     1   (0)| 00:00:01 |
|*  3 |   INDEX UNIQUE SCAN| APPRECIE_PK |     1 |    14 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------------


PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------

   3 - access("A"."NUMAMI"="AA"."NUMETUDIANT" AND
	      "A"."NUMETUDIANT"="AA"."NUMAMI")

Note
-----
   - dynamic sampling used for this statement (level=2)

20 rows selected.

*/

select A.numAmi , A.numEtudiant
from Apprecie A
where A.numAmi in (select numEtudiant from Apprecie)
and A.numEtudiant in (select numAmi from Apprecie)
;

/*
NUMAMI	   NUMETUDIAN
---------- ----------
20101234   20112345
20101234   20102345
20102345   20101234
20102345   20112345
20112345   20101234

*/


explain plan for select A.numAmi , A.numEtudiant
from Apprecie A
where A.numAmi in (select numEtudiant from Apprecie)
and A.numEtudiant in (select numAmi from Apprecie)
;

select plan_table_output from table (dbms_xplan.display()) ;

/*
PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 2609232508

---------------------------------------------------------------------------------
| Id  | Operation	  | Name	| Rows	| Bytes | Cost (%CPU)| Time	|
---------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |		|     7 |   196 |     4  (25)| 00:00:01 |
|*  1 |  HASH JOIN SEMI   |		|     7 |   196 |     4  (25)| 00:00:01 |
|*  2 |   HASH JOIN SEMI  |		|     7 |   147 |     3  (34)| 00:00:01 |
|   3 |    INDEX FULL SCAN| APPRECIE_PK |     7 |    98 |     1   (0)| 00:00:01 |
|   4 |    INDEX FULL SCAN| APPRECIE_PK |     7 |    49 |     1   (0)| 00:00:01 |
|   5 |   INDEX FULL SCAN | APPRECIE_PK |     7 |    49 |     1   (0)| 00:00:01 |

PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("A"."NUMAMI"="NUMETUDIANT")
   2 - access("A"."NUMETUDIANT"="NUMAMI")

Note
-----
   - dynamic sampling used for this statement (level=2)

22 rows selected.

*/

select A.numAmi , A.numEtudiant
from Apprecie A
where exists (select * from apprecie AA where AA.numEtudiant=A.numAmi  and  AA.numAmi=A.numEtudiant)
;

/*
NUMAMI	   NUMETUDIAN
---------- ----------
20102345   20101234
20112345   20101234
20101234   20102345
20101234   20112345

*/


explain plan for select A.numAmi , A.numEtudiant
from Apprecie A
where exists (select * from apprecie AA where AA.numEtudiant=A.numAmi  and  AA.numAmi=A.numEtudiant)
;

select plan_table_output from table (dbms_xplan.display()) ;

/*
PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 2817245362

----------------------------------------------------------------------------------
| Id  | Operation	   | Name	 | Rows  | Bytes | Cost (%CPU)| Time	 |
----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |		 |     7 |   196 |     1   (0)| 00:00:01 |
|   1 |  NESTED LOOPS SEMI |		 |     7 |   196 |     1   (0)| 00:00:01 |
|   2 |   INDEX FULL SCAN  | APPRECIE_PK |     7 |    98 |     1   (0)| 00:00:01 |
|*  3 |   INDEX UNIQUE SCAN| APPRECIE_PK |     7 |    98 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------------


PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------

   3 - access("AA"."NUMETUDIANT"="A"."NUMAMI" AND
	      "AA"."NUMAMI"="A"."NUMETUDIANT")

Note
-----
   - dynamic sampling used for this statement (level=2)

20 rows selected.

*/

select numAmi , numEtudiant from Apprecie
intersect
select numEtudiant , numAmi from apprecie;
;

/*
NUMAMI	   NUMETUDIAN
---------- ----------
20101234   20102345
20101234   20112345
20102345   20101234
20112345   20101234
*/


explain plan for select A.numAmi , A.numEtudiant
from Apprecie A
where exists (select * from apprecie AA where AA.numEtudiant=A.numAmi  and  AA.numAmi=A.numEtudiant)
;

select plan_table_output from table (dbms_xplan.display()) ;

/*
PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 2817245362

----------------------------------------------------------------------------------
| Id  | Operation	   | Name	 | Rows  | Bytes | Cost (%CPU)| Time	 |
----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |		 |     7 |   196 |     1   (0)| 00:00:01 |
|   1 |  NESTED LOOPS SEMI |		 |     7 |   196 |     1   (0)| 00:00:01 |
|   2 |   INDEX FULL SCAN  | APPRECIE_PK |     7 |    98 |     1   (0)| 00:00:01 |
|*  3 |   INDEX UNIQUE SCAN| APPRECIE_PK |     7 |    98 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------------


PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------

   3 - access("AA"."NUMETUDIANT"="A"."NUMAMI" AND
	      "AA"."NUMAMI"="A"."NUMETUDIANT")

Note
-----
   - dynamic sampling used for this statement (level=2)

20 rows selected.

*/


select EA.prenom , EB.prenom
from Apprecie A, Apprecie AA, Etudiant EA, Etudiant EB
where (A.numEtudiant = EA.numINE and A.numAmi = EB.numINE)
and (AA.numEtudiant = EB.numINE and AA.numAmi = EA.numINE)
;

/*
PRENOM		PRENOM
--------------- ---------------
Paul		Marie
Paul		Mathilde
Marie		Paul
Mathilde	Paul
*/


explain plan for select EA.prenom , EB.prenom
from Apprecie A, Apprecie AA, Etudiant EA, Etudiant EB
where (A.numEtudiant = EA.numINE and A.numAmi = EB.numINE)
and (AA.numEtudiant = EB.numINE and AA.numAmi = EA.numINE)
;
select plan_table_output from table (dbms_xplan.display()) ;

/*
PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 1258858409

---------------------------------------------------------------------------------------------
| Id  | Operation		      | Name	    | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT	      | 	    |	  1 |	 60 |	  8  (13)| 00:00:01 |
|   1 |  NESTED LOOPS		      | 	    |	  1 |	 60 |	  8  (13)| 00:00:01 |
|   2 |   NESTED LOOPS		      | 	    |	  7 |	322 |	  8  (13)| 00:00:01 |
|*  3 |    HASH JOIN		      | 	    |	  7 |	210 |	  5  (20)| 00:00:01 |
|   4 |     TABLE ACCESS FULL	      | ETUDIANT    |	  6 |	 96 |	  3   (0)| 00:00:01 |
|   5 |     INDEX FULL SCAN	      | APPRECIE_PK |	  7 |	 98 |	  1   (0)| 00:00:01 |
|   6 |    TABLE ACCESS BY INDEX ROWID| ETUDIANT    |	  1 |	 16 |	  1   (0)| 00:00:01 |
|*  7 |     INDEX UNIQUE SCAN	      | ETUDIANT_PK |	  1 |	    |	  0   (0)| 00:00:01 |
|*  8 |   INDEX UNIQUE SCAN	      | APPRECIE_PK |	  1 |	 14 |	  0   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   3 - access("A"."NUMETUDIANT"="EA"."NUMINE")
   7 - access("A"."NUMAMI"="EB"."NUMINE")
   8 - access("AA"."NUMETUDIANT"="EB"."NUMINE" AND "AA"."NUMAMI"="EA"."NUMINE")

PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Note
-----
   - dynamic sampling used for this statement (level=2)

26 rows selected.

*/

select EA.prenom , EB.prenom
from Apprecie A, Apprecie AA, Etudiant EA, Etudiant EB
where (A.numEtudiant = AA.numAmi and A.numAmi = AA.numEtudiant)
and (A.numEtudiant = EB.numINE and A.numAmi = EA.numINE)
;

/*
PRENOM		PRENOM
--------------- ---------------
Paul		Marie
Paul		Mathilde
Marie		Paul
Mathilde	Paul
*/


explain plan for select EA.prenom , EB.prenom
from Apprecie A, Apprecie AA, Etudiant EA, Etudiant EB
where (A.numEtudiant = AA.numAmi and A.numAmi = AA.numEtudiant)
and (A.numEtudiant = EB.numINE and A.numAmi = EA.numINE)
;
select plan_table_output from table (dbms_xplan.display()) ;

/*
PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 1258858409

---------------------------------------------------------------------------------------------
| Id  | Operation		      | Name	    | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT	      | 	    |	  7 |	420 |	  8  (13)| 00:00:01 |
|   1 |  NESTED LOOPS		      | 	    |	  7 |	420 |	  8  (13)| 00:00:01 |
|   2 |   NESTED LOOPS		      | 	    |	  7 |	322 |	  8  (13)| 00:00:01 |
|*  3 |    HASH JOIN		      | 	    |	  7 |	210 |	  5  (20)| 00:00:01 |
|   4 |     TABLE ACCESS FULL	      | ETUDIANT    |	  6 |	 96 |	  3   (0)| 00:00:01 |
|   5 |     INDEX FULL SCAN	      | APPRECIE_PK |	  7 |	 98 |	  1   (0)| 00:00:01 |
|   6 |    TABLE ACCESS BY INDEX ROWID| ETUDIANT    |	  1 |	 16 |	  1   (0)| 00:00:01 |
|*  7 |     INDEX UNIQUE SCAN	      | ETUDIANT_PK |	  1 |	    |	  0   (0)| 00:00:01 |
|*  8 |   INDEX UNIQUE SCAN	      | APPRECIE_PK |	  1 |	 14 |	  0   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   3 - access("A"."NUMETUDIANT"="EB"."NUMINE")
   7 - access("A"."NUMAMI"="EA"."NUMINE")
   8 - access("A"."NUMAMI"="AA"."NUMETUDIANT" AND "A"."NUMETUDIANT"="AA"."NUMAMI")

PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Note
-----
   - dynamic sampling used for this statement (level=2)

26 rows selected.


*/

select EA.prenom , EB.prenom
from Apprecie A, Etudiant EA, Etudiant EB
where A.numAmi in (select numEtudiant from Apprecie)
and A.numEtudiant in (select numAmi from Apprecie)
and (A.numEtudiant = EB.numINE and A.numAmi = EA.numINE)
;

/*
PRENOM		PRENOM
--------------- ---------------
Paul		Mathilde
Paul		Marie
Marie		Mathilde
Marie		Paul
Mathilde	Paul

*/


explain plan for select EA.prenom , EB.prenom
from Apprecie A, Apprecie AA, Etudiant EA, Etudiant EB
where (A.numEtudiant = AA.numAmi and A.numAmi = AA.numEtudiant)
and (A.numEtudiant = EB.numINE and A.numAmi = EA.numINE)
;
select plan_table_output from table (dbms_xplan.display()) ;

/*
PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 1258858409

---------------------------------------------------------------------------------------------
| Id  | Operation		      | Name	    | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT	      | 	    |	  7 |	420 |	  8  (13)| 00:00:01 |
|   1 |  NESTED LOOPS		      | 	    |	  7 |	420 |	  8  (13)| 00:00:01 |
|   2 |   NESTED LOOPS		      | 	    |	  7 |	322 |	  8  (13)| 00:00:01 |
|*  3 |    HASH JOIN		      | 	    |	  7 |	210 |	  5  (20)| 00:00:01 |
|   4 |     TABLE ACCESS FULL	      | ETUDIANT    |	  6 |	 96 |	  3   (0)| 00:00:01 |
|   5 |     INDEX FULL SCAN	      | APPRECIE_PK |	  7 |	 98 |	  1   (0)| 00:00:01 |
|   6 |    TABLE ACCESS BY INDEX ROWID| ETUDIANT    |	  1 |	 16 |	  1   (0)| 00:00:01 |
|*  7 |     INDEX UNIQUE SCAN	      | ETUDIANT_PK |	  1 |	    |	  0   (0)| 00:00:01 |
|*  8 |   INDEX UNIQUE SCAN	      | APPRECIE_PK |	  1 |	 14 |	  0   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   3 - access("A"."NUMETUDIANT"="EB"."NUMINE")
   7 - access("A"."NUMAMI"="EA"."NUMINE")
   8 - access("A"."NUMAMI"="AA"."NUMETUDIANT" AND "A"."NUMETUDIANT"="AA"."NUMAMI")

PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Note
-----
   - dynamic sampling used for this statement (level=2)

26 rows selected.


*/


select EA.prenom , EB.prenom
from Apprecie A, Etudiant EA, Etudiant EB
where exists (select * from apprecie AA where AA.numEtudiant=A.numAmi  and  AA.numAmi=A.numEtudiant)
and (A.numEtudiant = EB.numINE and A.numAmi = EA.numINE)
;

/*
PRENOM		PRENOM
--------------- ---------------
Paul		Mathilde
Paul		Marie
Marie		Mathilde
Marie		Paul
Mathilde	Paul

*/


explain plan for select EA.prenom , EB.prenom
from Apprecie A, Apprecie AA, Etudiant EA, Etudiant EB
where exists (select * from apprecie AA where AA.numEtudiant=A.numAmi  and  AA.numAmi=A.numEtudiant)
and (A.numEtudiant = EB.numINE and A.numAmi = EA.numINE)
;
select plan_table_output from table (dbms_xplan.display()) ;

/*
PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 3389816061

-----------------------------------------------------------------------------------------
| Id  | Operation		  | Name	| Rows	| Bytes | Cost (%CPU)| Time	|
-----------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT	  |		|    49 |  2940 |    11  (10)| 00:00:01 |
|   1 |  NESTED LOOPS SEMI	  |		|    49 |  2940 |    11  (10)| 00:00:01 |
|*  2 |   HASH JOIN		  |		|    49 |  2254 |    11  (10)| 00:00:01 |
|*  3 |    HASH JOIN		  |		|    49 |  1470 |     8  (13)| 00:00:01 |
|   4 |     MERGE JOIN CARTESIAN  |		|    42 |   672 |     6   (0)| 00:00:01 |
|   5 |      TABLE ACCESS FULL	  | ETUDIANT	|     6 |    96 |     3   (0)| 00:00:01 |

PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|   6 |      BUFFER SORT	  |		|     7 |	|     3   (0)| 00:00:01 |
|   7 |       INDEX FAST FULL SCAN| APPRECIE_PK |     7 |	|     1   (0)| 00:00:01 |
|   8 |     INDEX FULL SCAN	  | APPRECIE_PK |     7 |    98 |     1   (0)| 00:00:01 |
|   9 |    TABLE ACCESS FULL	  | ETUDIANT	|     6 |    96 |     3   (0)| 00:00:01 |
|* 10 |   INDEX UNIQUE SCAN	  | APPRECIE_PK |     7 |    98 |     0   (0)| 00:00:01 |
-----------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   2 - access("A"."NUMETUDIANT"="EB"."NUMINE")

PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   3 - access("A"."NUMAMI"="EA"."NUMINE")
  10 - access("AA"."NUMETUDIANT"="A"."NUMAMI" AND
	      "AA"."NUMAMI"="A"."NUMETUDIANT")

Note
-----
   - dynamic sampling used for this statement (level=2)

29 rows selected.


*/


select numAmi , numEtudiant ,E.prenom from Apprecie A , Etudiant E
where A.numEtudiant = E.numINE
intersect
select numEtudiant , numAmi ,E.prenom from Apprecie A , Etudiant E
where A.numAmi = E.numINE
;

/*
NUMETUDIAN NUMAMI     PRENOM
---------- ---------- ---------------
20101234   20102345   Marie
20101234   20112345   Mathilde
20102345   20101234   Paul
20112345   20101234   Paul
20112345   20102345   Marie
20123456   20101234   Paul
20123456   20102345   Marie

7 rows selected.


*/


explain plan for select numAmi , numEtudiant ,E.prenom from Apprecie A , Etudiant E
where A.numEtudiant = E.numINE
intersect
select numEtudiant , numAmi ,E.prenom from Apprecie A , Etudiant E
where A.numAmi = E.numINE
;
select plan_table_output from table (dbms_xplan.display()) ;

/*
PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 4264418869

------------------------------------------------------------------------------------
| Id  | Operation	     | Name	   | Rows  | Bytes | Cost (%CPU)| Time	   |
------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |		   |	 7 |   420 |	11  (64)| 00:00:01 |
|   1 |  INTERSECTION	     |		   |	   |	   |		|	   |
|   2 |   SORT UNIQUE	     |		   |	 7 |   210 |	 6  (34)| 00:00:01 |
|*  3 |    HASH JOIN	     |		   |	 7 |   210 |	 5  (20)| 00:00:01 |
|   4 |     TABLE ACCESS FULL| ETUDIANT    |	 6 |	96 |	 3   (0)| 00:00:01 |
|   5 |     INDEX FULL SCAN  | APPRECIE_PK |	 7 |	98 |	 1   (0)| 00:00:01 |

PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|   6 |   SORT UNIQUE	     |		   |	 7 |   210 |	 6  (34)| 00:00:01 |
|*  7 |    HASH JOIN	     |		   |	 7 |   210 |	 5  (20)| 00:00:01 |
|   8 |     TABLE ACCESS FULL| ETUDIANT    |	 6 |	96 |	 3   (0)| 00:00:01 |
|   9 |     INDEX FULL SCAN  | APPRECIE_PK |	 7 |	98 |	 1   (0)| 00:00:01 |
------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   3 - access("A"."NUMETUDIANT"="E"."NUMINE")
   7 - access("A"."NUMAMI"="E"."NUMINE")

PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Note
-----
   - dynamic sampling used for this statement (level=2)

26 rows selected.
*/
