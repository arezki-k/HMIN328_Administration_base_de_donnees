
create or replace PROCEDURE print_columns (tab_name in VARCHAR) IS
   TYPE tabColTyp IS REF CURSOR;  -- define weak REF CURSOR type
   tv_cv   tabColTyp;  -- declare cursor variable
   col_name VARCHAR2(30);
  TYPE  columns_t IS TABLE OF VARCHAR2 (30) INDEX BY BINARY_INTEGER ;
   t_columns columns_t;
  i pls_integer :=0 ;
BEGIN
   OPEN tv_cv FOR  -- open cursor variable
      'SELECT  column_name  FROM user_tab_columns
                    WHERE table_name = '''||  tab_name || '''';
LOOP
   FETCH tv_cv INTO col_name ;  -- fetch next row
   EXIT WHEN tv_cv%NOTFOUND;  -- exit loop when last row is fetched
   DBMS_OUTPUT.PUT_LINE('Record: ' || col_name);
   t_columns(i+1) := col_name;
   DBMS_OUTPUT.PUT_LINE('Record: ' || t_columns(i+1));
   i:=i+1;
END LOOP;
      CLOSE tv_cv;
END;
/

exec print_columns ('EMP')

/*

Record: NUM
Record: NUM
Record: NOM
Record: NOM
Record: PRENOM
Record: PRENOM
Record: FONCTION
Record: FONCTION
Record: SALAIRE
Record: SALAIRE
Record: COMMISSION
Record: COMMISSION
Record: DATE_EMBAUCHE
Record: DATE_EMBAUCHE
Record: N_SUP
Record: N_SUP
Record: N_DEP
Record: N_DEP

PL/SQL procedure successfully completed.

*/
