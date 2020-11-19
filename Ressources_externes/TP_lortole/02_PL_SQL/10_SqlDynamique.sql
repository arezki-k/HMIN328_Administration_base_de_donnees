variable reg varchar2(10);
execute :reg := '91';
SELECT chef_lieu FROM region WHERE reg = :reg
;

@10_01_SqlDynamique.sql 
