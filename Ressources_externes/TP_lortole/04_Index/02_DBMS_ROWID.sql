/*
L'adresse de chaque enregistrement sur le disque (identifiant de ligne ou rowid) renferme diff ́erentes
informations `a l'exemple du num ́ero de l'enregistrement, du num ́ero de l'objet associ ́e (table ou index),
du bloc de donn ́ees qui contient cet enregistrement, ou de l'adresse relative du fichier qui contient les
blocs de donn ́ees. Le paquetage DBMS ROWID permet d'exploiter l'ensemble de cette information.
Des exemples vous sont donn ́es :
*/
DECLARE
object_no
integer;
row_no integer;
row_id ROWID;
BEGIN
SELECT ROWID INTO row_id FROM COMMUNE
WHERE code_insee = '34172';
object_no := DBMS_ROWID.ROWID_OBJECT(row_id);
row_no := DBMS_ROWID.ROWID_ROW_NUMBER(row_id);
DBMS_OUTPUT.PUT_LINE('The obj. # is '||object_no||' '||row_no);
END;
/


SELECT DBMS_ROWID.ROWID_BLOCK_NUMBER(rowid) as numBlock, DBMS_ROWID.ROWID_OBJECT(rowid) as numTable, nom_com
FROM Commune where code_insee = '34172';


SELECT DBMS_ROWID.ROWID_BLOCK_NUMBER(rowid) as numBlock, DBMS_ROWID.ROWID_OBJECT(rowid) as numTable, nom_com
FROM Commune where code_insee = '28109';



/*
Vous construirez une proc ́edure PL/SQL qui permet d'afficher tous les enregistrements (code_insee,
nom com) contenus dans le mˆeme bloc de donn ́ees qu'un enregistrement donn ́e de la table Commune
(par exemple l'enregistrement dont le code INSEE est 34172). Le nombre de tuples list ́es par bloc est
t'il en accord avec les informations collect ́ees dans la vue user tables
*/


SELECT DBMS_ROWID.ROWID_BLOCK_NUMBER(B.rowid) as numBlock,
DBMS_ROWID.ROWID_OBJECT(B.rowid) as numTable,
DBMS_ROWID.ROWID_ROW_NUMBER(A.rowid) as posBlock,
b.nom_com
FROM Commune A , Commune B
where A.code_insee = '34172'
and DBMS_ROWID.ROWID_ROW_NUMBER(A.rowid) = DBMS_ROWID.ROWID_ROW_NUMBER(B.rowid);

SELECT DBMS_ROWID.ROWID_BLOCK_NUMBER(B.rowid) as numBlock,
DBMS_ROWID.ROWID_OBJECT(B.rowid) as numTable,
DBMS_ROWID.ROWID_ROW_NUMBER(A.rowid) as posBlock,
b.nom_com
FROM Commune A , Commune B
where A.code_insee = '34172'
and DBMS_ROWID.ROWID_BLOCK_NUMBER(A.rowid) = DBMS_ROWID.ROWID_BLOCK_NUMBER(B.rowid);


create or replace procedure proc_get_commune_block (args_code_insee in varchar)
is
cursor get_commune_block is
SELECT DBMS_ROWID.ROWID_BLOCK_NUMBER(B.rowid) as numBlock,
DBMS_ROWID.ROWID_OBJECT(B.rowid) as numTable,
b.nom_com
FROM Commune A , Commune B
where A.code_insee = args_code_insee
and DBMS_ROWID.ROWID_BLOCK_NUMBER(A.rowid) = DBMS_ROWID.ROWID_BLOCK_NUMBER(B.rowid);
begin
for tup in get_commune_block
loop
dbms_output.put_line('get_commune_block '||tup.numBlock||'    '||tup.numTable||'    '||tup.nom_com) ;
end loop ;
end ;
/

set serveroutput on ;
execute proc_get_commune_block('34172');
/*
get_commune_block 360535    383165    MONTELS
get_commune_block 360535    383165    MONTESQUIEU
get_commune_block 360535    383165    MONTFERRIER-SUR-LEZ
get_commune_block 360535    383165    AUMES
get_commune_block 360535    383165    MONTOULIERS
get_commune_block 360535    383165    MONTOULIEU
get_commune_block 360535    383165    MONTPELLIER
get_commune_block 360535    383165    MONTPEYROUX
get_commune_block 360535    383165    MOULES-ET-BAUCELS
get_commune_block 360535    383165    MOUREZE
get_commune_block 360535    383165    MUDAISON
get_commune_block 360535    383165    MURLES
get_commune_block 360535    383165    MURVIEL-LES-BEZIERS
get_commune_block 360535    383165    MURVIEL-LES-MONTPELLIER
get_commune_block 360535    383165    AUTIGNAC
get_commune_block 360535    383165    NEBIAN
get_commune_block 360535    383165    NEFFIES
get_commune_block 360535    383165    NEZIGNAN-L'EVEQUE

PL/SQL procedure successfully completed.

*/


/*

select code_insee from commune where nom_com like 'AUTIGNAC' ;

CODE_I
------
34018


*/
execute proc_get_commune_block('34018');


/*

get_commune_block 360535    383165    MONTELS
get_commune_block 360535    383165    MONTESQUIEU
get_commune_block 360535    383165    MONTFERRIER-SUR-LEZ
get_commune_block 360535    383165    AUMES
get_commune_block 360535    383165    MONTOULIERS
get_commune_block 360535    383165    MONTOULIEU
get_commune_block 360535    383165    MONTPELLIER
get_commune_block 360535    383165    MONTPEYROUX
get_commune_block 360535    383165    MOULES-ET-BAUCELS
get_commune_block 360535    383165    MOUREZE
get_commune_block 360535    383165    MUDAISON
get_commune_block 360535    383165    MURLES
get_commune_block 360535    383165    MURVIEL-LES-BEZIERS
get_commune_block 360535    383165    MURVIEL-LES-MONTPELLIER
get_commune_block 360535    383165    AUTIGNAC
get_commune_block 360535    383165    NEBIAN
get_commune_block 360535    383165    NEFFIES
get_commune_block 360535    383165    NEZIGNAN-L'EVEQUE

PL/SQL procedure successfully completed.


*/

select blocks, avg_row_len from user_tables where table_name ='COMMUNE';




execute supp('test');
