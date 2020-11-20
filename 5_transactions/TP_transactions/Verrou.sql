set serveroutput on

create or replace procedure verrou
as
cursor C is select l.sid, username
from v$lock l, v$session s where block = 1 and l.sid = s.sid;
begin
for c_t in c
loop
dbms_output.put_line('le bloqueur est : '||c_t.sid||'  '||c_t.username);
end loop;
end;
/

-- appel procedure
exec verrou
