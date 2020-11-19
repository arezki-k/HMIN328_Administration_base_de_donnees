set autotrace off

explain plan for select * from commune where code_insee like '34%' ;
select plan_table_output from table(dbms_xplan.display()) ;

explain plan for select code_insee from commune where code_insee like '34%' ;
select plan_table_output from table(dbms_xplan.display()) ;

explain plan for select code_insee from commune ;
select plan_table_output from table(dbms_xplan.display()) ;


set autotrace on

select code_insee from commune ;

select code_insee from commune where code_insee like '34%' ;

select * from commune where code_insee like '34%' ;

select R.nom_reg
from commune C , departement D , region R
where code_insee like '34%' and C.dep = D.dep and R.reg = D.reg ;
