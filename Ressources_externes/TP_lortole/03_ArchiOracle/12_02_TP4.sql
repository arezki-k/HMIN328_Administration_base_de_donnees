desc v$sga;
select * from v$sga ;


desc v$sgainfo;
select * from v$sgainfo ;


desc v$sgastat;
select * from v$sgastat ;

desc v$sql;
select * from v$sql ;

desc v$sqlarea;
select * from v$sqlarea ;

desc v$sqltext;
select * from v$sqltext ;


desc v$bgprocess ;
desc v$process ;

select p.pid, bg.name, bg.description, p.program
from v$bgprocess bg, v$process p
where bg.paddr = p.addr order by p.pid;


select name , value from v$parameter where name like 'shared%' ;