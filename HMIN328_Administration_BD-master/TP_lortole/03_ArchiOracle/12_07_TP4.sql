DECLARE
l_start NUMBER DEFAULT dbms_utility.get_time;
BEGIN
FOR i IN
(SELECT name
FROM
v$database)
LOOP
dbms_output.put_line ('name: '|| i.name);
END LOOP;
dbms_output.put_line(round( (dbms_utility.get_time-l_start)/100, 2 ) || ' seconds...');
END;
/