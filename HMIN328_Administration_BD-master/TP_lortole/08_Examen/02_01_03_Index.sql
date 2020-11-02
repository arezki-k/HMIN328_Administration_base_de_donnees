set linesize 300 ;
col name for a12 ;

analyze index etudiant_pk validate structure;
SELECT name, btree_space, most_repeated_key, lf_rows, br_rows, height
FROM index_stats;

/*
NAME	     BTREE_SPACE MOST_REPEATED_KEY    LF_ROWS	 BR_ROWS     HEIGHT
------------ ----------- ----------------- ---------- ---------- ----------
ETUDIANT_PK	    7996		        1	             6	       0	         1

BTREE_SPACE : espace réservé
HEIGHT :  un bloc
LF_ROWS : 6 tubles
BR_ROWS : pas de niveau branch
*/

desc index_stats ;
/*
Name													       Null?	Type
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- -------- --------------------------------------------------------------------------------------------------------------------
HEIGHT 												NUMBER
BLOCKS 												NUMBER
NAME													VARCHAR2(30)
PARTITION_NAME 											VARCHAR2(30)
LF_ROWS												NUMBER
LF_BLKS												NUMBER
LF_ROWS_LEN												NUMBER
LF_BLK_LEN												NUMBER
BR_ROWS												NUMBER
BR_BLKS												NUMBER
BR_ROWS_LEN												NUMBER
BR_BLK_LEN												NUMBER
DEL_LF_ROWS												NUMBER
DEL_LF_ROWS_LEN											NUMBER
DISTINCT_KEYS												NUMBER
MOST_REPEATED_KEY											NUMBER
BTREE_SPACE												NUMBER
USED_SPACE												NUMBER
PCT_USED												NUMBER
ROWS_PER_KEY												NUMBER
BLKS_GETS_PER_ACCESS											NUMBER
PRE_ROWS												NUMBER
PRE_ROWS_LEN												NUMBER
OPT_CMPR_COUNT 											NUMBER
OPT_CMPR_PCTSAVE											NUMBER

*/

analyze index etudiant_pk validate structure;
SELECT name, btree_space, most_repeated_key, LF_BLKS, lf_rows, br_rows, BR_BLKS, height
FROM index_stats;

/*
NAME	     BTREE_SPACE MOST_REPEATED_KEY    LF_BLKS	 LF_ROWS    BR_ROWS    BR_BLKS	   HEIGHT
------------ ----------- ----------------- ---------- ---------- ---------- ---------- ----------
ETUDIANT_PK	    7996		 1	    1	       6	  0	     0		1
*/
