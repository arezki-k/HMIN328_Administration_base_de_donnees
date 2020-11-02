/*
1. Que renvoie la requête suivante ?
select rowid, rownum, code_insee from commune;
*/
select count(rowid), count(rownum), count(code_insee) from commune;
/*
rowid, rownum, code_insee pour chacune des lignes de la table commune
*/


/*
2. quels sont les index déjà presents sur votre schema utilisateur ?
Expliquez leur pr ́esence
*/
SELECT index_name, blevel, table_name
FROM user_indexes;
select constraint_name , constraint_type
from user_constraints
where constraint_type ='P' ;
/*
Présence de clé primaire
*/


/*
3. Indiquez si ces index sont uniques ? denses ?
*/


ANALYZE INDEX PK_COMMUNE VALIDATE STRUCTURE
;

SELECT name, lf_rows_len/br_rows_len as dense
FROM index_stats;

select count(rowid), count(rownum), count(code_insee) from commune;

/*
Ils sont denses car
COUNT(ROWID) COUNT(ROWNUM) COUNT(CODE_INSEE)
------------ ------------- -----------------
       36318	     36318	       36318

Ils sont uniques car clé primaire
*/

/*
4. Quelle est la hauteur de la taille de l’index de la table COMMUNE ?
*/
;

ANALYZE INDEX PK_COMMUNE VALIDATE STRUCTURE
;

  SELECT name , height
  FROM index_stats;

  /*
  La réponse est 2
  */

/*
5. Quels sont les nombres de blocs de branches et de feuilles,
qui ont  ́et ́e r ́eserv ́es pour l’index de la table COMMUNE ?
*/
ANALYZE INDEX PK_COMMUNE VALIDATE STRUCTURE
;

SELECT name , lf_blks + br_blks as nb_blks
FROM index_stats;



/*
6. Quelle est la taille de chaque tuple (cle, pointeurs, rowid) pr ́esent au niveau des blocs des feuilles
(on consid`ere que les blocs sont pleins) ?
*/
/*
7. Par comparaison, quelle est la taille moyenne de chaque tuple de la table COMMUNE et combien
de tuples peuvent ˆetre stock ́es dans un bloc (tenir compte de l’espace libre et donc de la valeur
de PCT FREE de la vue USER TABLES) ?
*/

ANALYZE TABLE COMMUNE compute statistics;

SELECT num_rows , avg_row_len, blocks , empty_blocks , pct_free , initial_extent , next_extent , tablespace_name
FROM user_tables
WHERE table_name = 'COMMUNE';

ANALYZE TABLE DEPARTEMENT compute statistics;

SELECT num_rows , avg_row_len, blocks , empty_blocks , pct_free , initial_extent , next_extent , tablespace_name
FROM user_tables
WHERE table_name = 'DEPARTEMENT';

ANALYZE TABLE REGION compute statistics;

SELECT num_rows , avg_row_len, blocks , empty_blocks , pct_free , initial_extent , next_extent , tablespace_name
FROM user_tables
WHERE table_name = 'REGION';


select name , value from v$parameter where name like '%block%' ;

select value from v$parameter where name like 'db_block_size' ;



ANALYZE TABLE COMMUNE compute statistics;


SELECT  NUM_ROWS * AVG_ROW_LEN as memory_use_avg
FROM user_tables
WHERE table_name = 'COMMUNE'
;

SELECT  blocks * value as memory_use
FROM user_tables , v$parameter
WHERE table_name = 'COMMUNE' and  name like 'db_block_size'
;

SELECT  NUM_ROWS * AVG_ROW_LEN as memory_use_avg , blocks * value as memory_use , (blocks * value) - (NUM_ROWS * AVG_ROW_LEN) as memory_diff
FROM user_tables , v$parameter
WHERE table_name = 'COMMUNE' and  name like 'db_block_size'
;

ANALYZE TABLE DEPARTEMENT compute statistics;

SELECT  NUM_ROWS * AVG_ROW_LEN as memory_use_avg
FROM user_tables
WHERE table_name = 'DEPARTEMENT'
;

SELECT  blocks * value as memory_use
FROM user_tables , v$parameter
WHERE table_name = 'DEPARTEMENT' and  name like 'db_block_size'
;

SELECT  NUM_ROWS * AVG_ROW_LEN as memory_use_avg , blocks * value as memory_use , (blocks * value) - (NUM_ROWS * AVG_ROW_LEN) as memory_diff
FROM user_tables , v$parameter
WHERE table_name = 'DEPARTEMENT' and  name like 'db_block_size'
;

ANALYZE TABLE REGION compute statistics;

SELECT  NUM_ROWS * AVG_ROW_LEN as memory_use_avg
FROM user_tables
WHERE table_name = 'REGION'
;

SELECT  blocks * value as memory_use
FROM user_tables , v$parameter
WHERE table_name = 'REGION' and  name like 'db_block_size'
;

SELECT  NUM_ROWS * AVG_ROW_LEN as memory_use_avg , blocks * value as memory_use , (blocks * value) - (NUM_ROWS * AVG_ROW_LEN) as memory_diff
FROM user_tables , v$parameter
WHERE table_name = 'REGION' and  name like 'db_block_size'
;

/*
8. Calculer le nombre de blocs th ́eorique n ́ecessaire au stockage de l’ensemble des tuples de la table
et comparez ce nombre avec la valeur de l’attribut BLOCKS de USER TABLES. Le nombre
calcul ́e vous semble-t’il r ́ealiste ?
*/

/*
9. Dans quel espace de tables est organis ́e logiquement l’index COMMUNE PK ?
*/

DESC user_indexes ;

/*
10. Quel est l’espace de stockage (en Moctets) n ́ecessaire pour la table COMMUNE ? Quel espace
de stockage suppl ́ementaire faut’il rajouter pour stocker l’index COMMUNE PK ?
*/
