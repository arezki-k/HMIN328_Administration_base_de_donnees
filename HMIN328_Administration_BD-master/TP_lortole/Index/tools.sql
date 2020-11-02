drop type t_usertable ;

CREATE TYPE t_usertable IS TABLE OF VARCHAR2(50)
;
/

CREATE OR REPLACE PACKAGE Pkg_Tools
IS
  -- Procédures publiques
    procedure proc_get_table(arg_username in varchar2, rtn_usertable out t_usertable);
end Pkg_Tools ;
/

desc Pkg_Tools ;

CREATE OR REPLACE PACKAGE BODY Pkg_Tools IS
procedure proc_get_table (arg_username in varchar2 , rtn_usertable out t_usertable) is
TYPE t_usertable IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER ;
TYPE t_usertable_test IS REF CURSOR;  -- define weak REF CURSOR type
var_usertable   t_usertable_test;  -- declare cursor variable
var_table_name varchar2(30);
i integer :=0;
BEGIN OPEN var_usertable FOR
'SELECT owner, table_name
  FROM dba_tables
  where owner = '''||  arg_username || '''';
loop
FETCH var_usertable INTO var_table_name ;  -- fetch next row
EXIT WHEN var_usertable%NOTFOUND;  -- exit loop when last row is fetched
DBMS_OUTPUT.PUT_LINE('Record: ' || var_table_name);
rtn_usertable(i+1) := var_table_name;
DBMS_OUTPUT.PUT_LINE('Record: ' || rtn_usertable(i+1));
i:=i+1;
end loop ;
CLOSE var_usertable;
end proc_get_table;
end Pkg_Tools;
/

set serveroutput on ;

variable tables t_usertable
;
variable :=
execute Pkg_Tools.proc_get_table('LORTOLE',tables)
;
