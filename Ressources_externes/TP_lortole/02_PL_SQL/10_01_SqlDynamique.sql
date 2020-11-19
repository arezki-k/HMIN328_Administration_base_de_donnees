--DROP TABLE test
--;

create table test (
a varchar(5), b integer);

DESC test
;

create or replace procedure supp (tble_name in varchar)
is
begin
execute immediate 'drop table '||tble_name||' cascade
constraints';
dbms_output.put_line('table '||tble_name||' detruite ');
exception
when others then dbms_output.put_line('Pb sur la suppression ');
end;
/


execute supp('test');

DESC test 
;
