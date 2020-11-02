/*
Exploiter les vues user_tables et dba_tables


Les informations concernant l’organisation logique et physique des tables de votre schéma utilisa-
teur sont disponibles depuis les vues user tables et dba tables. Les attributs suivants donnent une idée
du nombre de blocs alloués à chaque table :
1. NUM ROWS : nombre de lignes
2. BLOCKS : nombre de blocs utilisés
3. EMPTY BLOCKS : nombre de blocs alloués, mais non utilisés
4. AVG SPACE : espace libre moyen dans les blocs utilisés
5. AVG ROW LEN : longueur moyenne des lignes
*/

desc user_tables ;
select TABLE_NAME from user_tables ;


desc dba_tables;
select TABLE_NAME from dba_tables ;


CREATE TABLE test
(
	num char(3) ,
	commentaire char(97),
	CONSTRAINT check_test_num
  CHECK (num BETWEEN 0 and 99)
)
;

analyze table test compute statistics ;


select parsing_schema_name, cpu_time/1000, executions, substr(sql_text) as tronk from v$sqlarea ;

select parsing_schema_name, cpu_time/1000, executions, substr(sql_text,10) as tronk from v$sqlarea where rownum < 20 and parsing_schema_name is not null;
