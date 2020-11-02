/* alter table apprecie drop constraint apprecie_pk; */
alter table apprecie disable constraint apprecie_pk;

select index_name , table_name , unIQUENESS
FROM USER_INDEXES
WHERE TABLE_NAME IN ('ETUDIANT','FORMATION','INSCRITDANS','APPRECIE')
;

/*
INDEX_NAME		       TABLE_NAME		      UNIQUENES
------------------------------ ------------------------------ ---------
ETUDIANT_PK		       ETUDIANT 		      UNIQUE
FORMATION_PK		       FORMATION		      UNIQUE
INSCRITDANS_PK		       INSCRITDANS		      UNIQUE

*/

alter table apprecie enable constraint apprecie_pk;

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
*/
