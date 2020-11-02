set serveroutput on 

create or replace procedure  nbreLikers (numE in varchar, nombreAmis out integer)
as
nbre integer := 0;
begin
select count(numAmi) into nombreAmis from apprecie where numEtudiant=numE;
exception
when no_data_found then dbms_output.put_line('etudiant non reference '||numE);
when others  then  dbms_output.put_line('others ');
end;
/


declare
nbre integer;
begin
nbreLikers('20101234', nbre);
dbms_output.put_line('nombre amis : '||nbre);
end;
/



