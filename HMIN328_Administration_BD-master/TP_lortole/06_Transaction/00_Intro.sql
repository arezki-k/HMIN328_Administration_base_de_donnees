GRANT INSERT, UPDATE ON Commune TO lortole;
GRANT ALL ON Commune TO public;
GRANT EXECUTE ON fonction_plsql TO public;

REVOKE INSERT, UPDATE ON Commune FROM lortole;
REVOKE ALL ON Commune FROM public;
REVOKE EXECUTE ON fonction_plsql FROM public;
