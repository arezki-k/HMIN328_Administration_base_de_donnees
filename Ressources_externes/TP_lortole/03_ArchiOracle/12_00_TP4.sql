
SELECT table_name,
comments
FROM dictionary
WHERE table_name like 'V$%'
ORDER BY table_name;
