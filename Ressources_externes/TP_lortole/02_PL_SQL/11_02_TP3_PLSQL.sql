/*
Supprimer de Commune, les colonnes allant de pop 1975 à pop 2010 Vous pouvoir choisir soit
d'exécuter 36 fois la commande alter, soit de faire jouer du SQL dynamique au travers de la
commande execute immediate
*/

create or replace procedure supp_pop_col(beg in integer , en in integer)
is
annee integer;
begin
for annee in beg..en
loop
execute immediate 'alter table commune_new drop column pop_'||annee;
dbms_output.put_line('column pop_'||annee||' detruite ');
end loop ;
exception
when others then dbms_output.put_line('Pb sur la suppression ');
end;
/
execute supp_pop_col(1975,2010);

