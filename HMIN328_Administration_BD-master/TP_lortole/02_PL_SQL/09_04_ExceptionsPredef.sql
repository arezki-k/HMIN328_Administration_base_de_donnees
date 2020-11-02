DECLARE
empTup EMP%ROWTYPE;
numEmp EMP.num%type;
salaireNul EMP.salaire%type;
salExc exception;
BEGIN
FOR numEmp IN 1..21
LOOP
SELECT * INTO empTup FROM EMP WHERE num = numEmp;
INSERT INTO EMP (num, nom, fonction) VALUES (empTup.num, empTup.nom, empTup.fonction);
if (empTup.salaire is null)
then raise salExc;
end if;
END LOOP;
EXCEPTION
WHEN salExc THEN DBMS_OUTPUT.PUT_LINE( 'salaire absent');
WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE( 'num inexistant ' || numEmp || ' '||
SQLERRM);
WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE( 'attention au schema !');
WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE( 'Contrainte PK Message SQL : ' ||
SQLERRM);
WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE( 'Contrainte PK Message SQL : ' || SQLCODE);
END;
/
