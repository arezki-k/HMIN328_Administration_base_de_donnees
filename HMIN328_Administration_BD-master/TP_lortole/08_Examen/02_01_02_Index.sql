/*
drop index etudiant_idx;
*/
create index etudiant_idx on inscritdans (numine)
;
/*
Index created.
*/

/*
drop index formation_idx;
*/
create index formation_idx on inscritdans (codeF)
;

/*
Index created.²
*/

select index_name , table_name , unIQUENESS
FROM USER_INDEXES
WHERE TABLE_NAME IN ('ETUDIANT','FORMATION','INSCRITDANS','APPRECIE')
;

/*
INDEX_NAME		       TABLE_NAME		      UNIQUENES
------------------------------ ------------------------------ ---------
APPRECIE_PK		       APPRECIE 		      UNIQUE
ETUDIANT_PK		       ETUDIANT 		      UNIQUE
FORMATION_PK		       FORMATION		      UNIQUE
INSCRITDANS_PK		       INSCRITDANS		      UNIQUE
ETUDIANT_IDX		       INSCRITDANS		      NONUNIQUE
FORMATION_IDX		       INSCRITDANS		      NONUNIQUE

6 rows selected.
*/
