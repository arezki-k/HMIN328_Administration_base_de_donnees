SELECT index_name, blevel, table_name
FROM user_indexes;


select constraint_name , constraint_type
from user_constraints
where constraint_type ='P' ;


SELECT name, btree_space, most_repeated_key, lf_rows, br_rows, height
FROM index_stats;



ANALYZE INDEX PK_COMMUNE VALIDATE STRUCTURE
;

SELECT name, btree_space, most_repeated_key, lf_rows, br_rows, height , br_blks
FROM index_stats;

ANALYZE INDEX PK_DEPARTEMENT VALIDATE STRUCTURE
;

SELECT name, btree_space, most_repeated_key, lf_rows, br_rows, height , br_blks
FROM index_stats;

ANALYZE INDEX PK_ALBUM VALIDATE STRUCTURE;

SELECT name, btree_space, most_repeated_key, lf_rows, br_rows, height , br_blks
FROM index_stats;


set linesize 300 ;
col table_name for a20 ;

SELECT index_name , table_name , blevel , LEAF_BLOCKS , uniqueness
from user_indexes ;


SELECT name, btree_space, most_repeated_key, lf_rows, br_rows,lf_rows_len, br_rows_len,lf_blks, br_blks, height
FROM index_stats;
