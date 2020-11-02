--avoir la liste des colonnes
DESC table_name;
--mettre col for a20 pour chaque colonnes
set col_name for a20;

create or replace procedure colonnesLisibles(table_name in varchar)is
cursor columns IS DESC table_name; 
begin
FOR c in columns loop
    EXECUTE IMMEDIATE 'col '|| c ||' for a10';
END loop;
END
/


