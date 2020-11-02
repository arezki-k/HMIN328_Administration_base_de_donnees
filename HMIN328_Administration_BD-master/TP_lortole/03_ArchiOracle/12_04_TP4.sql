/*
Tous les ordres SQL (mais pas que) transitent par la mémoire ”LibraryCache”. Vous exploiterez
les vues afférentes à cette zone mémoire : v$sqlarea, v$sql et v$sql plan pour tracer et évaluer les
dernières requêtes traitées par le système. Différents exemples de requête (allant dans ce sens) sont
donnés
*/

select to_char(logon_time, 'DD/MM/YYYY HH24:MI:SS') , username, program, sql_text
from v$session , v$sqlarea
where v$session.sql_address = v$sqlarea.address
order by username, program;
select sql_id, disk_reads from v$sql where rownum <20 order by disk_reads desc;
select r.sql_id, disk_reads, elapsed_time, username from v$sql r, v$session s where
s.sql_id = r.sql_id and type='USER';
select parsing_schema_name, substr(sql_text,1,20) from v$sqlarea where
parsing_schema_name ='IMOUGENOT';
select sql_FullText,(cpu_time/100000) "Cpu Time (s)"
, (elapsed_time/1000000) "Elapsed time (s)"
, fetches,buffer_gets,disk_reads,executions
FROM v$sqlarea
WHERE
Parsing_Schema_Name ='IMOUGENOT'
AND rownum <50
order by 3 desc;