/*
Vous écrirez un curseur implicite qui permet d'afficher pour le département de l'Hérault (34), le
nombre d'habitants en 2010 (somme de tous les habitants de toutes les communes de l'Hérault)
*/

declare
pop_2010 float;
begin
select sum(pop_2010) into pop_2010 from Commune where dep like '02' ;
dbms_output.put_line('j affiche la population de '||pop_2010) ;
end ;
/

/*
2. Vous écrirez un curseur explicite qui permet de retourner le nombre d’habitants en 2010 département
par département
*/

declare
cursor mon_pop2010_dep is
select dep , sum(pop_2010) as pop from Commune group by dep ;
begin
for tup in mon_pop2010_dep
loop
dbms_output.put_line('j affiche la population de '||tup.dep||'    '||tup.pop) ;
end loop ;
end ;
/

/*
1. Vous écrirez un curseur explicite qui permet de retourner le nombre d’habitants année par année
et département par département
*/


declare
cursor  curs_nb_hab_com is
select com , pop_2010 from Commune;
begin
for tup in curs_nb_hab_com
loop
INSERT INTO population(valeurEstimee, annee , com)
VALUES
(tup.pop_2010, 2010 , tup.com);
end loop ;
end ;
/